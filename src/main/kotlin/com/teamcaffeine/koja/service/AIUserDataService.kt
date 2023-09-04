package com.teamcaffeine.koja.service

import com.google.gson.Gson
import com.teamcaffeine.koja.constants.ExceptionMessageConstant
import com.teamcaffeine.koja.dto.AIRequestBodyDTO
import com.teamcaffeine.koja.dto.AIUserEventDataDTO
import com.teamcaffeine.koja.dto.EncryptedData
import com.teamcaffeine.koja.dto.TimeSlot
import com.teamcaffeine.koja.dto.UserEventDTO
import com.teamcaffeine.koja.repository.UserAccountRepository
import com.teamcaffeine.koja.repository.UserRepository
import jakarta.transaction.Transactional
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.runBlocking
import okhttp3.MediaType.Companion.toMediaType
import okhttp3.OkHttpClient
import okhttp3.Request
import okhttp3.RequestBody.Companion.toRequestBody
import org.springframework.stereotype.Service
import software.amazon.awssdk.auth.credentials.AwsBasicCredentials
import software.amazon.awssdk.regions.Region
import software.amazon.awssdk.services.dynamodb.DynamoDbClient
import software.amazon.awssdk.services.dynamodb.model.*
import java.nio.file.Files
import java.nio.file.Paths
import java.security.KeyFactory
import java.security.PrivateKey
import java.security.spec.PKCS8EncodedKeySpec
import java.security.spec.X509EncodedKeySpec
import java.time.Duration
import java.time.OffsetDateTime
import java.time.ZoneOffset
import java.time.format.DateTimeFormatter
import java.util.*
import java.util.concurrent.TimeUnit
import javax.crypto.Cipher
import kotlin.collections.ArrayList

@Service
@Transactional
class AIUserDataService(private val userRepository: UserRepository, private val userAccountRepository: UserAccountRepository) {
    private val clientId = System.getProperty("GOOGLE_CLIENT_ID")
    private val clientSecret = System.getProperty("GOOGLE_CLIENT_SECRET")

    fun getUserEventData(authKey: String): MutableList<Map<String, ArrayList<AIUserEventDataDTO>>> {
        val userAccounts = userAccountRepository.findAll()
        val userEvents = ArrayList<UserEventDTO>()
        val results = mutableListOf<Map<String, ArrayList<AIUserEventDataDTO>>>()
        userAccounts.forEach { userAccount ->

            if (userAccount.refreshToken.isNotEmpty()) {
                val adapter =
                    CalendarAdapterFactoryService(userRepository, userAccountRepository).createCalendarAdapter(
                        userAccount.authProvider,
                    )

                val accessToken = adapter.refreshAccessToken(clientId, clientSecret, userAccount.refreshToken)
                val events = accessToken?.let { adapter.getUserEvents(it.getAccessToken()).values.toList() }
                if (!events.isNullOrEmpty()) {
                    val eventCategories = events.let { descriptionToCategories(events) }

                    for (i in events.indices) {
                        val event: UserEventDTO = events[i]
                        eventCategories!![i]?.let { events[i].setDescription(it) }
                    }

                    runBlocking {
                        events.forEach { event: UserEventDTO ->
                            launch(Dispatchers.IO) {
                                event.setUserID(userAccount.userID.toString())
                                val tempTimeSlots = mutableListOf<TimeSlot>()
                                val eventTimeslots = event.getTimeSlots()
                                if (eventTimeslots.isEmpty()) {
                                    tempTimeSlots.add(
                                        TimeSlot(
                                            "",
                                            event.getStartTime(),
                                            event.getEndTime(),
                                        ),
                                    )
                                } else {
                                    val eventDuration =
                                        Duration.between(event.getStartTime(), event.getEndTime()).seconds
                                    for (timeSlot in eventTimeslots) {
                                        val timeSlotDuration =
                                            Duration.between(timeSlot.startTime, timeSlot.endTime).seconds
                                        if (timeSlotDuration / eventDuration >= 2) {
                                            var timeSlotOffset = 0L
                                            while (timeSlot.startTime.plusSeconds(timeSlotOffset)
                                                    .isBefore(timeSlot.endTime)
                                            ) {
                                                tempTimeSlots.add(
                                                    TimeSlot(
                                                        "",
                                                        timeSlot.startTime.plusSeconds(timeSlotOffset),
                                                        timeSlot.startTime.plusSeconds(eventDuration),
                                                    ),
                                                )
                                                timeSlotOffset += eventDuration
                                            }
                                        } else {
                                            tempTimeSlots.add(
                                                TimeSlot(
                                                    "",
                                                    event.getStartTime(),
                                                    event.getEndTime(),
                                                ),
                                            )
                                        }
                                    }
                                }
                                event.setTimeSlots(tempTimeSlots)
                                userEvents.add(event)
                            }
                        }
                    }
                }

                userEvents.sortBy { it.getStartTime() }

                val eventSemesterMap = mutableMapOf<Int, List<UserEventDTO>>()
                var semesterNum = 1
                if (userEvents.isEmpty()) return@forEach
                var startTime = userEvents.first().getStartTime()
                var endTime = startTime.plusMonths(6)

                do {
                    val semesterEvents = userEvents.filter {
                        it.getStartTime().isBefore(endTime) && (
                            it.getStartTime().isAfter(startTime) || it.getStartTime()
                                .isEqual(startTime)
                            )
                    }

                    if (semesterEvents.isNotEmpty()) eventSemesterMap[semesterNum++] = semesterEvents
                    startTime = endTime
                    endTime = endTime.plusMonths(6)
                } while (endTime.isBefore(OffsetDateTime.now().plusMonths(6)))

                runBlocking {
                    eventSemesterMap.values.forEach { semester ->
                        launch(Dispatchers.IO) {
                            val semesterTrainingData = ArrayList<AIUserEventDataDTO>()
                            val semesterTestingData = ArrayList<AIUserEventDataDTO>()

                            val semesterTrainingDataSize = (semester.size * 0.8).toInt()
                            for (i in 0 until semesterTrainingDataSize) {
                                val timeSlots = getTimeslotPairList(semester, i)
                                semesterTrainingData.add(
                                    AIUserEventDataDTO(
                                        timeSlots,
                                        semester[i].getUserID(),
                                        semester[i].getDescription(),
                                        semester[i].getStartTime().dayOfWeek!!.toString(),
                                    ),
                                )
                            }

                            for (i in semesterTrainingDataSize until semester.size) {
                                val timeSlots = getTimeslotPairList(semester, i)
                                semesterTestingData.add(
                                    AIUserEventDataDTO(
                                        timeSlots,
                                        semester[i].getUserID(),
                                        semester[i].getDescription(),
                                        semester[i].getStartTime().dayOfWeek!!.toString(),
                                    ),
                                )
                            }

                            val contentMap = mapOf("training" to semesterTrainingData, "testing" to semesterTestingData)

                            results.add(contentMap)
                        }
                    }
                }
            }
        }
        return results
    }

    private fun getTimeslotPairList(
        semester: List<UserEventDTO>,
        i: Int,
    ): MutableList<Pair<String, String>> {
        val timeSlots = mutableListOf<Pair<String, String>>()
        val formatter = DateTimeFormatter.ofPattern("HH:mm")

        semester[i].getTimeSlots().forEach { timeSlot ->
            timeSlots.add(
                Pair(
                    timeSlot.startTime.withOffsetSameInstant(ZoneOffset.UTC).format(formatter),
                    timeSlot.endTime.withOffsetSameInstant(ZoneOffset.UTC).format(formatter),
                ),
            )
        }
        return timeSlots
    }

    fun descriptionToCategories(events: List<UserEventDTO>): Map<Int, String>? {
        val userEvents = mutableListOf<String>()
        for (event in events) {
            userEvents.add(event.getDescription().lowercase().trim())
        }

        val client = OkHttpClient.Builder()
            .readTimeout(40, TimeUnit.SECONDS)
            .build()

        val body = mutableMapOf<String, Any>()
        body["model"] = "text-davinci-003"
        body["max_tokens"] = 2048
        body["temperature"] = 0

        var prompt = "Please analyze this array: `["
        val eventsSize = events.size
        for (i in 0 until eventsSize - 1) {
            prompt += "'$i: ${userEvents[i]}', "
        }
        prompt += "'${userEvents.size - 1}: ${userEvents[userEvents.size - 1]}']`"
        prompt += "of calendar event descriptions and create a new array that classifies each event using these provided " +
            "categories: `['Conference', 'Seminar', 'Training', 'Webinar', 'Panel', 'Keynote', 'Symposium', 'Exhibition', " +
            "'Launch', 'Networking', 'Meeting', 'Retreat', 'Hackathon', 'Dinner', 'Charity', 'Fundraising', 'Awards', " +
            "'Concert', 'Festival', 'Performance', 'Theater', 'Screening', 'Dance', 'Comedy', 'Sports', 'Marathon', " +
            "'Tournament', 'Class', 'Lecture', 'Reading', 'Poetry', 'Fashion', 'Food', 'Tasting', 'Cultural', 'Fair', " +
            "'Parade', 'Wedding', 'Party', 'Anniversary', 'Birthday', 'Shower', 'Graduation', 'Reunion', 'Retirement', " +
            "'Holiday', 'Religious', 'Run/Walk', 'Volunteer', 'Community', 'Cleanup', 'Rally', 'Protest', 'Workshop', " +
            "'Recruitment', 'Mentorship', 'Auction', 'Cooking']`. It's important that no event is left uncategorized; " +
            "if it's not possible to determine an exact category, then assign an estimated one from the categories list " +
            "provided. The expected format for the response is ['1:<>', '2:<>', ...], where <> denotes the category " +
            "name from the given list of categories, and the number corresponds to the description in the event description array."

        body["prompt"] = prompt

        val gson = Gson()

        val json = gson.toJson(body)

        val mediaType = "application/json; charset=utf-8".toMediaType()
        val requestBody = json.toRequestBody(mediaType)

        val request = Request.Builder()
            .url("https://api.openai.com/v1/completions")
            .header("Authorization", "Bearer ${System.getProperty("OPENAI_API_KEY")}")
            .post(requestBody)
            .build()

        val response = client.newCall(request).execute()
        val responseMap = response.use { gson.fromJson(it.body?.string(), Map::class.java) }

        client.connectionPool.evictAll()

        val choices = responseMap["choices"] as List<*>
        val choice = choices[0] as Map<*, *>
        val text = choice["text"] as String

        val getArray = text.substringAfter("[").substringBefore("]")
        val array = getArray.split(", ")
        val mapOfItems = mutableMapOf<Int, String>()
        for (item in array) {
            val splitItem = item.split(":")
            mapOfItems[splitItem[0].trim().substringAfter("'").toInt()] = splitItem[1].trim().substringAfter(" ").substringBefore("'")
        }

        return mapOfItems
    }

    fun getDecryptedAIServerRequest(cypher: String): AIRequestBodyDTO {
        val privateKey = getSystemPrivateKey()
        val decrypted = decrypt(cypher, privateKey)
        val gson = Gson()
        val toReturn = gson.fromJson(decrypted, AIRequestBodyDTO::class.java)
        if (toReturn.encryptedData.kojaIDSecret != System.getProperty("KOJA_ID_SECRET")) {
            throw IllegalArgumentException(ExceptionMessageConstant.INVALID_STRUCTURE)
        }
        return toReturn
    }

    private fun decrypt(encryptedText: String, privateKey: PrivateKey): String {
        val cipher = Cipher.getInstance("RSA/ECB/PKCS1Padding", "BC")
        cipher.init(Cipher.DECRYPT_MODE, privateKey)
        return String(cipher.doFinal(Base64.getDecoder().decode(encryptedText)))
    }

    private fun loadPrivateKeyFromFile(filePath: String): PrivateKey {
        val pemContent = Files.readString(Paths.get(filePath))
        val content = pemContent.replace("-----BEGIN RSA PRIVATE KEY-----", "")
            .replace("-----END RSA PRIVATE KEY-----", "")
            .trim()

        val keyBytes = Base64.getDecoder().decode(content)
        val keyFactory = KeyFactory.getInstance("RSA")
        val keySpec = PKCS8EncodedKeySpec(keyBytes)
        return keyFactory.generatePrivate(keySpec)
    }

    private fun getSystemPrivateKey(): PrivateKey {
        return loadPrivateKeyFromFile("./private_key.pem")
    }

    fun getNewUserEmails(request: EncryptedData): ArrayList<String> {
        val userEmails = ArrayList<String>()
        val userIdsToDelete = ArrayList<Map<String, AttributeValue>>()

        val awsCreds = AwsBasicCredentials.create(
            System.getProperty("KOJA_AWS_DYNAMODB_ACCESS_KEY_ID"),
            System.getProperty("KOJA_AWS_DYNAMODB_ACCESS_KEY_SECRET"),
        )

        val dynamoDBClient = DynamoDbClient.builder()
            .region(Region.EU_NORTH_1)
            .credentialsProvider { awsCreds }
            .build()

        val scanRequest = ScanRequest.builder()
            .tableName("NewUsers")
            .build()

        val response = dynamoDBClient.scan(scanRequest)

        try {
            for (item in response.items()) {
                val userID = item["UserID"]?.s()
                if (userID != null) {
                    userAccountRepository.findByUserID(userID.toInt()).forEach {
                        userEmails.add(encrypt(it.email, request.publicKey))
                    }

                    userIdsToDelete.add(mapOf("UserID" to AttributeValue.builder().s(userID).build()))
                }
            }
            return userEmails
        } catch (e: Exception) {
            throw e
        } finally {
            removeOldEntries(userIdsToDelete, dynamoDBClient)
            dynamoDBClient.close()
        }
    }

    private fun encrypt(plainText: String, publicKeyString: String): String {
        val publicKeyPEM = publicKeyString.replace("-----BEGIN PUBLIC KEY-----", "")
            .replace("-----END PUBLIC KEY-----", "")
            .replace("\n", "")
            .replace("\r", "")

        val decodedKey = Base64.getDecoder().decode(publicKeyPEM)
        val keySpec = X509EncodedKeySpec(decodedKey)
        val keyFactory = KeyFactory.getInstance("RSA")
        val publicKey = keyFactory.generatePublic(keySpec)

        val cipher = Cipher.getInstance("RSA/ECB/PKCS1Padding")
        cipher.init(Cipher.ENCRYPT_MODE, publicKey)

        val encryptedBytes = cipher.doFinal(plainText.toByteArray())
        return Base64.getEncoder().encodeToString(encryptedBytes)
    }

    private fun removeOldEntries(
        userIdsToDelete: ArrayList<Map<String, AttributeValue>>,
        dynamoDBClient: DynamoDbClient,
    ) {
        if (userIdsToDelete.isNotEmpty()) {
            val writeRequests = userIdsToDelete.map {
                WriteRequest.builder().deleteRequest(DeleteRequest.builder().key(it).build()).build()
            }

            val batchWriteItemRequest = BatchWriteItemRequest.builder()
                .requestItems(mapOf("NewUsers" to writeRequests))
                .build()

            dynamoDBClient.batchWriteItem(batchWriteItemRequest)
        }
    }
}

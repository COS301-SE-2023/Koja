package com.teamcaffeine.koja.service

import com.teamcaffeine.koja.constants.EnvironmentVariableConstant
import com.teamcaffeine.koja.dto.AIUserEventDataDTO
import com.teamcaffeine.koja.dto.EncryptedData
import com.teamcaffeine.koja.dto.TimeSlot
import com.teamcaffeine.koja.dto.UserEventDTO
import com.teamcaffeine.koja.entity.UserAccount
import com.teamcaffeine.koja.repository.UserAccountRepository
import com.teamcaffeine.koja.repository.UserRepository
import jakarta.transaction.Transactional
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.runBlocking
import org.springframework.stereotype.Service
import software.amazon.awssdk.auth.credentials.AwsBasicCredentials
import software.amazon.awssdk.regions.Region
import software.amazon.awssdk.services.dynamodb.DynamoDbClient
import software.amazon.awssdk.services.dynamodb.model.AttributeValue
import software.amazon.awssdk.services.dynamodb.model.BatchWriteItemRequest
import software.amazon.awssdk.services.dynamodb.model.DeleteRequest
import software.amazon.awssdk.services.dynamodb.model.QueryRequest
import software.amazon.awssdk.services.dynamodb.model.ScanRequest
import software.amazon.awssdk.services.dynamodb.model.WriteRequest
import java.time.Duration
import java.time.OffsetDateTime
import java.time.ZoneOffset
import java.time.format.DateTimeFormatter
import java.util.Base64

@Service
@Transactional
class AIUserDataService(private val userRepository: UserRepository, private val userAccountRepository: UserAccountRepository, private val cryptoService: CryptoService) {
    private val clientId = System.getProperty(EnvironmentVariableConstant.GOOGLE_CLIENT_ID)
    private val clientSecret = System.getProperty(EnvironmentVariableConstant.GOOGLE_CLIENT_SECRET)

    private fun getTimeslotPairList(
        semester: List<UserEventDTO>,
        i: Int,
        request: EncryptedData,
    ): MutableList<Pair<String, String>> {
        val timeSlots = mutableListOf<Pair<String, String>>()
        val formatter = DateTimeFormatter.ofPattern("HH:mm")

        semester[i].getTimeSlots().forEach { timeSlot ->
            timeSlots.add(
                Pair(
                    cryptoService.encryptPlainText(
                        timeSlot.startTime.withOffsetSameInstant(ZoneOffset.UTC).format(formatter),
                        request.publicKey,
                    ),
                    cryptoService.encryptPlainText(
                        timeSlot.endTime.withOffsetSameInstant(ZoneOffset.UTC).format(formatter),
                        request.publicKey,
                    ),
                ),
            )
        }
        return timeSlots
    }

    fun getUserEvents(userEmail: String, request: EncryptedData): MutableList<Map<String, ArrayList<AIUserEventDataDTO>>> {
        val aiTrainingEvents = mutableListOf<Map<String, ArrayList<AIUserEventDataDTO>>>()
        val userEvents = ArrayList<UserEventDTO>()

        val userAccount = userAccountRepository.findByEmail(userEmail)
        if (userAccount != null) {
            val userID = userAccount.userID.toString()
            val existingUser = userHasRecommendations(userID)
            val userAccountRefreshToken = userAccount.refreshToken
            if (userAccountRefreshToken.isNotEmpty()) {
                val events = getUserRelevantEvents(userAccount, existingUser)
                createEventTimeframes(events, userID, userEvents)
                userEvents.sortBy { it.getStartTime() }
                val eventSemesterMap = mutableMapOf<Int, List<UserEventDTO>>()
                prepareForTraining(userEvents, eventSemesterMap, aiTrainingEvents, request)
            }
        }

        return aiTrainingEvents
    }

    private fun getUserRelevantEvents(
        userAccount: UserAccount,
        existingUser: Boolean,
    ): List<UserEventDTO>? {
        val adapter =
            CalendarAdapterFactoryService(userRepository, userAccountRepository).createCalendarAdapter(
                userAccount.authProvider,
            )

        val accessToken = adapter.refreshAccessToken(clientId, clientSecret, userAccount.refreshToken)
        val events = accessToken?.let {
            if (existingUser) {
                adapter.getUserEventsInRange(
                    it.getAccessToken(),
                    OffsetDateTime.now().minusDays(7),
                    OffsetDateTime.now(),
                )
            } else {
                adapter.getUserEvents(it.getAccessToken()).values.toList()
            }
        }
        return events
    }

    private fun prepareForTraining(
        userEvents: ArrayList<UserEventDTO>,
        eventSemesterMap: MutableMap<Int, List<UserEventDTO>>,
        aiTrainingEvents: MutableList<Map<String, ArrayList<AIUserEventDataDTO>>>,
        request: EncryptedData,
    ) {
        var semesterNum = 1
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
                        val timeSlots = getTimeslotPairList(semester, i, request)
                        addEventToSemester(semesterTrainingData, timeSlots, semester, i, request.publicKey)
                    }

                    for (i in semesterTrainingDataSize until semester.size) {
                        val timeSlots = getTimeslotPairList(semester, i, request)
                        addEventToSemester(semesterTestingData, timeSlots, semester, i, request.publicKey)
                    }

                    val contentMap = mapOf("training" to semesterTrainingData, "testing" to semesterTestingData)

                    aiTrainingEvents.add(contentMap)
                }
            }
        }
    }

    private fun addEventToSemester(
        semesterTrainingData: ArrayList<AIUserEventDataDTO>,
        timeSlots: MutableList<Pair<String, String>>,
        semester: List<UserEventDTO>,
        i: Int,
        publicKey: String,
    ) {
        semesterTrainingData.add(
            AIUserEventDataDTO(
                timeSlots,
                cryptoService.encryptPlainText(semester[i].getUserID(), publicKey),
                cryptoService.encryptPlainText(semester[i].getSummary(), publicKey),
                cryptoService.encryptPlainText(semester[i].getStartTime().dayOfWeek!!.toString(), publicKey),
            ),
        )
    }

    private fun createEventTimeframes(
        events: List<UserEventDTO>?,
        userID: String,
        userEvents: ArrayList<UserEventDTO>,
    ) {
        if (!events.isNullOrEmpty()) {
            runBlocking {
                events.forEach { event: UserEventDTO ->
                    launch(Dispatchers.IO) {
                        event.setUserID(userID)
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
    }

    private fun decrypt(encryptedText: String): String {
        val decryptedByteArray = cryptoService.decryptData(encryptedText)
        return String(decryptedByteArray)
    }

    fun getNewUserEmails(request: EncryptedData): ArrayList<String> {
        val userEmails = ArrayList<String>()
        val userIdsToDelete = ArrayList<Map<String, AttributeValue>>()

        val awsCreds = AwsBasicCredentials.create(
            System.getProperty(EnvironmentVariableConstant.KOJA_AWS_DYNAMODB_ACCESS_KEY_ID),
            System.getProperty(EnvironmentVariableConstant.KOJA_AWS_DYNAMODB_ACCESS_KEY_SECRET),
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
                        val encryptedEmail = cryptoService.encryptData(it.email.toByteArray(), request.publicKey)
                        userEmails.add(
                            Base64.getEncoder().encodeToString(encryptedEmail),
                        )
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

    fun getAllUserEmails(request: EncryptedData): ArrayList<String> {
        val userEmails = ArrayList<String>()
        userAccountRepository.findAll().forEach {
            userEmails.add(
                cryptoService.encryptPlainText(
                    it.email,
                    request.publicKey,
                ),
            )
        }
        return userEmails
    }

    fun validateKojaSecretID(id: String): Boolean {
        val decrypted = decrypt(id)
        return decrypted == System.getProperty(EnvironmentVariableConstant.KOJA_ID_SECRET)
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

    private fun userHasRecommendations(userID: String): Boolean {
        val awsCreds = AwsBasicCredentials.create(
            System.getProperty(EnvironmentVariableConstant.KOJA_AWS_DYNAMODB_ACCESS_KEY_ID),
            System.getProperty(EnvironmentVariableConstant.KOJA_AWS_DYNAMODB_ACCESS_KEY_SECRET),
        )

        val dynamoDBClient = DynamoDbClient.builder()
            .region(Region.EU_NORTH_1)
            .credentialsProvider { awsCreds }
            .build()

        val attrValues = mutableMapOf<String, AttributeValue>()
        attrValues[":v_user"] = AttributeValue.builder().s(userID).build()

        val attrNames = mutableMapOf<String, String>()
        attrNames["#n_user"] = "user"

        val request = QueryRequest.builder()
            .tableName("Koja-AI")
            .keyConditionExpression("#n_user = :v_user") // Query for items with matching "userID"
            .expressionAttributeValues(attrValues)
            .expressionAttributeNames(attrNames)
            .build()

        val response = dynamoDBClient.query(request)
        val items = response.items()

        return items.isNotEmpty()
    }
}

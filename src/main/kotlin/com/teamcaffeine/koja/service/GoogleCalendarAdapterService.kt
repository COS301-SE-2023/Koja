package com.teamcaffeine.koja.service

import com.fasterxml.jackson.databind.ObjectMapper
import com.google.api.client.googleapis.auth.oauth2.GoogleAuthorizationCodeFlow
import com.google.api.client.googleapis.auth.oauth2.GoogleClientSecrets
import com.google.api.client.googleapis.auth.oauth2.GoogleCredential
import com.google.api.client.googleapis.auth.oauth2.GoogleTokenResponse
import com.google.api.client.googleapis.javanet.GoogleNetHttpTransport
import com.google.api.client.json.JsonFactory
import com.google.api.client.json.jackson2.JacksonFactory
import com.google.api.client.util.DateTime
import com.google.api.services.calendar.model.Event
import com.google.api.services.calendar.model.EventDateTime
import com.google.api.services.calendar.model.Events
import com.google.api.services.people.v1.PeopleService
import com.google.gson.GsonBuilder
import com.google.gson.JsonElement
import com.google.gson.JsonPrimitive
import com.google.gson.JsonSerializationContext
import com.google.gson.JsonSerializer
import com.teamcaffeine.koja.constants.ExceptionMessageConstant
import com.teamcaffeine.koja.controller.TokenManagerController
import com.teamcaffeine.koja.controller.TokenManagerController.Companion.createToken
import com.teamcaffeine.koja.controller.TokenRequest
import com.teamcaffeine.koja.dto.JWTAuthDetailsDTO
import com.teamcaffeine.koja.dto.JWTGoogleDTO
import com.teamcaffeine.koja.dto.UserEventDTO
import com.teamcaffeine.koja.entity.User
import com.teamcaffeine.koja.entity.UserAccount
import com.teamcaffeine.koja.enums.AuthProviderEnum
import com.teamcaffeine.koja.repository.UserAccountRepository
import com.teamcaffeine.koja.repository.UserRepository
import io.jsonwebtoken.ExpiredJwtException
import jakarta.servlet.http.HttpServletRequest
import org.springframework.http.HttpEntity
import org.springframework.http.HttpMethod
import org.springframework.http.MediaType
import org.springframework.stereotype.Service
import org.springframework.util.LinkedMultiValueMap
import org.springframework.web.client.RestTemplate
import org.springframework.web.servlet.view.RedirectView
import org.springframework.web.util.UriComponentsBuilder
import java.lang.reflect.Type
import java.time.OffsetDateTime
import java.time.ZoneId
import java.time.format.DateTimeFormatter
import java.util.Base64
import kotlin.collections.ArrayList
import com.google.api.services.calendar.Calendar as GoogleCalendar

@Service
class GoogleCalendarAdapterService(
    private val userRepository: UserRepository,
    private val userAccountRepository: UserAccountRepository,
) : CalendarAdapterService(AuthProviderEnum.GOOGLE) {
    private val httpTransport = GoogleNetHttpTransport.newTrustedTransport()
    private val jsonFactory: JsonFactory = JacksonFactory.getDefaultInstance()
    private val clientId = System.getProperty("GOOGLE_CLIENT_ID")
    private val clientSecret = System.getProperty("GOOGLE_CLIENT_SECRET")
    private val redirectUriBase = "http://localhost:8080/api/v1/auth"
    private val scopes = listOf(
        "https://www.googleapis.com/auth/calendar",
        "https://www.googleapis.com/auth/userinfo.profile",
        "https://www.googleapis.com/auth/userinfo.email",
    )
    private val clientSecrets: GoogleClientSecrets = GoogleClientSecrets().setWeb(
        GoogleClientSecrets.Details().setClientId(clientId).setClientSecret(clientSecret),
    )
    private val flow: GoogleAuthorizationCodeFlow =
        GoogleAuthorizationCodeFlow.Builder(httpTransport, jsonFactory, clientSecrets, scopes)
            .setAccessType("offline")
            .build()

    override fun setupConnection(
        request: HttpServletRequest?,
        appCallBack: Boolean,
        addAdditionalAccount: Boolean,
        token: String,
    ): RedirectView {
        val redirectURI = if (appCallBack && !addAdditionalAccount) {
            "$redirectUriBase/app/google/callback"
        } else if (!addAdditionalAccount) {
            "$redirectUriBase/google/callback"
        } else {
            "http://localhost:8080/api/v1/user/auth/add-email/callback"
        }

        val url = if (!addAdditionalAccount) {
            flow.newAuthorizationUrl()
                .setRedirectUri(redirectURI)
                .setState(request?.session?.id)
                .build()
        } else {
            val flow = GoogleAuthorizationCodeFlow.Builder(
                httpTransport,
                jsonFactory,
                clientId,
                clientSecret,
                scopes,
            )
                .setAccessType("offline")
                .setApprovalPrompt("force")
                .build()

            flow.newAuthorizationUrl()
                .setRedirectUri(redirectURI)
                .setState(token) // Set state parameter here
                .build()
        }

        return RedirectView(url)
    }

    override fun authorize(): String? {
        // You can implement this method based on your requirements
        return null
    }

    override fun oauth2Callback(authCode: String?, appCallBack: Boolean): String {
        val restTemplate = RestTemplate()
        val tokenEndpointUrl = "https://oauth2.googleapis.com/token"

        val headers = org.springframework.http.HttpHeaders()
        headers.contentType = MediaType.APPLICATION_FORM_URLENCODED
        headers.set("Accept", MediaType.APPLICATION_JSON_VALUE)

        val parameters = LinkedMultiValueMap<String, String>()
        parameters.add("grant_type", "authorization_code")
        parameters.add("code", authCode)
        parameters.add("client_id", System.getProperty("GOOGLE_CLIENT_ID"))
        parameters.add("client_secret", System.getProperty("GOOGLE_CLIENT_SECRET"))
        if (!appCallBack) {
            parameters.add("redirect_uri", "http://localhost:8080/api/v1/auth/google/callback")
        } else {
            parameters.add("redirect_uri", "http://localhost:8080/api/v1/auth/app/google/callback")
        }

        val requestEntity = HttpEntity(parameters, headers)

        val builder = UriComponentsBuilder
            .fromHttpUrl(tokenEndpointUrl)
            .queryParams(parameters)
        val requestUrl = builder.build().encode().toUri()
        val responseEntity = restTemplate.exchange(requestUrl, HttpMethod.POST, requestEntity, String::class.java)

        val responseJson = ObjectMapper().readTree(responseEntity.body)
        val accessToken = responseJson.get("access_token").asText()
        val refreshToken = responseJson.get("refresh_token")?.asText()
        val expiresIn = responseJson.get("expires_in").asLong()

        val userEmail = getUserEmail(accessToken) ?: throw Exception("Failed to get user email")
        val existingUser: UserAccount? = userAccountRepository.findByEmail(userEmail)

        val jwtToken: String
        if (existingUser != null) {
            val userTokens = emptyArray<JWTAuthDetailsDTO>().toMutableList()
            val existingUserAccounts = userAccountRepository.findByUserID(existingUser.userID)

            for (userAccount in existingUserAccounts) {
                val updatedCredentials = refreshAccessToken(clientId, clientSecret, userAccount.refreshToken)
                if (updatedCredentials != null) {
                    userTokens.add(
                        JWTGoogleDTO(
                            updatedCredentials.getAccessToken(),
                            userAccount.refreshToken,
                            updatedCredentials.expireTimeInSeconds,
                        ),
                    )
                } else {
                    userTokens.add(
                        JWTGoogleDTO(
                            accessToken,
                            userAccount.refreshToken,
                            expiresIn,
                        ),
                    )
                }
            }

            jwtToken = createToken(
                TokenRequest(
                    userTokens,
                    this.getAuthProvider(),
                    existingUser.userID,
                ),
            )
        } else {
            val newUser = createNewUser(userEmail, refreshToken)

            jwtToken = createToken(
                TokenRequest(
                    arrayOf(JWTGoogleDTO(accessToken, refreshToken ?: "", expiresIn)).toList(),
                    this.getAuthProvider(),
                    newUser.id!!,
                ),
            )
        }

        return jwtToken
    }

    fun addAnotherEmailOauth2Callback(authCode: String?, token: String?, appCallBack: Boolean): String {
        val restTemplate = RestTemplate()
        val tokenEndpointUrl = "https://oauth2.googleapis.com/token"

        val headers = org.springframework.http.HttpHeaders()
        headers.contentType = MediaType.APPLICATION_FORM_URLENCODED
        headers.set("Accept", MediaType.APPLICATION_JSON_VALUE)

        val parameters = LinkedMultiValueMap<String, String>()
        parameters.add("grant_type", "authorization_code")
        parameters.add("code", authCode)
        parameters.add("client_id", System.getProperty("GOOGLE_CLIENT_ID"))
        parameters.add("client_secret", System.getProperty("GOOGLE_CLIENT_SECRET"))
        parameters.add("redirect_uri", "http://localhost:8080/api/v1/user/auth/add-email/callback")

        val requestEntity = HttpEntity(parameters, headers)

        val builder = UriComponentsBuilder
            .fromHttpUrl(tokenEndpointUrl)
            .queryParams(parameters)
        val requestUrl = builder.build().encode().toUri()
        val responseEntity = restTemplate.exchange(requestUrl, HttpMethod.POST, requestEntity, String::class.java)

        val responseJson = ObjectMapper().readTree(responseEntity.body)
        val accessToken = responseJson.get("access_token").asText()
        val refreshToken = responseJson.get("refresh_token")?.asText()
        val expiresIn = responseJson.get("expires_in").asLong()

        val userEmail = getUserEmail(accessToken) ?: throw Exception("Failed to get user email")
        val existingUser: UserAccount? = userAccountRepository.findByEmail(userEmail)

        val jwtToken: String
        if (existingUser != null) {
            throw Exception("Email already exits.")
        } else {
            if (token == null) {
                throw Exception("Token is not set.")
            }
            val jwtTokenData = TokenManagerController.getUserJWTTokenData(token)
            val storedUser = userRepository.findById(jwtTokenData.userID)
            addUserEmail(userEmail, refreshToken, storedUser.get())

            val existingUserAccounts = storedUser.get().id?.let { userAccountRepository.findByUserID(it) }
            val userTokens = emptyArray<JWTAuthDetailsDTO>().toMutableList()
            if (existingUserAccounts != null) {
                for (userAccount in existingUserAccounts) {
                    val updatedCredentials = refreshAccessToken(clientId, clientSecret, userAccount.refreshToken)
                    if (updatedCredentials != null) {
                        userTokens.add(
                            JWTGoogleDTO(
                                updatedCredentials.getAccessToken(),
                                userAccount.refreshToken,
                                updatedCredentials.expireTimeInSeconds,
                            ),
                        )
                    } else {
                        userTokens.add(
                            JWTGoogleDTO(
                                accessToken,
                                userAccount.refreshToken,
                                expiresIn,
                            ),
                        )
                    }
                }
            }

            jwtToken = createToken(
                TokenRequest(
                    userTokens,
                    this.getAuthProvider(),
                    storedUser.get().id!!,
                ),
            )
        }

        return jwtToken
    }

    private fun createNewUser(userEmail: String, refreshToken: String?): User {
        val newUser = User()
        newUser.setCurrentLocation(.0, .0)
        newUser.setHomeLocation("Uninitialised")
        newUser.setWorkLocation("Uninitialised")
        val storedUser = userRepository.save(newUser)

        val newUserAccount = UserAccount()
        newUserAccount.email = userEmail
        newUserAccount.refreshToken = refreshToken ?: ""
        newUserAccount.authProvider = AuthProviderEnum.GOOGLE
        newUserAccount.userID = storedUser.id!!
        newUserAccount.user = storedUser
        val savedUserAccount = userAccountRepository.save(newUserAccount)

        storedUser.userAccounts.add(savedUserAccount)
        userRepository.save(storedUser)
        return newUser
    }

    private fun addUserEmail(newUserEmail: String, refreshToken: String?, storedUser: User) {
        val newUserAccount = UserAccount()
        newUserAccount.email = newUserEmail
        newUserAccount.refreshToken = refreshToken ?: ""
        newUserAccount.authProvider = AuthProviderEnum.GOOGLE
        newUserAccount.userID = storedUser.id!!
        newUserAccount.user = storedUser
        userAccountRepository.save(newUserAccount)

        storedUser.userAccounts.add(newUserAccount)
        userRepository.save(storedUser)
    }

    override fun getUserEvents(accessToken: String): Map<String, UserEventDTO> {
        try {
            val calendar = buildCalendarService(accessToken)

            val request = calendar.events().list("primary")
                .setOrderBy("startTime")
                .setSingleEvents(true)
                .setMaxResults(1000)

            val events: Events? = request.execute()

            val userEvents = mutableMapOf<String, UserEventDTO>()

            events?.items?.map {
                val eventSummary = it.summary ?: ""
                val eventStartTime = it.start.dateTime ?: it.start.date
                val eventEndTime = it.end.dateTime ?: it.end.date
                val key = Base64.getEncoder().encodeToString("${eventSummary.trim()}${eventStartTime}$eventEndTime".trim().toByteArray())
                userEvents[key] = UserEventDTO(it)
            }

            return userEvents
        } catch (e: ExpiredJwtException) {
            return emptyMap()
        }
    }

    override fun getUserEmail(accessToken: String): String? {
        val credential = GoogleCredential().setAccessToken(accessToken)
        val peopleService = PeopleService.Builder(
            GoogleNetHttpTransport.newTrustedTransport(),
            JacksonFactory.getDefaultInstance(),
            credential,
        ).setApplicationName("KOJA")
            .build()

        val person = peopleService.people().get("people/me")
            .setPersonFields("emailAddresses")
            .execute()

        return person.emailAddresses?.firstOrNull()?.value
    }

    private fun refreshAccessToken(clientId: String, clientSecret: String, refreshToken: String): JWTGoogleDTO? {
        if (refreshToken.isNotEmpty()) {
            val tokenResponse = GoogleTokenResponse().setRefreshToken(refreshToken)

            val credential = GoogleCredential.Builder()
                .setJsonFactory(jsonFactory)
                .setTransport(httpTransport)
                .setClientSecrets(clientId, clientSecret)
                .build()
                .setFromTokenResponse(tokenResponse)

            try {
                credential.refreshToken()
            } catch (exception: Exception) {
                return null
            }

            if (credential.accessToken != null) {
                return JWTGoogleDTO(
                    accessToken = credential.accessToken,
                    expireTimeInSeconds = credential.expiresInSeconds,
                    refreshToken = refreshToken,
                )
            }
        }
        return null
    }

    override fun createEvent(accessToken: String, eventDTO: UserEventDTO): Event {
        val calendarService = buildCalendarService(accessToken)

        val eventStartTime = eventDTO.getStartTime()
        val eventEndTime = eventDTO.getEndTime()

        val startDateTime = DateTime(eventStartTime.format(DateTimeFormatter.ISO_OFFSET_DATE_TIME))
        val endDateTime = DateTime(eventEndTime.format(DateTimeFormatter.ISO_OFFSET_DATE_TIME))

        val event = Event()
            .setSummary(eventDTO.getSummary())
            .setLocation(eventDTO.getLocation())
            .setStart(EventDateTime().setDateTime(startDateTime).setTimeZone(eventStartTime.toZonedDateTime().zone.id))
            .setEnd(EventDateTime().setDateTime(endDateTime).setTimeZone(eventEndTime.toZonedDateTime().zone.toString()))

        val extendedPropertiesMap = mutableMapOf<String, String>()

        if (eventDTO.isDynamic()) {
            extendedPropertiesMap["dynamic"] = "true"
        }

        extendedPropertiesMap["duration"] = eventDTO.getDurationInMilliseconds().toString()
        extendedPropertiesMap["priority"] = eventDTO.getPriority().toString()

        val gson = GsonBuilder()
            .registerTypeAdapter(OffsetDateTime::class.java, OffsetDateTimeAdapter())
            .create()
        val timeSlotsJson = gson.toJson(eventDTO.getTimeSlots())
        extendedPropertiesMap["timeSlots"] = timeSlotsJson

        event.extendedProperties = Event.ExtendedProperties().apply {
            shared = extendedPropertiesMap
        }

        val calendarId = "primary"
        val createdEvent = calendarService.events().insert(calendarId, event).execute()
        println("Event created: ${createdEvent.htmlLink}")
        return createdEvent
    }

    override fun updateEvent(accessToken: String, eventDTO: UserEventDTO): Event {
        deleteEvent(accessToken, eventDTO.getId())
        return createEvent(accessToken, eventDTO)
//        val calendarService = buildCalendarService(accessToken)
//
//        val calendarId = "primary"
//
//        val event: Event = calendarService.events().get(calendarId, eventDTO.getId()).execute()
//
//        event.setSummary(eventDTO.getDescription())
//            .setLocation(eventDTO.getLocation())
//            .setStart(EventDateTime().setDateTime(DateTime(eventDTO.getStartTime().toInstant().toString())))
//            .setEnd(EventDateTime().setDateTime(DateTime(eventDTO.getEndTime().toInstant().toString())))
//
//        val extendedPropertiesMap = mutableMapOf<String, String>()
//
//        if (eventDTO.isDynamic()) {
//            extendedPropertiesMap["dynamic"] = "true"
//        }
//
//        extendedPropertiesMap["duration"] = eventDTO.getDurationInMilliseconds().toString()
//        extendedPropertiesMap["priority"] = eventDTO.getPriority().toString()
//
//        val gson = Gson()
//        val timeSlotsJson = gson.toJson(eventDTO.getTimeSlots())
//        extendedPropertiesMap["timeSlots"] = timeSlotsJson
//
//        event.extendedProperties = Event.ExtendedProperties().apply {
//            shared = extendedPropertiesMap
//        }
//
//        val updatedEvent = calendarService.events().update(calendarId, eventDTO.getId(), event).execute()
//        println("Event Updated: ${updatedEvent.htmlLink}")
//        return updatedEvent
    }

    override fun deleteEvent(accessToken: String, eventID: String): Boolean {
        val calendarService = buildCalendarService(accessToken)
        val calendarId = "primary"

        try {
            calendarService.events().delete(calendarId, eventID).execute()
        } catch (e: Exception) {
            return false
        }
        return true
    }

    override fun getFutureEventsLocations(accessToken: String?): List<String> {
        if (accessToken == null) throw IllegalArgumentException(ExceptionMessageConstant.REQUIRED_PARAMETERS_MISSING)
        val toReturn = mutableListOf<String>()
        val eventsInRange = getUserEventsInRange(accessToken, OffsetDateTime.now().minusDays(1), OffsetDateTime.now().plusYears(1))
        eventsInRange.forEach {
            if (it.getEndTime().isAfter(OffsetDateTime.now().minusDays(1))) {
                if (!toReturn.contains(it.getLocation())) {
                    toReturn.add(it.getLocation())
                }
            }
        }
        return toReturn
    }

    private fun buildCalendarService(accessToken: String): GoogleCalendar {
        val httpTransport = GoogleNetHttpTransport.newTrustedTransport()
        val jsonFactory = JacksonFactory.getDefaultInstance()
        val credential = GoogleCredential().setAccessToken(accessToken)

        return GoogleCalendar.Builder(httpTransport, jsonFactory, credential)
            .setApplicationName("Koja")
            .build()
    }

    override fun getUserEventsInRange(accessToken: String?, startDate: OffsetDateTime?, endDate: OffsetDateTime?): List<UserEventDTO> {
        if (accessToken == null || startDate == null || endDate == null) {
            return emptyList()
        }

        try {
            val calendar = buildCalendarService(accessToken)

            val startDateTime = DateTime(startDate.format(DateTimeFormatter.ISO_OFFSET_DATE_TIME))
            val endDateTime = DateTime(endDate.format(DateTimeFormatter.ISO_OFFSET_DATE_TIME))

            val request = calendar.events().list("primary")
                .setTimeMin(startDateTime)
                .setTimeMax(endDateTime)
                .setOrderBy("startTime")
                .setSingleEvents(true)
                .setMaxResults(1000)

            val events: Events? = request.execute()

            val userEvents = ArrayList<UserEventDTO>()

            events?.items?.map {
                userEvents.add(UserEventDTO(it))
            }

            return userEvents
        } catch (e: ExpiredJwtException) {
            return emptyList()
        }
    }

    private fun findTimeZoneIdForOffset(offsetDateTime: OffsetDateTime): ZoneId {
        val offset = offsetDateTime.offset
        return ZoneId.systemDefault().rules.getValidOffsets(offsetDateTime.toLocalDateTime())
            .find { it == offset }
            ?.let { ZoneId.ofOffset("UTC", it) }
            ?: ZoneId.of("UTC")
    }
}

class OffsetDateTimeAdapter : JsonSerializer<OffsetDateTime> {
    override fun serialize(src: OffsetDateTime, typeOfSrc: Type, context: JsonSerializationContext): JsonElement {
        return JsonPrimitive(src.toString())
    }
}

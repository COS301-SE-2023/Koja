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
import com.google.api.services.calendar.model.Calendar
import com.google.api.services.calendar.model.Event
import com.google.api.services.calendar.model.EventDateTime
import com.google.api.services.calendar.model.Events
import com.google.api.services.people.v1.PeopleService
import com.google.gson.GsonBuilder
import com.google.gson.JsonElement
import com.google.gson.JsonPrimitive
import com.google.gson.JsonSerializationContext
import com.google.gson.JsonSerializer
import com.google.maps.GeoApiContext
import com.google.maps.TimeZoneApi
import com.teamcaffeine.koja.constants.ExceptionMessageConstant
import com.teamcaffeine.koja.constants.Frequency
import com.teamcaffeine.koja.controller.TokenManagerController
import com.teamcaffeine.koja.controller.TokenManagerController.Companion.createToken
import com.teamcaffeine.koja.controller.TokenRequest
import com.teamcaffeine.koja.dto.JWTAuthDetailsDTO
import com.teamcaffeine.koja.dto.JWTGoogleDTO
import com.teamcaffeine.koja.dto.UserEventDTO
import com.teamcaffeine.koja.entity.TimeBoundary
import com.teamcaffeine.koja.entity.User
import com.teamcaffeine.koja.entity.UserAccount
import com.teamcaffeine.koja.enums.AuthProviderEnum
import com.teamcaffeine.koja.enums.CallbackConfigEnum
import com.teamcaffeine.koja.enums.TimeBoundaryType
import com.teamcaffeine.koja.repository.UserAccountRepository
import com.teamcaffeine.koja.repository.UserRepository
import io.jsonwebtoken.ExpiredJwtException
import jakarta.servlet.http.HttpServletRequest
import org.springframework.beans.factory.annotation.Autowired
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
    private val serverAddress = "${System.getProperty("SERVER_ADDRESS")}:${System.getProperty("SERVER_PORT")}"
    private val redirectUriBase = "$serverAddress/api/v1/auth"
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
        deviceType: CallbackConfigEnum,
        addAdditionalAccount: Boolean,
        token: String,
    ): RedirectView {
        val redirectURI = if (deviceType == CallbackConfigEnum.WEB) {
            "$redirectUriBase/google/callback"
        } else if (deviceType == CallbackConfigEnum.MOBILE) {
            "$redirectUriBase/app/google/callback"
        } else if (deviceType == CallbackConfigEnum.DESKTOP) {
            "$redirectUriBase/desktop/google/callback"
        } else if (deviceType == CallbackConfigEnum.ADD_EMAIL) {
            "$serverAddress/api/v1/user/auth/add-email/callback"
        } else {
            throw Exception(ExceptionMessageConstant.INVALID_DEVICE_TYPE)
        }

        val url = if (!addAdditionalAccount) {
            flow.newAuthorizationUrl()
                .setRedirectUri(redirectURI)
                .setState(request?.session?.id)
                .setScopes(scopes)
                .setAccessType("offline")
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

    override fun oauth2Callback(authCode: String?, deviceType: CallbackConfigEnum): String {
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

        if (deviceType == CallbackConfigEnum.WEB) {
            parameters.add("redirect_uri", "$serverAddress/api/v1/auth/google/callback")
        } else if (deviceType == CallbackConfigEnum.MOBILE) {
            parameters.add("redirect_uri", "$serverAddress/api/v1/auth/app/google/callback")
        } else if (deviceType == CallbackConfigEnum.DESKTOP) {
            parameters.add("redirect_uri", "$serverAddress/api/v1/auth/desktop/google/callback")
        } else if (deviceType == CallbackConfigEnum.ADD_EMAIL) {
            parameters.add("redirect_uri", "$serverAddress/api/v1/user/auth/add-email/callback")
        } else {
            throw Exception(ExceptionMessageConstant.INVALID_DEVICE_TYPE)
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
            val timeBoundary = TimeBoundary(
                name = "Bed-Time",
                startTime = "20:00",
                endTime = "06:00",
                type = TimeBoundaryType.BLOCKED,
            )
            newUser.addTimeBoundary(timeBoundary)
            timeBoundary.user = newUser
            userRepository.save(newUser)

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
        parameters.add("redirect_uri", "$serverAddress/api/v1/user/auth/add-email/callback")

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
                val key = Base64.getEncoder()
                    .encodeToString("${eventSummary.trim()}${eventStartTime}$eventEndTime".trim().toByteArray())
                userEvents[key] = UserEventDTO(it)
            }

            return userEvents
        } catch (e: ExpiredJwtException) {
            return emptyMap()
        }
    }

    fun getUserEventsKojaSuggestions(accessToken: String): Map<String, UserEventDTO> {
        try {
            val calendar = buildCalendarService(accessToken)

            val request = calendar.events().list("Koja-Suggestions")
                .setOrderBy("startTime")
                .setSingleEvents(true)
                .setMaxResults(1000)

            val events: Events? = request.execute()

            val userEvents = mutableMapOf<String, UserEventDTO>()

            events?.items?.map {
                val eventSummary = it.summary ?: ""
                val eventStartTime = it.start.dateTime ?: it.start.date
                val eventEndTime = it.end.dateTime ?: it.end.date
                val key = Base64.getEncoder()
                    .encodeToString("${eventSummary.trim()}${eventStartTime}$eventEndTime".trim().toByteArray())
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

    override fun refreshAccessToken(clientId: String, clientSecret: String, refreshToken: String): JWTGoogleDTO? {
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

    override fun createEvent(accessToken: String, eventDTO: UserEventDTO, jwtToken: String): Event {
        val calendarService = buildCalendarService(accessToken)

        val eventStartTime = eventDTO.getStartTime()
        val eventEndTime = eventDTO.getEndTime()

        val startDateTime = DateTime(eventStartTime.format(DateTimeFormatter.ISO_OFFSET_DATE_TIME))
        val endDateTime = DateTime(eventEndTime.format(DateTimeFormatter.ISO_OFFSET_DATE_TIME))

        val context = GeoApiContext.Builder()
            .apiKey(System.getProperty("API_KEY"))
            .build()

        val userLocations = LocationService(userRepository, this)
        val userLocation = userLocations.getUserSavedLocations(jwtToken)["currentLocation"] as Pair<*, *>
        val lat = userLocation.second.toString().toDouble()
        val lng = userLocation.first.toString().toDouble()
        val travelTime = eventDTO.getTravelTime()

        val timezone = TimeZoneApi.getTimeZone(context, com.google.maps.model.LatLng(40.7128, 74.0060)).await()
        val eventLocaltime = eventStartTime.toZonedDateTime()
            .withZoneSameInstant(timezone.toZoneId())
            .plusSeconds(travelTime)

        val formattedTime = DateTimeFormatter
            .ofPattern("HH:mm")
            .format(eventLocaltime)

        val description = "${eventDTO.getDescription()} \n" +
            "\n" +
            "Event Start Time: ${formattedTime}\n" +
            "Travel Time: ${secondsToHumanFormat(travelTime)}\n"
        if (eventDTO.getRecurrence()?.get(0) == "Daily") {
            eventDTO.setRecurrence(mutableListOf(Frequency.DAILY))
        } else if (eventDTO.getRecurrence()?.get(0) == "Weekly") {
            eventDTO.setRecurrence(mutableListOf(Frequency.WEEKLY))
        } else if (eventDTO.getRecurrence()?.get(0) == "Monthly") {
            eventDTO.setRecurrence(mutableListOf(Frequency.MONTHLY))
        } else if (eventDTO.getRecurrence()?.get(0) == "Yearly") {
            eventDTO.setRecurrence(mutableListOf(Frequency.YEARLY))
        }
        val event = Event()
            .setSummary(eventDTO.getSummary())
            .setDescription(description)
            .setLocation(eventDTO.getLocation())
            .setStart(EventDateTime().setDateTime(startDateTime).setTimeZone(eventStartTime.toZonedDateTime().zone.id))
            .setEnd(EventDateTime().setDateTime(endDateTime).setTimeZone(eventEndTime.toZonedDateTime().zone.toString()))
            .setRecurrence(eventDTO.getRecurrence())

        val extendedPropertiesMap = mutableMapOf<String, String>()
        // TODO: Shift extended properties to values in the description
        if (eventDTO.isDynamic()) {
            extendedPropertiesMap["dynamic"] = "true"
        }

        extendedPropertiesMap["duration"] = eventDTO.getDurationInMilliseconds().toString()
        extendedPropertiesMap["priority"] = eventDTO.getPriority().toString()
        extendedPropertiesMap["travelTime"] = eventDTO.getTravelTime().toString()

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

    fun createEventInSuggestions(accessToken: String, eventDTO: UserEventDTO, jwtToken: String): Event {
        val calendarService = buildCalendarService(accessToken)

        val eventStartTime = eventDTO.getStartTime()
        val eventEndTime = eventDTO.getEndTime()

        val startDateTime = DateTime(eventStartTime.format(DateTimeFormatter.ISO_OFFSET_DATE_TIME))
        val endDateTime = DateTime(eventEndTime.format(DateTimeFormatter.ISO_OFFSET_DATE_TIME))

        val context = GeoApiContext.Builder()
            .apiKey(System.getProperty("API_KEY"))
            .build()

        val userLocations = LocationService(userRepository, this)
        val userLocation = userLocations.getUserSavedLocations(jwtToken)["currentLocation"] as Pair<*, *>
        val lat = userLocation.second.toString().toDouble()
        val lng = userLocation.first.toString().toDouble()
        val travelTime = eventDTO.getTravelTime()

        val timezone = TimeZoneApi.getTimeZone(context, com.google.maps.model.LatLng(lat, lng)).await()
        val eventLocaltime = eventStartTime.toZonedDateTime()
            .withZoneSameInstant(timezone.toZoneId())
            .plusSeconds(travelTime)

        val formattedTime = DateTimeFormatter
            .ofPattern("HH:mm")
            .format(eventLocaltime)

        val description = "${eventDTO.getDescription()} \n" +
            "\n" +
            "Event Start Time: ${formattedTime}\n" +
            "Travel Time: ${secondsToHumanFormat(travelTime)}\n"

        val event = Event()
            .setSummary(eventDTO.getSummary())
            .setDescription(description)
            .setLocation(eventDTO.getLocation())
            .setStart(EventDateTime().setDateTime(startDateTime).setTimeZone(eventStartTime.toZonedDateTime().zone.id))
            .setEnd(
                EventDateTime().setDateTime(endDateTime).setTimeZone(eventEndTime.toZonedDateTime().zone.toString()),
            )

        val extendedPropertiesMap = mutableMapOf<String, String>()
        // TODO: Shift extended properties to values in the description
        if (eventDTO.isDynamic()) {
            extendedPropertiesMap["dynamic"] = "true"
        }

        extendedPropertiesMap["duration"] = eventDTO.getDurationInMilliseconds().toString()
        extendedPropertiesMap["priority"] = eventDTO.getPriority().toString()
        extendedPropertiesMap["travelTime"] = eventDTO.getTravelTime().toString()

        val gson = GsonBuilder()
            .registerTypeAdapter(OffsetDateTime::class.java, OffsetDateTimeAdapter())
            .create()
        val timeSlotsJson = gson.toJson(eventDTO.getTimeSlots())
        extendedPropertiesMap["timeSlots"] = timeSlotsJson

        event.extendedProperties = Event.ExtendedProperties().apply {
            shared = extendedPropertiesMap
        }

        val calendarId = "Koja-Suggestions"
        val createdEvent = calendarService.events().insert(calendarId, event).execute()
        println("Event created: ${createdEvent.htmlLink}")
        return createdEvent
    }

    override fun updateEvent(accessToken: String, eventDTO: UserEventDTO): Event {
        deleteEvent(accessToken, eventDTO.getId())
        // TODO: Fix this, also needs JWT token, not the accessToken
        return createEvent(accessToken, eventDTO, accessToken)
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
        val eventsInRange =
            getUserEventsInRange(accessToken, OffsetDateTime.now().minusDays(1), OffsetDateTime.now().plusYears(1))
        eventsInRange.forEach {
            if (it.getEndTime().isAfter(OffsetDateTime.now().minusDays(1))) {
                if (!toReturn.contains(it.getLocation())) {
                    toReturn.add(it.getLocation())
                }
            }
        }
        return toReturn
    }

    private fun secondsToHumanFormat(seconds: Long): String {
        if (seconds < 0) {
            throw IllegalArgumentException("Seconds cannot be negative.")
        }

        val hours = seconds / 3600
        val minutes = (seconds % 3600) / 60
        val remainingSeconds = seconds % 60

        return when {
            hours > 0 -> String.format("%02dh %02dm %02ds", hours, minutes, remainingSeconds)
            minutes > 0 -> String.format("%02dm %02ds", minutes, remainingSeconds)
            else -> String.format("%02ds", remainingSeconds)
        }
    }

    fun buildCalendarService(accessToken: String): GoogleCalendar {
        val httpTransport = GoogleNetHttpTransport.newTrustedTransport()
        val jsonFactory = JacksonFactory.getDefaultInstance()
        val credential = GoogleCredential().setAccessToken(accessToken)

        return GoogleCalendar.Builder(httpTransport, jsonFactory, credential)
            .setApplicationName("Koja")
            .build()
    }

    override fun getUserEventsInRange(
        accessToken: String?,
        startDate: OffsetDateTime?,
        endDate: OffsetDateTime?,
    ): List<UserEventDTO> {
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

    fun createNewCalendar(accessToken: String, eventList: List<UserEventDTO>): Calendar {
        val calendar = buildCalendarService(accessToken)
        val newCalendar = Calendar()
        newCalendar.summary = "This calendar serves as Koja's generated calendar to optimize your schedule with suggestions."
        newCalendar.id = "Koja-Suggestions"
        calendar.calendars().delete(newCalendar.id).execute()
        calendar.calendars().insert(newCalendar).execute()
        for (event in eventList) {
            createEventInSuggestions(accessToken, event, accessToken)
        }
        return newCalendar
    }
}
class TimezoneUtility() {

    @Autowired
    private lateinit var userRepository: UserRepository

    @Autowired
    private lateinit var googleCalendarAdapterService: GoogleCalendarAdapterService
    fun getTimeOfTimeZone(jwtToken: String): String? {
        val context = GeoApiContext.Builder()
            .apiKey(System.getProperty("API_KEY"))
            .build()
        val userLocations = LocationService(userRepository, googleCalendarAdapterService)
        val userLocation = userLocations.getUserSavedLocations(jwtToken)["currentLocation"] as Pair<*, *>
        val lat = userLocation.second.toString().toDouble()
        val lng = userLocation.first.toString().toDouble()
        return TimeZoneApi.getTimeZone(context, com.google.maps.model.LatLng(lat, lng)).await().toString()
    }
}

class OffsetDateTimeAdapter : JsonSerializer<OffsetDateTime> {
    override fun serialize(src: OffsetDateTime, typeOfSrc: Type, context: JsonSerializationContext): JsonElement {
        return JsonPrimitive(src.toString())
    }
}

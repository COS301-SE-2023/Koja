package com.teamcaffeine.koja.service

import com.fasterxml.jackson.databind.ObjectMapper
import com.google.api.client.googleapis.auth.oauth2.GoogleAuthorizationCodeFlow
import com.google.api.client.googleapis.auth.oauth2.GoogleClientSecrets
import com.google.api.client.googleapis.auth.oauth2.GoogleCredential
import com.google.api.client.googleapis.javanet.GoogleNetHttpTransport
import com.google.api.client.json.JsonFactory
import com.google.api.client.json.jackson2.JacksonFactory
import com.google.api.services.calendar.CalendarScopes
import com.google.api.services.calendar.model.Events
import com.google.api.services.people.v1.PeopleService
import com.teamcaffeine.koja.controller.TokenManagerController
import com.teamcaffeine.koja.controller.TokenManagerController.Companion.decodeJwtToken
import com.teamcaffeine.koja.controller.TokenRequest
import com.teamcaffeine.koja.entity.User
import com.teamcaffeine.koja.entity.UserAccount
import com.teamcaffeine.koja.enums.AuthProviderEnum
import com.teamcaffeine.koja.enums.JWTTokenStructure
import com.teamcaffeine.koja.repository.UserAccountRepository
import com.teamcaffeine.koja.repository.UserRepository
import io.jsonwebtoken.ExpiredJwtException
import jakarta.servlet.http.HttpServletRequest
import org.springframework.http.HttpEntity
import org.springframework.http.HttpMethod
import org.springframework.http.MediaType
import org.springframework.http.ResponseEntity
import org.springframework.stereotype.Service
import org.springframework.util.LinkedMultiValueMap
import org.springframework.web.client.RestTemplate
import org.springframework.web.servlet.view.RedirectView
import org.springframework.web.util.UriComponentsBuilder
import com.google.api.client.util.DateTime as GoogleDateTime
import com.google.api.services.calendar.Calendar as GoogleCalendar

@Service
class GoogleCalendarAdapterService(private val userRepository: UserRepository, private val userAccountRepository: UserAccountRepository) : CalendarAdapterService(AuthProviderEnum.GOOGLE) {
    private val httpTransport = GoogleNetHttpTransport.newTrustedTransport()
    private val jsonFactory: JsonFactory = JacksonFactory.getDefaultInstance()
    private val clientId = System.getProperty("GOOGLE_CLIENT_ID")
    private val clientSecret = System.getProperty("GOOGLE_CLIENT_SECRET")
    private val redirectUri = "http://localhost:8080/auth/google/callback"
    private val scopes = listOf("https://www.googleapis.com/auth/calendar.readonly")
    private val clientSecrets: GoogleClientSecrets = GoogleClientSecrets().setWeb(
        GoogleClientSecrets.Details().setClientId(clientId).setClientSecret(clientSecret)
    )
    private val flow: GoogleAuthorizationCodeFlow =
        GoogleAuthorizationCodeFlow.Builder(httpTransport, jsonFactory, clientSecrets, scopes)
            .setAccessType("offline")
            .build()


    override fun setupConnection(request: HttpServletRequest?): RedirectView {
        val url = flow.newAuthorizationUrl()
            .setRedirectUri(redirectUri)
            .setState(request?.session?.id)
            .build()

        return RedirectView(url)
    }

    override fun authorize(): String? {
        // You can implement this method based on your requirements
        return null
    }

    override fun oauth2Callback(authCode: String?): ResponseEntity<String> {
        val restTemplate = RestTemplate()
        val tokenEndpointUrl = "https://oauth2.googleapis.com/token"

        val headers = org.springframework.http.HttpHeaders()
        headers.contentType = MediaType.APPLICATION_FORM_URLENCODED
        headers.set("Accept", MediaType.APPLICATION_JSON_VALUE)

        val parameters = LinkedMultiValueMap<String, String>()
        parameters.add("grant_type", "authorization_code")
        parameters.add("code", authCode)
        parameters.add("client_id",  System.getProperty("GOOGLE_CLIENT_ID"))
        parameters.add("client_secret",  System.getProperty("GOOGLE_CLIENT_SECRET"))
        parameters.add("redirect_uri", "http://localhost:8080/auth/google/callback")

        val requestEntity = HttpEntity(parameters, headers)

        val builder = UriComponentsBuilder.fromHttpUrl(tokenEndpointUrl)
            .queryParams(parameters)
        val requestUrl = builder.build().encode().toUri()

        val responseEntity = restTemplate.exchange(requestUrl, HttpMethod.POST, requestEntity, String::class.java)
        val responseJson = ObjectMapper().readTree(responseEntity.body)
        val accessToken = responseJson.get("access_token").asText()
        val refreshToken = responseJson.get("refresh_token")?.asText()
        val expiresIn = responseJson.get("expires_in").asLong()

        val userEmail = getUserEmail(accessToken) ?: throw Exception("Failed to get user email")
        val existingUser : UserAccount? = userAccountRepository.findByEmail(userEmail)
        val jwtToken: String
        if (existingUser != null) {
            jwtToken = TokenManagerController().createToken(
                TokenRequest(
                    accessToken,
                    refreshToken ?: "",
                    expiresIn,
                    this.getAuthProvider(),
                    existingUser.userID
                )
            )

            return ResponseEntity.ok(jwtToken)
        }
        else
        {
            val newUser = createNewUser(userEmail, refreshToken)

            jwtToken = TokenManagerController().createToken(
                TokenRequest(
                    accessToken,
                    refreshToken ?: "",
                    expiresIn,
                    this.getAuthProvider(),
                    newUser.id!!
                )
            )
        }

        return ResponseEntity.ok(jwtToken)
    }

    private fun createNewUser(userEmail: String, refreshToken: String?): User {
        val newUser = User()
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

    override fun getEvents(): Set<UserEventService>? {
        // You can implement this method based on your requirements
        return null
    }

    override fun getUserEvents(jwtToken: String): List<UserEventService> {
        try {
            val decodedJwt = decodeJwtToken(jwtToken)

            val accessToken = decodedJwt.getClaim(JWTTokenStructure.ACCESS_TOKEN.claimName).asString()

            val credential = GoogleCredential().setAccessToken(accessToken).createScoped(listOf(CalendarScopes.CALENDAR_READONLY))

            val calendar = GoogleCalendar.Builder(httpTransport, jsonFactory, credential)
                .setApplicationName("Your Application Name")
                .build()

            val now = GoogleDateTime(System.currentTimeMillis())
            val request = calendar.events().list("primary")
                .setOrderBy("startTime")
                .setSingleEvents(true)
                .setMaxResults(1000)

            val events: Events? = request.execute()

            val userEvents = ArrayList<UserEventService>()

            events?.items?.map {
                userEvents.add(UserEventService(it))
            }

            return userEvents

        } catch (e: ExpiredJwtException) {
            return emptyList()
        }
    }

    private fun getUserEmail(accessToken: String): String? {
        val credential = GoogleCredential().setAccessToken(accessToken)
        val peopleService = PeopleService.Builder(
            GoogleNetHttpTransport.newTrustedTransport(),
            JacksonFactory.getDefaultInstance(),
            credential
        ).setApplicationName("KOJA")
        .build()

        val person = peopleService.people().get("people/me")
            .setPersonFields("emailAddresses")
            .execute()

        return person.emailAddresses?.firstOrNull()?.value
    }
}

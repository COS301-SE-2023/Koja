package com.teamcaffeine.koja.entity

import com.fasterxml.jackson.databind.ObjectMapper
import com.google.api.client.googleapis.auth.oauth2.GoogleAuthorizationCodeFlow
import com.google.api.client.googleapis.auth.oauth2.GoogleClientSecrets
import com.google.api.client.googleapis.javanet.GoogleNetHttpTransport
import com.google.api.client.json.JsonFactory
import com.google.api.client.json.jackson2.JacksonFactory
import jakarta.servlet.http.HttpServletRequest
import org.springframework.http.HttpEntity
import org.springframework.http.HttpMethod
import org.springframework.http.MediaType
import org.springframework.http.ResponseEntity
import org.springframework.util.LinkedMultiValueMap
import org.springframework.web.client.RestTemplate
import org.springframework.web.servlet.view.RedirectView
import org.springframework.web.util.UriComponentsBuilder

class GoogleCalendarAdapter : CalendarAdapter {
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

        return ResponseEntity.ok("OAuth 2.0 callback completed successfully")
    }

    override fun getEvents(): Set<com.teamcaffeine.koja.entity.UserEvent?>? {
        // You can implement this method based on your requirements
        return null
    }

    override fun getUserEvents(userId: String?): List<UserEvent> {
//        val credential = GoogleCredential().setAccessToken(accessToken).createScoped(listOf(CalendarScopes.CALENDAR_READONLY))
//
//        // Create a Calendar object using the credential
//        val calendar = Calendar.Builder(httpTransport, jsonFactory, credential)
//            .setApplicationName("Your Application Name")
//            .build()
//
//        // Define the request to get userEvents from the user's primary calendar
//        val now = DateTime(System.currentTimeMillis())
//        val request = calendar.events().list("primary")
//            .setTimeMin(now)
//            .setOrderBy("startTime")
//            .setSingleEvents(true)
//            .setMaxResults(10)
//
//        // Execute the request and retrieve the userEvents
//        val events: GoogleEvents = request.execute()

        return emptyList()
    }
}

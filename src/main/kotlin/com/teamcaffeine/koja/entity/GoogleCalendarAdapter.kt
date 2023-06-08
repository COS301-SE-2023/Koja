package com.teamcaffeine.koja.entity

import com.fasterxml.jackson.databind.ObjectMapper
import com.google.api.client.googleapis.auth.oauth2.GoogleAuthorizationCodeFlow
import com.google.api.client.googleapis.auth.oauth2.GoogleClientSecrets
import com.google.api.client.googleapis.javanet.GoogleNetHttpTransport
import com.google.api.client.json.JsonFactory
import com.google.api.client.json.jackson2.JacksonFactory
import jakarta.servlet.http.HttpServletRequest
import org.springframework.http.HttpEntity
import org.springframework.http.MediaType
import org.springframework.http.ResponseEntity
import org.springframework.util.LinkedMultiValueMap
import org.springframework.web.client.RestTemplate
import org.springframework.web.servlet.view.RedirectView

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
        val parameters = LinkedMultiValueMap<String, String>()
        parameters.add("grant_type", "authorization_code")
        parameters.add("code", authCode)
        parameters.add("client_id", "GOOGLE_CLIENT_ID")
        parameters.add("client_secret", "GOOGLE_CLIENT_SECRET")
        parameters.add("redirect_uri", "http://localhost:8080/auth/google/response/access_token")

        val headers = org.springframework.http.HttpHeaders()
        headers.contentType = MediaType.APPLICATION_FORM_URLENCODED
        val requestEntity = HttpEntity(parameters, headers)

        val responseEntity = restTemplate.postForEntity(tokenEndpointUrl, requestEntity, String::class.java)
        val responseJson = ObjectMapper().readTree(responseEntity.body)
        val accessToken = responseJson.get("access_token").asText()
        val refreshToken = responseJson.get("refresh_token")?.asText()
        val expiresIn = responseJson.get("expires_in").asLong()

        return ResponseEntity.ok("OAuth 2.0 callback completed successfully")
    }

    override fun getEvents(): Set<com.teamcaffeine.koja.entity.Event?>? {
        // You can implement this method based on your requirements
        return null
    }

    override fun getUserEvents(userId: String?): List<com.teamcaffeine.koja.entity.Event> {
        // You can implement this method based on your requirements
        return emptyList()
    }
}

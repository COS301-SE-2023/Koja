package com.teamcaffeine.koja.entity

import com.google.api.client.googleapis.auth.oauth2.GoogleAuthorizationCodeFlow
import com.google.api.client.googleapis.auth.oauth2.GoogleClientSecrets
import com.google.api.client.googleapis.javanet.GoogleNetHttpTransport
import com.google.api.client.json.JsonFactory
import com.google.api.client.json.jackson2.JacksonFactory
import jakarta.servlet.http.HttpServletRequest
import org.springframework.http.ResponseEntity
import org.springframework.web.servlet.view.RedirectView

class GoogleCalendarAdapter : CalendarAdapter {
    private val httpTransport = GoogleNetHttpTransport.newTrustedTransport()
    private val jsonFactory: JsonFactory = JacksonFactory.getDefaultInstance()
    private val clientId = System.getProperty("GOOGLE_CLIENT_ID")
    private val clientSecret = System.getProperty("GOOGLE_CLIENT_SECRET")
    private val redirectUri = "http://localhost:8080/oauth2callback"
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

    override fun oauth2Callback(authCode: String?): ResponseEntity<String?>? {
        // You can implement this method based on your requirements
        return null
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

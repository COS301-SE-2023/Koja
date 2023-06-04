package com.teamcaffeine.koja.entity

import com.google.api.client.auth.oauth2.AuthorizationCodeRequestUrl
import com.google.api.client.auth.oauth2.Credential
import com.google.api.client.auth.oauth2.TokenResponse
import com.google.api.client.googleapis.auth.oauth2.GoogleAuthorizationCodeFlow
import com.google.api.client.googleapis.auth.oauth2.GoogleClientSecrets
import com.google.api.client.googleapis.javanet.GoogleNetHttpTransport
import com.google.api.client.http.HttpTransport
import com.google.api.client.json.JsonFactory
import com.google.api.client.json.jackson2.JacksonFactory
import com.google.api.client.util.DateTime
import com.google.api.services.calendar.Calendar
import com.google.api.services.calendar.CalendarScopes
import com.google.api.services.calendar.model.Events
import com.teamcaffeine.koja.entity.Event
import jakarta.servlet.http.HttpServletRequest
import org.apache.commons.logging.LogFactory
import org.springframework.beans.factory.annotation.Value
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.web.servlet.view.RedirectView
import java.util.*


class GoogleCalendarAdapter() : CalendarAdapter {

    var clientSecrets: GoogleClientSecrets? = null
    var flow: GoogleAuthorizationCodeFlow? = null
    var credential: Credential? = null

    @Value("\${google.client.client-id}")
    private val clientId: String? = null

    @Value("\${google.client.client-secret}")
    private val clientSecret: String? = null

    @Value("\${google.client.redirectUri}")
    private val redirectURI: String? = null


    var googleEvents: Set<com.google.api.services.calendar.model.Event> = HashSet()
    val date1 = DateTime("2023-05-01T16:30:00.000+05:30")
    val date2 = DateTime(Date())
    val userMap = {};

    override fun setupConnection(request: HttpServletRequest?): RedirectView {
        return RedirectView(authorize())
    }

    override fun authorize(): String {
        val authorizationUrl: AuthorizationCodeRequestUrl
        if (flow == null) {
            val web = GoogleClientSecrets.Details()
            web.clientId = clientId
            web.clientSecret = clientSecret
            clientSecrets = GoogleClientSecrets().setWeb(web)
            httpTransport = GoogleNetHttpTransport.newTrustedTransport()
            flow = GoogleAuthorizationCodeFlow.Builder(
                httpTransport,
                JSON_FACTORY,
                clientSecrets,
                setOf(CalendarScopes.CALENDAR)
            ).build()
        }
        authorizationUrl = flow!!.newAuthorizationUrl().setRedirectUri(redirectURI)
        println("cal authorizationUrl->$authorizationUrl")
        return authorizationUrl.build()


    }

    companion object {
        private val logger = LogFactory.getLog(
            GoogleCalendarAdapter::class.java
        )
        private val APPLICATION_NAME = ""
        private var httpTransport: HttpTransport? = null
        private val JSON_FACTORY: JsonFactory = JacksonFactory.getDefaultInstance()
        private var client: Calendar? = null
    }


    override fun oauth2Callback(code: String?): ResponseEntity<String?>? {
        val eventList: Events
        var message = ""
        try {
            val response: TokenResponse = flow!!.newTokenRequest(code).setRedirectUri(redirectURI).execute()
            credential = flow!!.createAndStoreCredential(response, "userID")
            client = Calendar.Builder(httpTransport, JSON_FACTORY, credential)
                .setApplicationName(APPLICATION_NAME).build()
            val calendar = client as? Calendar
            if(calendar != null){
                eventList =  calendar.events().list("primary").setTimeMin(date1).setTimeMax(date2).execute()
                val events: List<com.google.api.services.calendar.model.Event> = eventList.items
                message = events.toString()

            }

        } catch (e: Exception) {
            logger.warn(
                "Exception while handling OAuth2 callback (" + e.message + ")."
                        + " Redirecting to google connection status page."
            )
            message = ("Exception while handling OAuth2 callback (" + e.message + ")."
                    + " Redirecting to google connection status page.")
        }
        println("cal message: " + message)
        return ResponseEntity(message, HttpStatus.OK)
    }

    override fun getEvents(): Set<Event?>? {
        TODO("Not yet implemented")
    }

    override fun getUserEvents(userId: String?): List<Event> {
        return emptyList();
    }
}

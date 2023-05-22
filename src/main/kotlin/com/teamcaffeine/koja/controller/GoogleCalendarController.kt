package com.teamcaffeine.koja.controller

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
import com.google.api.services.calendar.model.Event
import com.google.api.services.calendar.model.Events
import jakarta.servlet.http.HttpServletRequest
import org.apache.commons.logging.LogFactory
import org.springframework.beans.factory.annotation.Value
import org.springframework.data.repository.query.Param
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.stereotype.Controller
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RequestParam
import org.springframework.web.servlet.view.RedirectView
import java.io.IOException
import java.util.*


@Controller
class GoogleCalendarController() {
    var clientSecrets: GoogleClientSecrets? = null
    var flow: GoogleAuthorizationCodeFlow? = null
    var credential: Credential? = null

    @Value("\${google.client.client-id}")
    private val clientId: String? = null

    @Value("\${google.client.client-secret}")
    private val clientSecret: String? = null

    @Value("\${google.client.redirectUri}")
    private val redirectURI: String? = null


    @get:Throws(IOException::class)
    var events: Set<Event> = HashSet()
    val date1 = DateTime("2017-05-05T16:30:00.000+05:30")
    val date2 = DateTime(Date())

    @GetMapping("/login/google")
    @Throws(Exception::class)
    fun googleConnectionStatus(request: HttpServletRequest?): RedirectView {
        return RedirectView(authorize())
    }

    @GetMapping("/calendar")
    fun oauth2Callback(@RequestParam(value = "code") @Param("code") code: String?): ResponseEntity<String> {
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
                val events: List<Event> = eventList.items
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







    @Throws(Exception::class)
    private fun authorize(): String {
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
            GoogleCalendarController::class.java
        )
        private val APPLICATION_NAME = ""
        private var httpTransport: HttpTransport? = null
        private val JSON_FACTORY: JsonFactory = JacksonFactory.getDefaultInstance()
        private var client: Calendar? = null
    }
}
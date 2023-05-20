package com.teamcaffeine.koja.controller

import com.google.api.client.auth.oauth2.Credential
import com.google.api.client.extensions.java6.auth.oauth2.AuthorizationCodeInstalledApp
import com.google.api.client.extensions.jetty.auth.oauth2.LocalServerReceiver
import com.google.api.client.googleapis.auth.oauth2.GoogleAuthorizationCodeFlow
import com.google.api.client.googleapis.auth.oauth2.GoogleClientSecrets
import com.google.api.client.googleapis.javanet.GoogleNetHttpTransport
import com.google.api.client.googleapis.util.Utils
import com.google.api.services.calendar.Calendar
import com.google.api.services.calendar.CalendarScopes
import com.google.api.services.calendar.model.CalendarList
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController
import java.io.File
import java.io.InputStreamReader


@RestController
@RequestMapping("/api")
class CalendarController {

    private val JSON_FACTORY = Utils.getDefaultJsonFactory()
    private val HTTP_TRANSPORT = GoogleNetHttpTransport.newTrustedTransport()
    private val SCOPES = CalendarScopes.CALENDAR_READONLY
    private val CREDENTIALS_FILE_PATH = "/path/to/your/credentials.json"

    @GetMapping("/calendars")
    fun getCalendars(userID : String): List<String> {
        val clientSecrets: GoogleClientSecrets = GoogleClientSecrets.load(
            JSON_FACTORY, InputStreamReader(File(CREDENTIALS_FILE_PATH).inputStream())
        )
        val flow: GoogleAuthorizationCodeFlow = GoogleAuthorizationCodeFlow.Builder(
            HTTP_TRANSPORT, JSON_FACTORY, clientSecrets, SCOPES.
        ).build()
        val receiver: LocalServerReceiver = LocalServerReceiver.Builder().setPort(8888).build()
        val credential: Credential = AuthorizationCodeInstalledApp(flow, receiver).authorize(userID)
        val service: Calendar = Calendar.Builder(HTTP_TRANSPORT, JSON_FACTORY, credential).build()
        val calendarList: CalendarList = service.calendarList().list().execute()

        return calendarList.items.map { it.summary }
    }
}

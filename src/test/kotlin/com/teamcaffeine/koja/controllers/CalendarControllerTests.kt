package com.teamcaffeine.koja.controllers

import com.google.api.client.googleapis.auth.oauth2.GoogleAuthorizationCodeFlow
import com.google.api.client.util.DateTime
import com.google.auth.oauth2.GoogleCredentials
import com.teamcaffeine.koja.controller.GoogleCalendarController
import com.teamcaffeine.koja.entity.Event
import com.teamcaffeine.koja.service.GoogleCalendarService
import org.junit.jupiter.api.Test
import org.springframework.boot.test.context.SpringBootTest
import org.junit.jupiter.api.Assertions.*
import org.mockito.Mockito.*
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import java.util.*


@SpringBootTest
class CalendarControllerTests {

    @Test
    fun contextLoads() {
    }



    @Test
    fun `oauth2Callback should return ResponseEntity with message and HttpStatus OK`() {
        // Mock the necessary dependencies
        val flowMock = mock(GoogleAuthorizationCodeFlow::class.java)
        val credentialMock = mock(GoogleCredentials::class.java)
        val clientMock = mock(GoogleCalendarController::class.java)
        val eventsListMock = mock(Event::class.java)

        // Create an instance of the class under test

        // Set up the necessary data and inputs
        val code = "testCode"
        val redirectURI = "testRedirectURI"

        val date1 = DateTime("2023-05-01T16:30:00.000+05:30")
        val date2 = DateTime(Date())
        val expectedMessage = "Test Message"

        val result = clientMock.oauth2Callback(code)

        // Assert the result
        assertEquals(expectedMessage, result.body)
        assertEquals(HttpStatus.OK, result.statusCode)
    }
}


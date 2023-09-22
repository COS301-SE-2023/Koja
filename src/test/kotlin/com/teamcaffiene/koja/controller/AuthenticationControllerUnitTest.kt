package com.teamcaffiene.koja.controller

import com.teamcaffeine.koja.controller.AuthenticationController
import com.teamcaffeine.koja.enums.CallbackConfigEnum
import com.teamcaffeine.koja.service.GoogleCalendarAdapterService
import jakarta.servlet.http.HttpServletRequest
import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.Test
import org.mockito.InjectMocks
import org.mockito.Mock
import org.mockito.Mockito.`when`
import org.mockito.MockitoAnnotations
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.web.servlet.view.RedirectView

class AuthenticationControllerUnitTest {
    @Mock
    private lateinit var googleCalendarAdapterService: GoogleCalendarAdapterService

    @Mock
    private lateinit var request: HttpServletRequest

    @InjectMocks
    private lateinit var authenticationController: AuthenticationController

    @BeforeEach
    fun setup() {
        MockitoAnnotations.openMocks(this)
    }

    @Test
    fun testAuthenticateWithGoogle() {
        // Mock the behavior of the googleCalendarAdapterService
        val redirectView = RedirectView("https://example.com")
        `when`(googleCalendarAdapterService.setupConnection(request, CallbackConfigEnum.WEB)).thenReturn(redirectView)

        // Invoke the authenticateWithGoogle method in the authenticationController
        val result: RedirectView = authenticationController.authenticateWithGoogle(request)

        // Verify the result
        assertEquals(redirectView.url, result.url)
    }

    @Test
    fun testHandleGoogleOAuth2Callback() {
        // Mock the behavior of the googleCalendarAdapterService
        val authCode = "testAuthCode"
        val responseEntity = ResponseEntity.status(HttpStatus.OK).body("Authentication successful")
        `when`(googleCalendarAdapterService.oauth2Callback(authCode, CallbackConfigEnum.WEB)).thenReturn(responseEntity.toString())

        // Invoke the handleGoogleOAuth2Callback method in the authenticationController
        val result: ResponseEntity<String> = authenticationController.handleGoogleOAuth2Callback(authCode)

        // Verify the result
        assertEquals(HttpStatus.OK, result.statusCode)
        assertEquals("Authentication successful", result.body)
    }
}

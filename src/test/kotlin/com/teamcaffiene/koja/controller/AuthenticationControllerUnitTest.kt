package com.teamcaffiene.koja.controller

import com.teamcaffeine.koja.controller.AuthenticationController
import com.teamcaffeine.koja.service.GoogleCalendarAdapterService
import jakarta.servlet.http.HttpServletRequest
import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.Test
import org.mockito.InjectMocks
import org.mockito.Mock
import org.mockito.Mockito.`when`
import org.mockito.MockitoAnnotations
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
        `when`(googleCalendarAdapterService.setupConnection(request, false)).thenReturn(redirectView)

        // Invoke the authenticateWithGoogle method in the authenticationController
        val result: RedirectView = authenticationController.authenticateWithGoogle(request)

        // Verify the result
        assertEquals(redirectView.url, result.url)
    }

//    @Test
//    fun testHandleGoogleOAuth2Callback() {
//        // Mock the behavior of the googleCalendarAdapterService
//        val authCode = "testAuthCode"
//        val responseEntity = ResponseEntity.status(HttpStatus.OK).body("Success")
//        `when`(googleCalendarAdapterService.oauth2Callback(authCode, false)).thenReturn(responseEntity.toString())
//
//        // Invoke the handleGoogleOAuth2Callback method in the authenticationController
//        val result: ResponseEntity<String> = authenticationController.handleGoogleOAuth2Callback(authCode)
//
//        // Verify the result
//        assertEquals(HttpStatus.OK, result.statusCode)
//        assertEquals("Success", result.body)
//    }
}

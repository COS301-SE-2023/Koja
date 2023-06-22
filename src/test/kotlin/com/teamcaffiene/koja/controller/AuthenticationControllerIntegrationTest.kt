package com.teamcaffiene.koja.controller

import com.teamcaffeine.koja.KojaApplication
import com.teamcaffeine.koja.service.GoogleCalendarAdapterService
import org.junit.jupiter.api.Test
import org.mockito.Mockito.`when`
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc
import org.springframework.boot.test.context.SpringBootTest
import org.springframework.boot.test.mock.mockito.MockBean
import org.springframework.http.MediaType
import org.springframework.http.ResponseEntity
import org.springframework.test.context.junit.jupiter.SpringJUnitConfig
import org.springframework.test.web.servlet.MockMvc
import org.springframework.test.web.servlet.get

@SpringJUnitConfig
@SpringBootTest(classes = [KojaApplication::class])
@AutoConfigureMockMvc
class AuthenticationControllerIntegrationTest {

    @Autowired
    private lateinit var mockMvc: MockMvc

    @MockBean
    private lateinit var googleCalendarAdapter: GoogleCalendarAdapterService

    @Test
    fun testHandleGoogleOAuth2Callback() {
        // Prepare test data
        val authCode = "test_auth_code"
        val responseContent = "OAuth2 callback successful"

        // Mock the service method
        `when`(googleCalendarAdapter.oauth2Callback(authCode)).thenReturn(ResponseEntity.ok(responseContent))

        // Perform the GET request
        mockMvc.get("/api/v1/auth/google/callback") {
            param("code", authCode)
            accept(MediaType.APPLICATION_JSON)
        }.andExpect {
            status { isOk() }
            content {
                contentType(MediaType.APPLICATION_JSON)
                json(responseContent)
            }
        }
    }
}
package com.teamcaffiene.koja.controller

import com.teamcaffeine.koja.KojaApplication
import com.teamcaffeine.koja.service.GoogleCalendarAdapterService
import org.junit.jupiter.api.Test
import org.mockito.Mockito.`when`
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.beans.factory.annotation.Qualifier
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc
import org.springframework.boot.test.context.SpringBootTest
import org.springframework.boot.test.mock.mockito.MockBean
import org.springframework.http.MediaType
import org.springframework.http.ResponseEntity
import org.springframework.test.context.ActiveProfiles
import org.springframework.test.web.servlet.MockMvc
import org.springframework.test.web.servlet.get

@SpringBootTest(classes = [KojaApplication::class])
@AutoConfigureMockMvc
@ActiveProfiles("test")
class AuthenticationControllerIntegrationTest {

    @Autowired
    private lateinit var mockMvc: MockMvc

    @MockBean
    @Qualifier("googleCalendarAdapterService")
    private lateinit var googleCalendarAdapter: GoogleCalendarAdapterService

    @Test
    fun testHandleGoogleOAuth2Callback() {
        val authCode = "test_auth_code"
        val responseContent = "test_token"

        `when`(googleCalendarAdapter.oauth2Callback(authCode, false)).thenReturn(ResponseEntity.ok(responseContent).toString())

        mockMvc.get("/api/v1/auth/google/callback") {
            param("code", authCode)
            accept(MediaType.APPLICATION_JSON)
        }.andExpect {
            status { isOk() }
            content {
                string(responseContent)
            }
        }
    }
}

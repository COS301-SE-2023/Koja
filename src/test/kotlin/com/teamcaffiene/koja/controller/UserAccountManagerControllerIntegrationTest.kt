package com.teamcaffiene.koja.controller

import com.teamcaffeine.koja.controller.TokenManagerController
import com.teamcaffeine.koja.controller.TokenRequest
import com.teamcaffeine.koja.controller.UserAccountManagerController
import com.teamcaffeine.koja.dto.JWTGoogleDTO
import com.teamcaffeine.koja.enums.AuthProviderEnum
import com.teamcaffeine.koja.repository.UserAccountRepository
import com.teamcaffeine.koja.repository.UserRepository
import com.teamcaffeine.koja.service.GoogleCalendarAdapterService
import com.teamcaffeine.koja.service.UserAccountManagerService
import io.github.cdimascio.dotenv.Dotenv
import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.extension.ExtendWith
import org.mockito.InjectMocks
import org.mockito.Mock
import org.mockito.junit.jupiter.MockitoExtension
import org.springframework.http.MediaType
import org.springframework.test.web.servlet.MockMvc
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders
import org.springframework.test.web.servlet.result.MockMvcResultMatchers
import org.springframework.test.web.servlet.setup.MockMvcBuilders

@ExtendWith(MockitoExtension::class)
class UserAccountManagerControllerIntegrationTest {
    private lateinit var dotenv: Dotenv
    private lateinit var mockMvc: MockMvc

    @Mock
    private lateinit var googleCalendarAdapterService: GoogleCalendarAdapterService

    @Mock
    private lateinit var userAccountManagerService: UserAccountManagerService

    @Mock
    private lateinit var userRepository: UserRepository

    @Mock
    private lateinit var userAccountRepository: UserAccountRepository

    @InjectMocks
    private lateinit var userAccountManagerController: UserAccountManagerController

    @BeforeEach
    fun setup() {
        importEnvironmentVariables()
        mockMvc = MockMvcBuilders.standaloneSetup(userAccountManagerController).build()
    }

    private fun importEnvironmentVariables() {
        dotenv = Dotenv.load()

        dotenv["KOJA_AWS_RDS_DATABASE_URL"]?.let { System.setProperty("KOJA_AWS_RDS_DATABASE_URL", it) }
        dotenv["KOJA_AWS_RDS_DATABASE_ADMIN_USERNAME"]?.let {
            System.setProperty(
                "KOJA_AWS_RDS_DATABASE_ADMIN_USERNAME",
                it,
            )
        }
        dotenv["KOJA_AWS_RDS_DATABASE_ADMIN_PASSWORD"]?.let {
            System.setProperty(
                "KOJA_AWS_RDS_DATABASE_ADMIN_PASSWORD",
                it,
            )
        }

        dotenv["GOOGLE_CLIENT_ID"]?.let { System.setProperty("GOOGLE_CLIENT_ID", it) }
        dotenv["GOOGLE_CLIENT_SECRET"]?.let { System.setProperty("GOOGLE_CLIENT_SECRET", it) }
        dotenv["API_KEY"]?.let { System.setProperty("API_KEY", it) }

        dotenv["KOJA_JWT_SECRET"]?.let { System.setProperty("KOJA_JWT_SECRET", it) }
    }

    @Test
    fun `Test adding another Google email without token should return bad request`() {
        mockMvc.perform(
            MockMvcRequestBuilders.get("/api/v1/user/auth/add-email/google")
                .accept(MediaType.APPLICATION_JSON)
        )
            .andExpect(MockMvcResultMatchers.status().isBadRequest)
    }

    @Test
    fun `Test adding another Google email with token should return success`() {
        val mockUserID = Int.MAX_VALUE
        val authDetails = JWTGoogleDTO("access", "refresh", 60 * 60)
        val mockToken = TokenManagerController.createToken(
            TokenRequest(
                arrayListOf(authDetails),
                AuthProviderEnum.GOOGLE,
                mockUserID
            )
        )

        mockMvc.perform(
            MockMvcRequestBuilders.get("/api/v1/user/auth/add-email/google")
                .param("token", mockToken)
                .accept(MediaType.APPLICATION_JSON)
        )
            .andExpect(MockMvcResultMatchers.status().isOk)
    }
}

package com.teamcaffiene.koja.service

import com.teamcaffeine.koja.constants.HeaderConstant
import com.teamcaffeine.koja.controller.UserController
import com.teamcaffeine.koja.dto.JWTFunctionality
import com.teamcaffeine.koja.repository.UserAccountRepository
import com.teamcaffeine.koja.repository.UserRepository
import com.teamcaffeine.koja.service.UserCalendarService
import io.github.cdimascio.dotenv.Dotenv
import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.Test
import org.mockito.Mock
import org.mockito.MockitoAnnotations
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.mock.mockito.MockBean
import org.springframework.http.MediaType
import org.springframework.test.web.servlet.MockMvc
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders
import org.springframework.test.web.servlet.result.MockMvcResultMatchers
import org.springframework.test.web.servlet.setup.MockMvcBuilders.standaloneSetup

class UserControllerIntergrationTest {

    private lateinit var userController: UserController
    private lateinit var dotenv: Dotenv

    @Mock
    private lateinit var userAccountRepository: UserAccountRepository

    @Mock
    private lateinit var jwtFunctionality: JWTFunctionality

    @Mock
    private lateinit var userRepository: UserRepository

    @MockBean
    private lateinit var userCalendarService: UserCalendarService

    @Autowired
    private lateinit var mockMvc: MockMvc

    @BeforeEach
    fun setup() {
        MockitoAnnotations.openMocks(this)
        importEnvironmentVariables()
        userCalendarService = UserCalendarService(userRepository, jwtFunctionality)
        mockMvc = standaloneSetup(userCalendarService).build()
        userController = UserController(userAccountRepository, userCalendarService)
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
    fun `test removeTimeBoundary with valid parameters`() {
        // Mock request parameters
        val token = "your_token_here"
        val name = "Boundary1"

        // Mock the userCalendarService.removeTimeBoundary method
        // whenever(userCalendarService.removeTimeBoundary(token, name)).thenReturn(true)

        // Perform the HTTP POST request
        mockMvc.perform(
            MockMvcRequestBuilders.post("/api/v1/user/removeTimeBoundary")
                .header(HeaderConstant.AUTHORISATION, token)
                .param("name", name)
                .contentType(MediaType.APPLICATION_JSON),
        )
            // Validate the response
            .andExpect(MockMvcResultMatchers.status().isOk)
            .andExpect(MockMvcResultMatchers.content().string("Time boundary successfully removed"))
    }

    @Test
    fun `test removeTimeBoundary with missing token`() {
        // Mock request parameters with a missing token
        val name = "Boundary1"

        // Perform the HTTP POST request
        mockMvc.perform(
            MockMvcRequestBuilders.post("/api/v1/user/removeTimeBoundary")
                .param("name", name)
                .contentType(MediaType.APPLICATION_JSON),
        )
            // Validate the response
            .andExpect(MockMvcResultMatchers.status().isNotFound)
    }

    @Test
    fun `test removeTimeBoundary with invalid name`() {
        // Mock request parameters
        val token = "your_token_here"
        val name = null

        // Mock the userCalendarService.removeTimeBoundary method to return false for invalid name
        // whenever(userCalendarService.removeTimeBoundary(token, name)).thenReturn(false)

        // Perform the HTTP POST request
        mockMvc.perform(
            MockMvcRequestBuilders.post("/api/v1/user/removeTimeBoundary")
                .header(HeaderConstant.AUTHORISATION, token)
                .param("name", name)
                .contentType(MediaType.APPLICATION_JSON),
        )
            // Validate the response
            .andExpect(MockMvcResultMatchers.status().isBadRequest)
        // .andExpect(MockMvcResultMatchers.content().string("Something went wrong"))
    }
}

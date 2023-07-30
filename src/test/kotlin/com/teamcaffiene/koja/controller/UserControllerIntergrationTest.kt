package com.teamcaffiene.koja.service

import com.teamcaffeine.koja.controller.UserController
import com.teamcaffeine.koja.repository.UserAccountRepository
import com.teamcaffeine.koja.service.UserCalendarService
import io.github.cdimascio.dotenv.Dotenv
import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.Test
import org.mockito.Mock
import org.mockito.MockitoAnnotations
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.http.MediaType
import org.springframework.test.web.servlet.MockMvc
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post
import org.springframework.test.web.servlet.result.MockMvcResultMatchers.content
import org.springframework.test.web.servlet.result.MockMvcResultMatchers.status
import org.springframework.test.web.servlet.setup.MockMvcBuilders
import org.springframework.test.web.servlet.setup.MockMvcBuilders.standaloneSetup
import org.springframework.web.context.WebApplicationContext

class UserControllerIntergrationTest {

    private lateinit var userController: UserController
    private lateinit var dotenv: Dotenv

    @Mock
    private lateinit var userAccountRepository: UserAccountRepository

    @Autowired
    private lateinit var userCalendarService: UserCalendarService

    @Autowired
    private lateinit var mockMvc: MockMvc

    @Autowired
    private lateinit var webApplicationContext: WebApplicationContext

    @BeforeEach
    fun setup() {
        MockitoAnnotations.openMocks(this)
        importEnvironmentVariables()
        mockMvc = standaloneSetup(userCalendarService).build()
        mockMvc = MockMvcBuilders.webAppContextSetup(webApplicationContext).build()
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
    fun `test removeTimeBoundary with valid token and name`() {
        // Mock request parameters
        val token = "your_token_here"
        val name = "Boundary1"

        // Perform the POST request to the endpoint
        mockMvc.perform(
            post("/removeTimeBoundary")
                .header("Authorization", token)
                .param("name", name)
                .contentType(MediaType.APPLICATION_JSON),
        )
            .andExpect(status().isOk)
            .andExpect(content().string("Time boundary successfully removed"))
    }

    @Test
    fun `test removeTimeBoundary with missing token`() {
        // Mock request parameters with a missing token
        val name = "Boundary1"

        // Perform the POST request to the endpoint
        mockMvc.perform(
            post("/removeTimeBoundary")
                .param("name", name)
                .contentType(MediaType.APPLICATION_JSON),
        )
            .andExpect(status().isBadRequest)
            .andExpect(content().string("Required parameters not set"))
    }

    @Test
    fun `test removeTimeBoundary with invalid name`() {
        // Mock request parameters
        val token = "your_token_here"
        val name = "Invalid_Boundary"

        // Perform the POST request to the endpoint
        mockMvc.perform(
            post("/removeTimeBoundary")
                .header("Authorization", token)
                .param("name", name)
                .contentType(MediaType.APPLICATION_JSON),
        )
            .andExpect(status().isBadRequest)
            .andExpect(content().string("Something went wrong"))
    }
}

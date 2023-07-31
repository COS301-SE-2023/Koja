package com.teamcaffiene.koja.service

import com.teamcaffeine.koja.constants.HeaderConstant
import com.teamcaffeine.koja.controller.TokenManagerController
import com.teamcaffeine.koja.controller.TokenRequest
import com.teamcaffeine.koja.controller.UserController
import com.teamcaffeine.koja.dto.JWTAuthDetailsDTO
import com.teamcaffeine.koja.dto.JWTFunctionality
import com.teamcaffeine.koja.dto.JWTGoogleDTO
import com.teamcaffeine.koja.dto.UserJWTTokenDataDTO
import com.teamcaffeine.koja.enums.AuthProviderEnum
import com.teamcaffeine.koja.repository.UserRepository
import com.teamcaffeine.koja.service.UserCalendarService
import io.github.cdimascio.dotenv.Dotenv
import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.Test
import org.mockito.Mock
import org.mockito.MockitoAnnotations
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest
import org.springframework.boot.test.mock.mockito.MockBean
import org.springframework.http.MediaType
import org.springframework.test.context.ContextConfiguration
import org.springframework.test.web.servlet.MockMvc
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders
import org.springframework.test.web.servlet.result.MockMvcResultMatchers

@WebMvcTest(UserController::class)
@ContextConfiguration(classes = [UserCalendarService::class])
class UserControllerIntergrationTest {
    private lateinit var dotenv: Dotenv

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

    fun `test removeTimeBoundary with valid parameters`() {
        // Mock request parameters
        val mockUserID = Int.MAX_VALUE
        val userAccounts = mutableListOf<JWTAuthDetailsDTO>()
        val mockUserJWTData = UserJWTTokenDataDTO(userAccounts, mockUserID)
        val authDetails = JWTGoogleDTO("access", "refresh", 60 * 60)
        val token = TokenManagerController.createToken(
            TokenRequest(
                arrayListOf(authDetails),
                AuthProviderEnum.GOOGLE,
                mockUserID,
            ),
        )
        val name = "boundary1"
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
    fun `test removeTimeBoundary with invalid token`() {
        // Mock request parameters with a missing token
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
            .andExpect(MockMvcResultMatchers.status().isForbidden)
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
            .andExpect(MockMvcResultMatchers.status().isForbidden)
    }

    @Test
    fun `test removeTimeBoundary with valid token and non-existent user`() {
        // Mock request parameters
        val mockUserID = Int.MAX_VALUE
        val userAccounts = mutableListOf<JWTAuthDetailsDTO>()
        val mockUserJWTData = UserJWTTokenDataDTO(userAccounts, mockUserID)
        val authDetails = JWTGoogleDTO("access", "refresh", 60 * 60)
        val token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJlbmNyeXB0ZWQiOiIrT09EZXlqWk1CWjV6b3I1OFRBdVZIT2x3akJvbHY1MGFkTjQ5ajdFMWMweW9TWW9zOTNHMUVWT0ord3Z2dGFLa3pON1UvWDREMjNhY0J0VkxGbG5hM3BiVVVjTjBzVlhrb0F4Ym9VMS9zWDlaMS8rTk1wZVVsUThlNTVSUUNYNnY0WUw0SnR5azFCQUxMS2E3TnAxbDUxTEc0cnZoM0NWdmM4ZGdncXRqcTltRW5LTW1ReGRkNUlwTjN6V1V1aE1XVHF6Y0h1ZkVUUVRCQXJrS0hEZzdLdUg2STRkck51b0U3NDJxSTBtQXRhL3NpZ1IzSXFuRmlJWHpvUFBKejNqc0E2aFBSc1V6WE95YXhSZXIyMDBIT2VDRjJYc1VMUjVCMjJmakpBR21QK282Zkt4NXJuZElRcWx1RWdqTXlhM3VZcHpmUWduMHg2NzhNd0JUZTF5UHl2OE14S05OKzJvaWJqWXFBckxOcDRvTitDK3JJMEhHYWVnQ241SmRlRlh5Yng3S0lGYzR0V0ZyOWx1bEJtWjhocjBFbVV4cXVmSHpFL0pFa2ZzV0ZNUVhDYlFnNHdWQVdPT0FSWWVjeW96NE10TGNtbXFSWUJ3cm9yTkhHTCsrcUx5WUExeUZxNjI4TFNiMHdibVpEc1pXRVNMQys0dDhzWGtPZTdpeXJyV2J0K2IyVWxMM2w1YnRKcGN4bHgwUXVtQXdnSmNYd0RwZ3k3RUd3aDhHQ1hMVjRuZXljMGxBVThjR3VNNU5FdlE0SEs3N3hmSFh6ZnpiYzFsamZjd3VBPT0iLCJleHAiOjE2OTA4MDIyMDZ9.BsvLvXuHfO_em3HDDJau7Fre8Hef-RxFYXoqcMblmNXdfHMsM_KN6X5FcqES0Dkd43skK4nTdHPP8SYpkrKnPw"
        val name = "boundary1"
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

    @Test
    fun `test removeTimeBoundary with invalid name`() {
        // Mock request parameters
        val mockUserID = Int.MAX_VALUE
        val userAccounts = mutableListOf<JWTAuthDetailsDTO>()
        val mockUserJWTData = UserJWTTokenDataDTO(userAccounts, mockUserID)
        val authDetails = JWTGoogleDTO("access", "refresh", 60 * 60)
        val token = TokenManagerController.createToken(
            TokenRequest(
                arrayListOf(authDetails),
                AuthProviderEnum.GOOGLE,
                mockUserID,
            ),
        )
        val name = "boundary1"
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

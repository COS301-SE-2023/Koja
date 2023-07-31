package com.teamcaffiene.koja.service

import com.teamcaffeine.koja.constants.HeaderConstant
import com.teamcaffeine.koja.controller.UserController
import com.teamcaffeine.koja.dto.JWTFunctionality
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

/*
    @Test
    fun `test removeTimeBoundary with valid parameters`() {
        // Mock request parameters
        val token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJlbmNyeXB0ZWQiOiIrT09EZXlqWk1CWjV6b3I1OFRBdVZIT2x3akJvbHY1MGFkTjQ5ajdFMWMweW9TWW9zOTNHMUVWT0ord3Z2dGFLRU1Gb1RBTE53ZkJqcktkV3lueWhKWjZqdFI3aUZSZUd0bzN0Y1M5QVh6MkxCUnFpd0Jib084Q3QybWRXdlExdlVHbHVHS3NXd2dObU1qN2x1SUN3ODBkWmtkaDdtWUVPNFQxWmlpUFAzM0E4QzZVN3N2OGlzdEc2TG8vb0VWald2VzIyUTJHWWU4QnBJOENUUFBRTTZQKzZyc3FjOENQUWZWU1dLMGlTZnVvZUNXbE4yNTArUDRCV1REVlZNK09UNDBiVzdha1dKOXV5dU9iczRJelI4T0E4bHA5aGpaMmkwdDJSUjR6SEwyOFFmOTY1dDJvNTFUSjJqV1RwYVVnSHZsdlEyM0xnb3lCWjhpRHZrMlZ5NkhWelRFL1VORW8zeUZYell5bFVEOEhnZW5raUV6cG4xaWxobkpWeEhFYTBPQkJBbmF2ODZUR1hIMWI1YlhCRmF3Qmx5N2ZGM2w0QUZ2LzRhOUxURUlLVVc0eTVPRThTOWFnTEtESGl5WnF2K2hTVGZtbjNCQzRTWk1DUm4wR0pkQ1N2Zzl6VGt2TmlDS1pDMmRkRDRRbi9kSklYZkNiMWY2azlRa09VS2RpNGw1VktvdWJMVnBwQkhYdDM4a2VDcEpSVmpiWGZDYzQ0aFovMDNLR1NFalNMaXJMMGVqdVhQcEwyRDQ3WnZMWDJ1VFE1My9UVjd6YS9XQkZsbjd2eklnPT0iLCJleHAiOjE2OTA4MTkwMzd9.fXJpHPSFWEecqCT40Ds2LaoEygJ_BjUg5qZl_Q_NUq6NB4GmqSbYpNyXRJi3YhbhPfdcokSUPNI5fyeuzW1CiQ"
        val name = "play"
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
*/
    @Test
    fun `test removeTimeBoundary with invalid token`() {
        // Mock request parameters with a missing token
        val token = "your_token_here"
        val name = "Boundary1"
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
/*
    @Test
    fun `test removeTimeBoundary with valid token and non-existent user`() {
        // Mock request parameters
        val token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJlbmNyeXB0ZWQiOiIrT09EZXlqWk1CWjV6b3I1OFRBdVZIT2x3akJvbHY1MGFkTjQ5ajdFMWMweW9TWW9zOTNHMUVWT0ord3Z2dGFLRU1Gb1RBTE53ZkJqcktkV3lueWhKWjZqdFI3aUZSZUd0bzN0Y1M5QVh6MkxCUnFpd0Jib084Q3QybWRXdlExdlVHbHVHS3NXd2dObU1qN2x1SUN3ODBkWmtkaDdtWUVPNFQxWmlpUFAzM0E4QzZVN3N2OGlzdEc2TG8vb0VWald2VzIyUTJHWWU4QnBJOENUUFBRTTZQKzZyc3FjOENQUWZWU1dLMGlTZnVvZUNXbE4yNTArUDRCV1REVlZNK09UNDBiVzdha1dKOXV5dU9iczRJelI4T0E4bHA5aGpaMmkwdDJSUjR6SEwyOFFmOTY1dDJvNTFUSjJqV1RwYVVnSHZsdlEyM0xnb3lCWjhpRHZrMlZ5NkhWelRFL1VORW8zeUZYell5bFVEOEhnZW5raUV6cG4xaWxobkpWeEhFYTBPQkJBbmF2ODZUR1hIMWI1YlhCRmF3Qmx5N2ZGM2w0QUZ2LzRhOUxURUlLVVc0eTVPRThTOWFnTEtESGl5WnF2K2hTVGZtbjNCQzRTWk1DUm4wR0pkQ1N2Zzl6VGt2TmlDS1pDMmRkRDRRbi9kSklYZkNiMWY2azlRa09VS2RpNGw1VktvdWJMVnBwQkhYdDM4a2VDcEpSVmpiWGZDYzQ0aFovMDNLR1NFalNMaXJMMGVqdVhQcEwyRDQ3WnZMWDJ1VFE1My9UVjd6YS9XQkZsbjd2eklnPT0iLCJleHAiOjE2OTA4MTkwMzd9.fXJpHPSFWEecqCT40Ds2LaoEygJ_BjUg5qZl_Q_NUq6NB4GmqSbYpNyXRJi3YhbhPfdcokSUPNI5fyeuzW1CiQ"
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
    }*/
}

package com.teamcaffiene.koja.controller

import com.google.gson.Gson
import com.google.gson.GsonBuilder
import com.teamcaffeine.koja.constants.EnvironmentVariableConstant
import com.teamcaffeine.koja.constants.ResponseConstant
import com.teamcaffeine.koja.controller.TokenManagerController
import com.teamcaffeine.koja.controller.TokenManagerController.Companion.createToken
import com.teamcaffeine.koja.controller.TokenRequest
import com.teamcaffeine.koja.controller.UserController
import com.teamcaffeine.koja.dto.JWTGoogleDTO
import com.teamcaffeine.koja.entity.TimeBoundary
import com.teamcaffeine.koja.entity.UserAccount
import com.teamcaffeine.koja.enums.AuthProviderEnum
import com.teamcaffeine.koja.repository.TimeBoundaryRepository
import com.teamcaffeine.koja.repository.UserAccountRepository
import com.teamcaffeine.koja.repository.UserRepository
import com.teamcaffeine.koja.service.UserCalendarService
import io.github.cdimascio.dotenv.Dotenv
import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.Test
import org.mockito.Mock
import org.mockito.Mockito
import org.mockito.MockitoAnnotations
import org.mockito.kotlin.eq
import org.mockito.kotlin.verify
import org.mockito.kotlin.whenever
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity

class UserControllerUnitTest {
    private lateinit var userController: UserController
    private lateinit var dotenv: Dotenv

    @Mock
    private lateinit var userAccountRepository: UserAccountRepository

    @Mock
    private lateinit var userCalendarService: UserCalendarService

    @Mock
    private lateinit var userRepository: UserRepository

    @Mock
    private lateinit var timeBoundaryRepository: TimeBoundaryRepository

    @BeforeEach
    fun setup() {
        MockitoAnnotations.openMocks(this)
        importEnvironmentVariables()
        userController = UserController(userAccountRepository, userRepository, userCalendarService, timeBoundaryRepository)
    }

    private fun importEnvironmentVariables() {
        dotenv = Dotenv.load()

        dotenv[EnvironmentVariableConstant.KOJA_AWS_RDS_DATABASE_URL]?.let {
            System.setProperty(EnvironmentVariableConstant.KOJA_AWS_RDS_DATABASE_URL, it)
        }
        dotenv[EnvironmentVariableConstant.KOJA_AWS_RDS_DATABASE_ADMIN_USERNAME]?.let {
            System.setProperty(EnvironmentVariableConstant.KOJA_AWS_RDS_DATABASE_ADMIN_USERNAME, it)
        }
        dotenv[EnvironmentVariableConstant.KOJA_AWS_RDS_DATABASE_ADMIN_PASSWORD]?.let {
            System.setProperty(EnvironmentVariableConstant.KOJA_AWS_RDS_DATABASE_ADMIN_PASSWORD, it)
        }
        dotenv[EnvironmentVariableConstant.GOOGLE_CLIENT_ID]?.let {
            System.setProperty(EnvironmentVariableConstant.GOOGLE_CLIENT_ID, it)
        }
        dotenv[EnvironmentVariableConstant.GOOGLE_CLIENT_SECRET]?.let {
            System.setProperty(EnvironmentVariableConstant.GOOGLE_CLIENT_SECRET, it)
        }
        dotenv[EnvironmentVariableConstant.GOOGLE_MAPS_API_KEY]?.let {
            System.setProperty(EnvironmentVariableConstant.GOOGLE_MAPS_API_KEY, it)
        }
        dotenv[EnvironmentVariableConstant.KOJA_JWT_SECRET]?.let {
            System.setProperty(EnvironmentVariableConstant.KOJA_JWT_SECRET, it)
        }
    }

    /**
     * Get User Email Scenario1: User has one linked email
     */
    @Test
    fun testGetUserEmailsScenario1() {
        val mockUserID = Int.MAX_VALUE
        val authDetails = JWTGoogleDTO("access", "refresh", 60 * 60)
        val mockToken = createToken(TokenRequest(arrayListOf(authDetails), AuthProviderEnum.GOOGLE, mockUserID))

        val userAccount = UserAccount(id = 1, email = "test@test.com", refreshToken = "refresh", authProvider = AuthProviderEnum.GOOGLE, userID = mockUserID)
        val userAccounts = listOf(userAccount)

        whenever(userAccountRepository.findByUserID(eq(mockUserID))).thenReturn(userAccounts)

        val result = userController.getUserEmails(mockToken)

        assertEquals(result, ResponseEntity.ok(userAccounts.map { it.email }))
    }

    /**
     * Get User Email Scenario2: User has more than one linked email
     */
    @Test
    fun testGetUserEmailsScenario2() {
        val mockUserID = Int.MAX_VALUE
        val authDetails = JWTGoogleDTO("access", "refresh", 60 * 60)
        val mockToken = createToken(TokenRequest(arrayListOf(authDetails), AuthProviderEnum.GOOGLE, mockUserID))

        val userAccount1 = UserAccount(id = 1, email = "test@test.com", refreshToken = "refresh", authProvider = AuthProviderEnum.GOOGLE, userID = mockUserID)
        val userAccount2 = UserAccount(id = 1, email = "test@test.com", refreshToken = "refresh", authProvider = AuthProviderEnum.GOOGLE, userID = mockUserID)
        val userAccount3 = UserAccount(id = 1, email = "test@test.com", refreshToken = "refresh", authProvider = AuthProviderEnum.GOOGLE, userID = mockUserID)
        val userAccount4 = UserAccount(id = 1, email = "test@test.com", refreshToken = "refresh", authProvider = AuthProviderEnum.GOOGLE, userID = mockUserID)
        val userAccounts = listOf(userAccount1, userAccount2, userAccount3, userAccount4)

        whenever(userAccountRepository.findByUserID(eq(mockUserID))).thenReturn(userAccounts)

        val result = userController.getUserEmails(mockToken)

        assertEquals(result, ResponseEntity.ok(userAccounts.map { it.email }))
    }

    /**
     * Get User Email Scenario3: Request made without token
     */
    @Test
    fun testGetUserEmailsScenario3() {
        val result = userController.getUserEmails(null)

        assertEquals(result, ResponseEntity.badRequest().body(listOf(ResponseConstant.REQUIRED_PARAMETERS_NOT_SET)))
    }

    /**
     * Delete User Account Scenario1: Request made to delete user account
     */
    @Test
    fun testDeleteUserAccountScenario1() {
        val mockUserID = Int.MAX_VALUE
        val authDetails = JWTGoogleDTO("access", "refresh", 60 * 60)
        val mockToken = createToken(TokenRequest(arrayListOf(authDetails), AuthProviderEnum.GOOGLE, mockUserID))

        val userAccount = UserAccount(id = 1, email = "test@test.com", refreshToken = "refresh", authProvider = AuthProviderEnum.GOOGLE, userID = mockUserID)
        val userAccounts = listOf(userAccount)

        whenever(userAccountRepository.findByUserID(eq(mockUserID))).thenReturn(userAccounts)

        val result = userController.deleteUserAccount(mockToken)

        assertEquals(result, ResponseEntity.ok(ResponseConstant.ACCOUNT_DELETED))
        Mockito.verify(userAccountRepository).delete(userAccount)
    }

    /**
     * Delete User Account Scenario2: Request made to delete user account without token
     */
    @Test
    fun testDeleteUserAccountScenario2() {
        val result = userController.deleteUserAccount(null)

        assertEquals(result, ResponseEntity.badRequest().body(ResponseConstant.REQUIRED_PARAMETERS_NOT_SET))
    }

    @Test
    fun `test addTimeBoundary with valid parameters`() {
        // Mock request parameters
        val mockUserID = Int.MAX_VALUE
        val authDetails = JWTGoogleDTO("access", "refresh", 60 * 60)
        val mockToken = TokenManagerController.createToken(
            TokenRequest(
                arrayListOf(authDetails),
                AuthProviderEnum.GOOGLE,
                mockUserID,
            ),
        )
        val name = "Play"
        val startTime = "2023-07-30T12:00:00Z"
        val endTime = "2023-07-30T14:00:00Z"
        val timeBoundary = TimeBoundary(name, startTime, endTime)

        // Mock the userCalendarService.addTimeBoundary method
        whenever(userCalendarService.addTimeBoundary(mockToken, timeBoundary)).thenReturn(true)

        // Call the function and capture the response
        val response = userController.addTimeBoundary(mockToken, name, startTime, endTime)
        // Check the response status and body
        assertEquals(HttpStatus.OK, response.statusCode)
        assertEquals(ResponseConstant.SUCCESSFULLY_ADDED_TIME_BOUNDARY, response.body)
    }

    @Test
    fun `test addTimeBoundary with missing token`() {
        // Mock request parameters with a missing token
        val token = "your_token_here"
        val name = "Play"
        val startTime = "2023-07-30T12:00:00Z"
        val endTime = "2023-07-30T14:00:00Z"
        val timeBoundary = TimeBoundary(name, startTime, endTime)

        // Call the function and capture the response
        val response = userController.addTimeBoundary(null, name, startTime, endTime)

        // Check the response status and body
        assertEquals(HttpStatus.BAD_REQUEST, response.statusCode)
        assertEquals(ResponseConstant.REQUIRED_PARAMETERS_NOT_SET, response.body)
    }

    @Test
    fun `test addTimeBoundary with userCalendarService returning false`() {
        // Mock request parameters
        val mockUserID = Int.MAX_VALUE
        val authDetails = JWTGoogleDTO("access", "refresh", 60 * 60)
        val mockToken = TokenManagerController.createToken(
            TokenRequest(
                arrayListOf(authDetails),
                AuthProviderEnum.GOOGLE,
                mockUserID,
            ),
        )
        val name = "Play"
        val startTime = "2023-07-30T12:00:00Z"
        val endTime = "2023-07-30T14:00:00Z"
        val timeBoundary = TimeBoundary(name, startTime, endTime)

        // Mock the userCalendarService.removeTimeBoundary method to return false
        whenever(userCalendarService.addTimeBoundary(mockToken, timeBoundary)).thenReturn(false)

        // Call the function and capture the response
        val response = userController.addTimeBoundary(mockToken, name, startTime, endTime)

        // Check the response status and body
        assertEquals(HttpStatus.BAD_REQUEST, response.statusCode)
        assertEquals(ResponseConstant.SET_TIME_BOUNDARY_FAILED_INTERNAL_ERROR, response.body)
    }

    @Test
    fun `test removeTimeBoundary with valid parameters`() {
        // Mock request parameters
        val mockUserID = Int.MAX_VALUE
        val authDetails = JWTGoogleDTO("access", "refresh", 60 * 60)
        val mockToken = TokenManagerController.createToken(
            TokenRequest(
                arrayListOf(authDetails),
                AuthProviderEnum.GOOGLE,
                mockUserID,
            ),
        )
        val name = "Boundary Name"

        // Mock the userCalendarService.removeTimeBoundary method
        whenever(userCalendarService.removeTimeBoundary(eq(mockToken), eq(name))).thenReturn(true)

        // Call the function and capture the response
        val response = userController.removeTimeBoundary(mockToken, name)

        // Verify the userCalendarService.removeTimeBoundary method was called with the correct parameters
        verify(userCalendarService).removeTimeBoundary(eq(mockToken), eq(name))

        // Check the response status and body
        assertEquals(HttpStatus.OK, response.statusCode)
        assertEquals(ResponseConstant.SUCCESSFULLY_REMOVED_TIME_BOUNDARY, response.body)
    }

    @Test
    fun `test removeTimeBoundary with missing token`() {
        // Mock request parameters with a missing token
        val name = "Boundary Name"

        // Call the function and capture the response
        val response = userController.removeTimeBoundary(null, name)

        // Check the response status and body
        assertEquals(HttpStatus.BAD_REQUEST, response.statusCode)
        assertEquals(ResponseConstant.REQUIRED_PARAMETERS_NOT_SET, response.body)
    }

    @Test
    fun `test removeTimeBoundary with userCalendarService returning false`() {
        // Mock request parameters
        val mockUserID = Int.MAX_VALUE
        val authDetails = JWTGoogleDTO("access", "refresh", 60 * 60)
        val mockToken = TokenManagerController.createToken(
            TokenRequest(
                arrayListOf(authDetails),
                AuthProviderEnum.GOOGLE,
                mockUserID,
            ),
        )
        val name = "Boundary Name"

        // Mock the userCalendarService.removeTimeBoundary method to return false
        whenever(userCalendarService.removeTimeBoundary(eq(mockToken), eq(name))).thenReturn(false)

        // Call the function and capture the response
        val response = userController.removeTimeBoundary(mockToken, name)

        // Verify the userCalendarService.removeTimeBoundary method was called with the correct parameters
        verify(userCalendarService).removeTimeBoundary(eq(mockToken), eq(name))

        // Check the response status and body
        assertEquals(HttpStatus.BAD_REQUEST, response.statusCode)
        assertEquals(ResponseConstant.SET_TIME_BOUNDARY_FAILED_INTERNAL_ERROR, response.body)
    }

    @Test
    fun `test getTimeBoundaries with valid token`() {
        // Mock request parameters
        val mockUserID = Int.MAX_VALUE
        val authDetails = JWTGoogleDTO("access", "refresh", 60 * 60)
        val mockToken = TokenManagerController.createToken(
            TokenRequest(
                arrayListOf(authDetails),
                AuthProviderEnum.GOOGLE,
                mockUserID,
            ),
        )

        // Mock the userCalendarService.getUserTimeBoundaries method
        val boundaries = mutableListOf<TimeBoundary>()
        val timeBoundary = TimeBoundary("Boundary1", "2023-07-30T12:00:00Z", "2023-07-30T14:00:00Z")
        boundaries.add(0, timeBoundary)
        whenever(userCalendarService.getUserTimeBoundaries(eq(mockToken))).thenReturn(boundaries)

        // Call the function and capture the response
        val response = userController.getTimeBoundaries(mockToken)

        // Verify the userCalendarService.getUserTimeBoundaries method was called with the correct token
        verify(userCalendarService).getUserTimeBoundaries(eq(mockToken))

        // Check the response status and body
        assertEquals(HttpStatus.OK, response.statusCode)

        // Convert the list of boundaries to JSON using Gson and check the response body
        val gson = GsonBuilder().setLenient().excludeFieldsWithoutExposeAnnotation().create()
        assertEquals(gson.toJson(boundaries), response.body)
    }

    @Test
    fun `test getTimeBoundaries with missing token`() {
        // Call the function and capture the response
        val response = userController.getTimeBoundaries(null)

        // Check the response status and body
        assertEquals(HttpStatus.BAD_REQUEST, response.statusCode)
        assertEquals(ResponseConstant.REQUIRED_PARAMETERS_NOT_SET, response.body)
    }

    @Test
    fun `test getTimeBoundaries with userCalendarService throwing an exception`() {
        // Mock request parameters
        val mockUserID = Int.MAX_VALUE
        val authDetails = JWTGoogleDTO("access", "refresh", 60 * 60)
        val mockToken = TokenManagerController.createToken(
            TokenRequest(
                arrayListOf(authDetails),
                AuthProviderEnum.GOOGLE,
                mockUserID,
            ),
        )

        // Mock the userCalendarService.getUserTimeBoundaries method to throw an exception
        whenever(userCalendarService.getUserTimeBoundaries(eq(mockToken))).thenThrow(RuntimeException("Error fetching boundaries."))

        // Call the function and capture the response
        val response = userController.getTimeBoundaries(mockToken)
        // Verify the userCalendarService.getUserTimeBoundaries method was called with the correct token
        verify(userCalendarService).getUserTimeBoundaries(eq(mockToken))
        // Check the response status and body
        assertEquals(HttpStatus.BAD_REQUEST, response.statusCode)
        assertEquals(ResponseConstant.GENERIC_INTERNAL_ERROR, response.body)
    }

    @Test
    fun `test getTimeBoundaryAndLocation with valid token and location`() {
        // Mock request parameters
        val mockUserID = Int.MAX_VALUE
        val authDetails = JWTGoogleDTO("access", "refresh", 60 * 60)
        val mockToken = TokenManagerController.createToken(
            TokenRequest(
                arrayListOf(authDetails),
                AuthProviderEnum.GOOGLE,
                mockUserID,
            ),
        )
        val location = "London"
        // Mock the userCalendarService.getUserTimeBoundaryAndLocation method
        val boundary = TimeBoundary("Boundary1", "2023-07-30T12:00:00Z", "2023-07-30T14:00:00Z")
        whenever(userCalendarService.getUserTimeBoundaryAndLocation(eq(mockToken), eq(location))).thenReturn(Pair(boundary, location))
        // Call the function and capture the response
        val response = userController.getTimeBoundaryAndLocation(mockToken, location)
        // Verify the userCalendarService.getUserTimeBoundaryAndLocation method was called with the correct parameters
        verify(userCalendarService).getUserTimeBoundaryAndLocation(eq(mockToken), eq(location))
        // Check the response status and body
        assertEquals(HttpStatus.OK, response.statusCode)
        // Convert the boundaryAndLocation to JSON using Gson and check the response body
        val gson = Gson()
        assertEquals(gson.toJson(Pair(boundary, location)), response.body)
    }

    @Test
    fun `test getTimeBoundaryAndLocation with missing token`() {
        // Mock request parameters with a missing token
        val location = "London"
        // Call the function and capture the response
        val response = userController.getTimeBoundaryAndLocation(null, location)
        // Check the response status and body
        assertEquals(HttpStatus.BAD_REQUEST, response.statusCode)
        assertEquals(ResponseConstant.REQUIRED_PARAMETERS_NOT_SET, response.body)
    }
}

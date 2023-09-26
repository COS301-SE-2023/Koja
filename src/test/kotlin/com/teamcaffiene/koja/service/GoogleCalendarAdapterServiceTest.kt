package com.teamcaffiene.koja.service

import com.google.api.services.calendar.Calendar
import com.teamcaffeine.koja.controller.TokenManagerController
import com.teamcaffeine.koja.controller.TokenManagerController.Companion.createToken
import com.teamcaffeine.koja.controller.TokenRequest
import com.teamcaffeine.koja.dto.JWTAuthDetailsDTO
import com.teamcaffeine.koja.dto.JWTGoogleDTO
import com.teamcaffeine.koja.dto.UserEventDTO
import com.teamcaffeine.koja.entity.User
import com.teamcaffeine.koja.entity.UserAccount
import com.teamcaffeine.koja.enums.AuthProviderEnum
import com.teamcaffeine.koja.enums.CallbackConfigEnum
import com.teamcaffeine.koja.repository.UserAccountRepository
import com.teamcaffeine.koja.repository.UserRepository
import com.teamcaffeine.koja.service.GoogleCalendarAdapterService
import io.github.cdimascio.dotenv.Dotenv
import io.mockk.every
import io.mockk.mockkObject
import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.assertThrows
import org.mockito.ArgumentMatchers.any
import org.mockito.ArgumentMatchers.anyString
import org.mockito.Mock
import org.mockito.Mockito.verifyZeroInteractions
import org.mockito.Mockito.`when`
import org.mockito.MockitoAnnotations
import org.mockito.kotlin.eq
import org.mockito.kotlin.spy
import org.mockito.kotlin.times
import org.mockito.kotlin.verify
import org.mockito.kotlin.whenever
import org.springframework.http.HttpMethod
import org.springframework.http.ResponseEntity
import org.springframework.web.client.RestTemplate
import java.lang.System.setProperty
import java.time.OffsetDateTime

class GoogleCalendarAdapterServiceTest {
    @Mock
    lateinit var userRepository: UserRepository

    @Mock
    lateinit var calendar: Calendar

    @Mock
    val restTemplate: RestTemplate = RestTemplate()

    @Mock
    lateinit var userAccountRepository: UserAccountRepository

    @Mock
    private lateinit var service: GoogleCalendarAdapterService
    private lateinit var dotenv: Dotenv

    @BeforeEach
    fun setup() {
        MockitoAnnotations.openMocks(this)

        importEnvironmentVariables()

        service = spy(GoogleCalendarAdapterService(userRepository, userAccountRepository))
    }

    private fun importEnvironmentVariables() {
        dotenv = Dotenv.load()

        dotenv["KOJA_AWS_RDS_DATABASE_URL"]?.let { setProperty("KOJA_AWS_RDS_DATABASE_URL", it) }
        dotenv["KOJA_AWS_RDS_DATABASE_ADMIN_USERNAME"]?.let { setProperty("KOJA_AWS_RDS_DATABASE_ADMIN_USERNAME", it) }
        dotenv["KOJA_AWS_RDS_DATABASE_ADMIN_PASSWORD"]?.let { setProperty("KOJA_AWS_RDS_DATABASE_ADMIN_PASSWORD", it) }

        dotenv["GOOGLE_CLIENT_ID"]?.let { setProperty("GOOGLE_CLIENT_ID", it) }
        dotenv["GOOGLE_CLIENT_SECRET"]?.let { setProperty("GOOGLE_CLIENT_SECRET", it) }
        dotenv["API_KEY"]?.let { setProperty("API_KEY", it) }

        dotenv["KOJA_JWT_SECRET"]?.let { setProperty("KOJA_JWT_SECRET", it) }
    }

    /*
        Scenario 1: Only one location that are in the future
     */
    @Test
    fun testGetFutureEventsLocationsScenario1() {
        val accessToken = "test_token"

        val location1 = "loc1"
        val location2 = "loc2"

        val event1 = UserEventDTO(
            id = "1",
            summary = "desc1",
            location = location1,
            startTime = OffsetDateTime.now().plusDays(2),
            endTime = OffsetDateTime.now().plusDays(2),
            duration = 1,
            timeSlots = emptyList(),
            priority = 1,
            dynamic = false,
            userID = "1",
        )
        val event2 = UserEventDTO(
            id = "2",
            summary = "desc2",
            location = location2,
            startTime = OffsetDateTime.now().minusDays(2),
            endTime = OffsetDateTime.now().minusDays(1),
            duration = 1,
            timeSlots = emptyList(),
            priority = 1,
            dynamic = false,
            userID = "1",
        )

        val mockResponse: List<UserEventDTO> = listOf(event1, event2)

        whenever(service.getUserEventsInRange(eq(accessToken), any<OffsetDateTime>(), any<OffsetDateTime>())).thenReturn(mockResponse)

        val futureEvents = service.getFutureEventsLocations(eq(accessToken))

        assertEquals((listOf(location1)), (futureEvents))
    }

    /*
            Scenario 2: More than one location that are in the future
     */
    @Test
    fun testGetFutureEventsLocationsScenario2() {
        val accessToken = "test_token"

        val location1 = "loc1"
        val location2 = "loc2"

        val event1 = UserEventDTO(
            id = "1",
            summary = "desc1",
            location = location1,
            startTime = OffsetDateTime.now().plusDays(5),
            endTime = OffsetDateTime.now().plusDays(6),
            duration = 1,
            timeSlots = emptyList(),
            priority = 1,
            dynamic = false,
            userID = "1",
        )
        val event2 = UserEventDTO(
            id = "2",
            summary = "desc2",
            location = location2,
            startTime = OffsetDateTime.now().plusDays(2),
            endTime = OffsetDateTime.now().plusDays(3),
            duration = 1,
            timeSlots = emptyList(),
            priority = 1,
            dynamic = false,
            userID = "1",
        )
        val event3 = UserEventDTO(
            id = "3",
            summary = "desc3",
            location = location1,
            startTime = OffsetDateTime.now().minusDays(2),
            endTime = OffsetDateTime.now().minusDays(1),
            duration = 1,
            timeSlots = emptyList(),
            priority = 1,
            dynamic = false,
            userID = "1",
        )
        // Define your mock response

        val mockResponse: List<UserEventDTO> = listOf(event1, event2, event3)

        whenever(service.getUserEventsInRange(eq(accessToken), any<OffsetDateTime>(), any<OffsetDateTime>())).thenReturn(mockResponse)

        val futureEvents = service.getFutureEventsLocations(eq(accessToken))

        assertEquals((listOf(location1, location2)), (futureEvents))
    }

    /*
            Scenario 3: No locations that are in the future
     */
    @Test
    fun testGetFutureEventsLocationsScenario3() {
        val accessToken = "test_token"

        val location1 = "loc1"
        val location2 = "loc2"

        val event1 = UserEventDTO(
            id = "1",
            summary = "desc1",
            location = location1,
            startTime = OffsetDateTime.now().minusDays(2),
            endTime = OffsetDateTime.now().minusDays(1),
            duration = 1,
            timeSlots = emptyList(),
            priority = 1,
            dynamic = false,
            userID = "1",
        )
        val event2 = UserEventDTO(
            id = "2",
            summary = "desc2",
            location = location2,
            startTime = OffsetDateTime.now().minusDays(2),
            endTime = OffsetDateTime.now().minusDays(1),
            duration = 1,
            timeSlots = emptyList(),
            priority = 1,
            dynamic = false,
            userID = "1",
        )
        val event3 = UserEventDTO(
            id = "3",
            summary = "desc3",
            location = location1,
            startTime = OffsetDateTime.now().minusDays(2),
            endTime = OffsetDateTime.now().minusDays(1),
            duration = 1,
            timeSlots = emptyList(),
            priority = 1,
            dynamic = false,
            userID = "1",
        )
        // Define your mock response

        val mockResponse: List<UserEventDTO> = listOf(event1, event2, event3)

        whenever(service.getUserEventsInRange(eq(accessToken), any<OffsetDateTime>(), any<OffsetDateTime>())).thenReturn(mockResponse)

        val futureEvents = service.getFutureEventsLocations(eq(accessToken))

        assertEquals((emptyList<String>()), (futureEvents))
    }

    /*
            Scenario 4: Parameter is null
     */
    @Test
    fun testGetFutureEventsLocationsScenario4() {
        assertThrows<IllegalArgumentException> { service.getFutureEventsLocations(null) }
    }

    @Test
    fun `test oauth2Callback with valid auth code and existing user account`() {
        // Mock the necessary variables and objects

        mockkObject(TokenManagerController.Companion)
        every { TokenManagerController.Companion.createToken(TokenRequest(listOf<JWTAuthDetailsDTO>(), AuthProviderEnum.GOOGLE, 5)) } returns "expected_jwt_token"
        val authCode = "valid_auth_code"
        val deviceType = CallbackConfigEnum.WEB
        val serverAddress = "https://example.com"
        val expectedJwtToken = "expected_jwt_token"

        // Mock the response entity from the REST API call
        val responseEntity = ResponseEntity.ok("response_body")
        `when`(restTemplate.exchange(anyString(), eq(HttpMethod.POST), any(), eq(String::class.java)))
            .thenReturn(responseEntity)

        // Mock the userAccountRepository.findByEmail() method
        val existingUser = UserAccount()
        `when`(userAccountRepository.findByEmail(anyString())).thenReturn(existingUser)

        // Mock the refreshAccessToken() method
        `when`(service.refreshAccessToken(anyString(), anyString(), anyString())).thenReturn(JWTGoogleDTO("access_token", "refresh_token", 5))

        // Mock the createToken() method
        // `when`(createToken(TokenRequest(listOf<JWTAuthDetailsDTO>(), AuthProviderEnum.GOOGLE, 5))).thenReturn(expectedJwtToken)

        // Call the function being tested
        val result = service.oauth2Callback(authCode, deviceType)

        // Assert the result
        assertEquals(expectedJwtToken, result)

        // Verify the interactions with the mocked dependencies
        verify(restTemplate, times(1)).exchange(anyString(), eq(HttpMethod.POST), any(), eq(String::class.java))
        verify(userAccountRepository, times(1)).findByEmail(anyString())
        verify(service, times(1)).refreshAccessToken(anyString(), anyString(), anyString())
        // verify(service.createToken(), times(1)).invoke(any(TokenRequest::class.java))
    }

    @Test
    fun `test oauth2Callback with valid auth code and new user account`() {
        // Mock the necessary variables and objects
        val authCode = "valid_auth_code"
        val deviceType = CallbackConfigEnum.WEB
        val serverAddress = "https://example.com"
        val expectedJwtToken = "expected_jwt_token"

        mockkObject(TokenManagerController.Companion)
        every { TokenManagerController.Companion.createToken(TokenRequest(listOf<JWTAuthDetailsDTO>(), AuthProviderEnum.GOOGLE, 5)) } returns "expected_jwt_token"

        // Mock the response entity from the REST API call
        val responseEntity = ResponseEntity.ok("response_body")
        `when`(restTemplate.exchange(anyString(), eq(HttpMethod.POST), any(), eq(String::class.java)))
            .thenReturn(responseEntity)

        // Mock the userAccountRepository.findByEmail() method
        `when`(userAccountRepository.findByEmail(anyString())).thenReturn(null)

        // Mock the createNewUser( b) method
        val newUser = User()
        `when`(service.createNewUser(anyString(), anyString())).thenReturn(newUser)
        `when`(userRepository.save(org.mockito.kotlin.any<User>())).thenReturn(newUser)

        // Mock the createToken() method
        `when`(createToken(TokenRequest(listOf<JWTAuthDetailsDTO>(), AuthProviderEnum.GOOGLE, 5))).thenReturn(expectedJwtToken)

        // Call the function being tested
        val result = service.oauth2Callback(authCode, deviceType)

        // Assert the result
        assertEquals(expectedJwtToken, result)

        // Verify the interactions with the mocked dependencies
        verify(restTemplate, times(1)).exchange(anyString(), eq(HttpMethod.POST), any(), eq(String::class.java))
        verify(userAccountRepository, times(1)).findByEmail(anyString())
        verify(service, times(1)).createNewUser(anyString(), anyString())
        verify(userRepository, times(1)).save(newUser)
        // verify(createToken, times(1)).invoke(any(TokenRequest::class.java))
    }

    @Test
    fun `test oauth2Callback with invalid auth code`() {
        // Mock the necessary variables and objects
        val authCode = null
        val deviceType = CallbackConfigEnum.WEB

        // Call the function being tested and assert that it throws an exception
        assertThrows<Exception> { service.oauth2Callback(authCode, deviceType) }

        // Verify that the expected exception was thrown
        verifyZeroInteractions(restTemplate)
        verifyZeroInteractions(userAccountRepository)
        verifyZeroInteractions(userRepository)
        // verifyZeroInteractions(createToken)
    }

    @Test
    fun testCreateNewUser() {
        val newUserEmail = "test@example.com"
        val refreshToken = "testRefreshToken"
        val storedUser = User()
        storedUser.id = 1
        // Mock user account object
        val newUserAccount = UserAccount()
        newUserAccount.email = newUserEmail
        newUserAccount.refreshToken = refreshToken
        newUserAccount.authProvider = AuthProviderEnum.GOOGLE
        newUserAccount.userID = 1
        newUserAccount.user = storedUser

        // Mock repository behavior
        `when`(userRepository.save(storedUser)).thenReturn(storedUser)
        `when`(userAccountRepository.save(newUserAccount)).thenReturn(newUserAccount)

        // Call the function
        val createdUser = service.createNewUser(newUserEmail, refreshToken)

        // Verify that the function performs the expected operations
        storedUser.getCurrentLocation()?.let { assertEquals(it.first, .0) }
        storedUser.getCurrentLocation()?.let { assertEquals(it.second, .0) }
        assertEquals(storedUser.getHomeLocation(), "Uninitialised")
        assertEquals(storedUser.getWorkLocation(), "Uninitialised")

        assertEquals(newUserAccount.email, newUserEmail)
        assertEquals(newUserAccount.refreshToken, refreshToken)
        assertEquals(newUserAccount.authProvider, AuthProviderEnum.GOOGLE)
        assertEquals(newUserAccount.userID, storedUser.id)
        assertEquals(newUserAccount.user, storedUser)

        // Verify that userRepository.save and userAccountRepository.save were called
        verify(userRepository, times(1)).save(storedUser)
        verify(userAccountRepository, times(1)).save(newUserAccount)

        // Verify that the createdUser matches the expected newUser
        assertEquals(createdUser, storedUser)
    }

    @Test
    fun testAddUserEmail() {
        // Mock input data
        val newUserEmail = "test@example.com"
        val refreshToken = "testRefreshToken"
        val storedUser = User()
        storedUser.id = 1
        // Mock user account object
        val newUserAccount = UserAccount()
        newUserAccount.email = newUserEmail
        newUserAccount.refreshToken = refreshToken
        newUserAccount.authProvider = AuthProviderEnum.GOOGLE
        newUserAccount.userID = 1
        newUserAccount.user = storedUser

        // Mock repository behavior
        `when`(userAccountRepository.save(newUserAccount)).thenReturn(newUserAccount)
        `when`(userRepository.save(storedUser)).thenReturn(storedUser)

        // Call the function
        service.addUserEmail(newUserEmail, refreshToken, storedUser)

        // Verify that the user account was saved
        // verify(userAccountRepository, times(1)).save(newUserAccount)

        // Verify that the user was updated with the new user account
        assertEquals(storedUser.userAccounts.size, 1)
        assertEquals(storedUser.userAccounts[0].userID, newUserAccount.userID)
        assertEquals(storedUser.userAccounts[0].email, newUserAccount.email)
        assertEquals(storedUser.userAccounts[0].authProvider, newUserAccount.authProvider)
        // Verify that the user was saved
        // verify(userRepository, times(1)).save(storedUser)
    }

    @Test
    fun testDeleteEvent_Success() {
        // Mock a successful event deletion
        val eventID = "event123"
        `when`(calendar.events().delete("primary", eventID)).thenReturn(null)

        // No exceptions should be thrown
        val accessToken = "your-access-token"
        val result = service.deleteEvent(accessToken, eventID)

        assert(result) // Deletion should succeed
    }

    @Test
    fun testDeleteEvent_Failure() {
        // Mock an exception when trying to delete the event
        val eventID = "event456"
        `when`(calendar.events().delete("primary", eventID)).thenThrow(Exception("Failed to delete event"))
        val accessToken = "your-access-token"
        val result = service.deleteEvent(accessToken, eventID)

        assert(!result) // Deletion should fail
    }
}

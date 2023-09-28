package com.teamcaffiene.koja.service

import com.google.api.client.http.javanet.NetHttpTransport
import com.google.api.client.json.jackson2.JacksonFactory
import com.google.api.client.util.DateTime
import com.google.api.services.calendar.Calendar
import com.google.api.services.calendar.model.Event
import com.google.api.services.calendar.model.EventDateTime
import com.google.api.services.calendar.model.Events
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
import org.mockito.ArgumentMatchers.argThat
import org.mockito.Mock
import org.mockito.Mockito.times
import org.mockito.Mockito.verifyZeroInteractions
import org.mockito.Mockito.`when`
import org.mockito.MockitoAnnotations
import org.mockito.kotlin.eq
import org.mockito.kotlin.spy
import org.mockito.kotlin.verify
import org.mockito.kotlin.whenever
import org.springframework.http.HttpEntity
import org.springframework.http.HttpHeaders
import org.springframework.http.HttpMethod
import org.springframework.http.HttpStatus
import org.springframework.http.MediaType
import org.springframework.http.ResponseEntity
import org.springframework.util.LinkedMultiValueMap
import org.springframework.web.client.RestTemplate
import org.springframework.web.util.UriComponentsBuilder
import java.lang.System.setProperty
import java.time.OffsetDateTime
import com.google.api.services.calendar.Calendar as GoogleCalendar

class GoogleCalendarAdapterServiceTest {
    @Mock
    lateinit var userRepository: UserRepository

    @Mock
    lateinit var calendar: Calendar

    @Mock
    lateinit var restTemplate: RestTemplate

    @Mock
    lateinit var userAccountRepository: UserAccountRepository

    @Mock
    private lateinit var service: GoogleCalendarAdapterService
    private lateinit var dotenv: Dotenv

    @BeforeEach
    fun setup() {
        MockitoAnnotations.openMocks(this)

        importEnvironmentVariables()
        restTemplate = RestTemplate()
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

        whenever(
            service.getUserEventsInRange(
                eq(accessToken),
                any<OffsetDateTime>(),
                any<OffsetDateTime>(),
            ),
        ).thenReturn(mockResponse)

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

        whenever(
            service.getUserEventsInRange(
                eq(accessToken),
                any<OffsetDateTime>(),
                any<OffsetDateTime>(),
            ),
        ).thenReturn(mockResponse)

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

        whenever(
            service.getUserEventsInRange(
                eq(accessToken),
                any<OffsetDateTime>(),
                any<OffsetDateTime>(),
            ),
        ).thenReturn(mockResponse)

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
        every {
            TokenManagerController.Companion.createToken(
                TokenRequest(
                    listOf<JWTAuthDetailsDTO>(),
                    AuthProviderEnum.GOOGLE,
                    5,
                ),
            )
        } returns "expected_jwt_token"
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
        `when`(
            service.refreshAccessToken(
                anyString(),
                anyString(),
                anyString(),
            ),
        ).thenReturn(JWTGoogleDTO("access_token", "refresh_token", 5))

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
        every {
            TokenManagerController.Companion.createToken(
                TokenRequest(
                    listOf<JWTAuthDetailsDTO>(),
                    AuthProviderEnum.GOOGLE,
                    5,
                ),
            )
        } returns "expected_jwt_token"

        // Mock the response entity from the REST API call
        val responseEntity = ResponseEntity.ok("response_body")
        `when`(restTemplate.exchange(eq("url"), eq(HttpMethod.POST), any(), eq(String::class.java)))
            .thenReturn(responseEntity)

        // Mock the userAccountRepository.findByEmail() method
        `when`(userAccountRepository.findByEmail(anyString())).thenReturn(null)

        // Mock the createNewUser( b) method
        val newUser = User()
        `when`(userRepository.save(org.mockito.kotlin.any<User>())).thenReturn(newUser)

        // Mock the createToken() method
        `when`(createToken(TokenRequest(listOf<JWTAuthDetailsDTO>(), AuthProviderEnum.GOOGLE, 5))).thenReturn(
            expectedJwtToken,
        )

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

        `when`(service.buildCalendarService("accessToken")).thenReturn(calendar)

        `when`(calendar.events().delete("primary", eventID).execute()).thenReturn(null)

        // No exceptions should be thrown
        val accessToken = "your-access-token"
        val result = service.deleteEvent(accessToken, eventID)

        assert(result) // Deletion should succeed
    }

    @Test
    fun testDeleteEvent_Failure() {
        // Mock an exception when trying to delete the event
        val eventID = "event456"
        `when`(service.buildCalendarService("accessToken")).thenReturn(calendar)

        // `when`(calendar.events()?.delete("primary", eventID)?.execute() ?: calendar).thenThrow(Exception("Failed to delete event"))
        val accessToken = "your-access-token"
        val result = service.deleteEvent(accessToken, eventID)

        assert(!result) // Deletion should fail
    }

    @Test
    fun `test secondsToHumanFormat with positive seconds`() {
        // Arrange
        val seconds: Long = 3665 // 1 hour, 1 minute, and 5 seconds

        // Act
        val result = service.secondsToHumanFormat(seconds)

        // Assert
        assertEquals("01h 01m 05s", result)
    }

    @Test
    fun `test secondsToHumanFormat with zero seconds`() {
        // Arrange
        val seconds: Long = 0

        // Act
        val result = service.secondsToHumanFormat(seconds)

        // Assert
        assertEquals("00s", result)
    }

    @Test
    fun `test secondsToHumanFormat with negative seconds`() {
        // Arrange
        val seconds: Long = -100

        // Act and Assert
        assertThrows<IllegalArgumentException> {
            service.secondsToHumanFormat(seconds)
        }
    }

    @Test
    fun testAddAnotherEmailOauth2Callback() {
        // Arrange
        val expectedAccessToken = "access_token"
        val expectedRefreshToken = "refresh_token"
        val expectedExpiresIn = 3600L
        val expectedUserEmail = "user@example.com"
        val tokenEndpointUrl = "https://oauth2.googleapis.com/token"
        // Mock the behavior of restTemplate.exchange
        val responseHeaders = HttpHeaders()
        val responseJson =
            "{\"access_token\":\"expectedAccessToken\",\"expires_in\":expires_in,\"refresh_token\":\"expectedRefreshToken\"}"
        "}"
        val headers = org.springframework.http.HttpHeaders()
        headers.contentType = MediaType.APPLICATION_FORM_URLENCODED
        headers.accept = listOf(MediaType.APPLICATION_JSON)

        val parameters = LinkedMultiValueMap<String, String>()
        parameters.add("grant_type", "authorization_code")
        parameters.add("code", "authCode")
        parameters.add("client_id", System.getProperty("GOOGLE_CLIENT_ID"))
        parameters.add("client_secret", System.getProperty("GOOGLE_CLIENT_SECRET"))

        val requestEntity = HttpEntity(parameters, headers)

        responseHeaders.contentType = MediaType.APPLICATION_JSON
        val builder = UriComponentsBuilder
            .fromHttpUrl(tokenEndpointUrl)
            .queryParams(parameters)
        val requestUrl = builder.build().encode().toUri()
        val responseEntity = ResponseEntity(responseJson, responseHeaders, HttpStatus.OK)

        whenever(restTemplate.exchange(requestUrl, HttpMethod.POST, requestEntity, String::class.java))
            .thenReturn(responseEntity)
        whenever(userAccountRepository.findByEmail(anyString())).thenReturn(UserAccount())

        // Mock getUserEmail and other relevant methods

        // Act
        val jwtToken = service.addAnotherEmailOauth2Callback("authCode", "token", true)

        // Assert
        assertEquals(expectedAccessToken, jwtToken)
        val body = HttpEntity(
            "code=authCode&client_id=GOOGLE_CLIENT_ID&client_secret=GOOGLE_CLIENT_Secret&redirect_uri=http://localhost:8080/oauth2/callback&grant_type=authorization_code",
            HttpHeaders(),
        )
        // Verify that restTemplate.exchange was called with the correct arguments
        verify(restTemplate).exchange(
            eq("https://oauth2.googleapis.com/token"),
            eq(HttpMethod.POST),
            argThat { body is HttpEntity && (body as HttpEntity<*>).body.toString().contains("code=authCode") },
            eq(String::class.java),
        )

        // Add more assertions as needed to verify the behavior of your function
        /* @Test
    @Transactional
    fun testCreateNewCalendar() {
        // Set up test data
        val userAccounts = listOf(UserAccount())
        val eventDTO = UserEventDTO(Event().setRecurringEventId("minima").setStart(EventDateTime()).setEnd(EventDateTime()))
        val event = Event().setRecurringEventId("minima").setStart(EventDateTime()).setEnd(EventDateTime())
        val userEvents = listOf(eventDTO)
        val jwtToken = "jwtToken"
        val accessToken = "accessToken"
        // Mock the dependencies
        // `when`(service.buildCalendarService(accessToken)).thenReturn(GoogleCalendar())
        `when`(service.createEventInSuggestions(accessToken, eventDTO, jwtToken, "Koja-Suggestions")).thenReturn(event)

        // Call the function under test
        service.createNewCalendar(userAccounts, userEvents, jwtToken)

        // Assert the expected behavior
        // ...
    }*/

        @Test
        fun testCreateNewCalendar2() {
            // Create mock dependencies
            val jwtToken = JWTGoogleDTO("accessToken", "refreshToken", 3600)
            val userAccounts = listOf(UserAccount())
            val eventDTO = UserEventDTO(
                Event().setId("minima").setStart(EventDateTime().setDate(DateTime("2022-03-15")))
                    .setEnd(EventDateTime().setDate(DateTime("2022-03-16"))),
            )
            val event = Event().setRecurringEventId("minima").setStart(EventDateTime()).setEnd(EventDateTime())
            val userEvents = listOf(eventDTO)
            `when`(service.refreshAccessToken(eq("clientId"), eq("clientSecret"), anyString())).thenReturn(jwtToken)
            val calendarService = GoogleCalendar(NetHttpTransport(), JacksonFactory(), null)
            `when`(service.buildCalendarService(jwtToken.getAccessToken())).thenReturn(
                GoogleCalendar(
                    NetHttpTransport(),
                    JacksonFactory(),
                    null,
                ),
            )
            `when`(calendarService.calendars().get(anyString()).execute()).thenReturn(null)
            `when`(calendarService.events().list(anyString()).execute()).thenReturn(Events())
            `when`(calendarService.events().delete(anyString(), anyString()).execute()).thenReturn(null)
            `when`(service.createCalendar(calendarService, "id", userAccounts.get(0))).thenReturn("Created")

            // Call the function under test
            service.createNewCalendar(userAccounts, userEvents, "jwtToken")

            // Verify interactions with the mocked dependencies
            verify(calendarService.calendars(), times(1)).get(anyString())
            verify(calendarService.events(), times(userEvents.size)).delete(anyString(), anyString())
            verify(calendarService.calendars(), times(1)).delete(anyString())
            // verify(service, times(1)).createCalendar(Calendar(), anyString(), any(UserAccount::class.java))
            verify(service, times(userEvents.size)).createEventInSuggestions(
                anyString(),
                eventDTO,
                anyString(),
                anyString(),
            )
        }
    }
}

package com.teamcaffiene.koja.controller

import com.google.api.client.util.DateTime
import com.google.api.services.calendar.model.Event
import com.google.api.services.calendar.model.EventDateTime
import com.teamcaffeine.koja.constants.EnvironmentVariableConstant
import com.teamcaffeine.koja.constants.ResponseConstant
import com.teamcaffeine.koja.controller.CalendarController
import com.teamcaffeine.koja.controller.TokenManagerController
import com.teamcaffeine.koja.controller.TokenRequest
import com.teamcaffeine.koja.dto.JWTGoogleDTO
import com.teamcaffeine.koja.dto.UserEventDTO
import com.teamcaffeine.koja.enums.AuthProviderEnum
import com.teamcaffeine.koja.service.UserCalendarService
import io.github.cdimascio.dotenv.Dotenv
import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.Test
import org.mockito.InjectMocks
import org.mockito.Mock
import org.mockito.Mockito.`when`
import org.mockito.MockitoAnnotations
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import java.time.LocalDateTime
import java.time.OffsetDateTime
import java.time.ZoneId
import java.time.ZoneOffset

class CalendarControllerUnitTest {
    @Mock
    private lateinit var userCalendarService: UserCalendarService

    @InjectMocks
    private lateinit var calendarController: CalendarController

    private lateinit var dotenv: Dotenv

    @BeforeEach
    fun setup() {
        MockitoAnnotations.openMocks(this)
        importEnvironmentVariables()
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

    @Test
    fun testGetAllUserEvents() {
        // Mock the behavior of the userCalendarService
        val mockUserID = Int.MAX_VALUE
        val authDetails = JWTGoogleDTO("access", "refresh", 60 * 60)
        val mockToken = TokenManagerController.createToken(
            TokenRequest(
                arrayListOf(authDetails),
                AuthProviderEnum.GOOGLE,
                mockUserID,
            ),
        )
        val userEvents = arrayListOf<UserEventDTO>()
        `when`(userCalendarService.getAllUserEvents(mockToken)).thenReturn(userEvents)

        // Invoke the getAllUserEvents method in the calendarController
        val responseEntity: ResponseEntity<out Any> = calendarController.getAllUserEvents(mockToken)

        // Verify the result
        assertEquals(HttpStatus.OK, responseEntity.statusCode)
        assertEquals(userEvents, responseEntity.body)
    }

    @Test
    fun test_empty_userEvent_list() {
        val mockUserID = Int.MAX_VALUE
        val authDetails = JWTGoogleDTO("access", "refresh", 60 * 60)
        val mockToken = TokenManagerController.createToken(
            TokenRequest(
                arrayListOf(authDetails),
                AuthProviderEnum.GOOGLE,
                mockUserID,
            ),
        )
        val userEvents = emptyList<UserEventDTO>()

        `when`(userCalendarService.getAllUserEvents(mockToken)).thenReturn(userEvents)

        val responseEntity: ResponseEntity<out Any> = calendarController.getAllUserEvents(mockToken)

        assertEquals(userEvents, responseEntity.body)
    }

    @Test
    fun `test setSuggestedCalendar with valid input`() {
        // Arrange
        val mockUserID = Int.MAX_VALUE
        val authDetails = JWTGoogleDTO("access", "refresh", 60 * 60)
        val mockToken = TokenManagerController.createToken(
            TokenRequest(
                arrayListOf(authDetails),
                AuthProviderEnum.GOOGLE,
                mockUserID,
            ),
        )
        val eventList = arrayListOf<UserEventDTO>()

        // Act
        val response = calendarController.setSuggestedCalendar(mockToken, eventList)

        // Assert
        assert(response.statusCode == HttpStatus.OK)
        assert(response.body == ResponseConstant.USER_CALENDAR_SET)
    }

    @Test
    fun `test setSuggestedCalendar with missing parameters`() {
        // Arrange
        val token = null
        val eventList = emptyList<UserEventDTO>()

        // Act
        val response = calendarController.setSuggestedCalendar(token, eventList)

        // Assert
        assert(response.statusCode == HttpStatus.BAD_REQUEST)
        assert(response.body == ResponseConstant.REQUIRED_PARAMETERS_NOT_SET)
    }

    @Test
    fun `rescheduleEvent should update event and return OK`() {
        val mockUserID = Int.MAX_VALUE
        val authDetails = JWTGoogleDTO("access", "refresh", 60 * 60)
        val mockToken = TokenManagerController.createToken(
            TokenRequest(
                arrayListOf(authDetails),
                AuthProviderEnum.GOOGLE,
                mockUserID,
            ),
        )
        val event = UserEventDTO(Event().setId("minimanimo").setStart(EventDateTime().setDate(DateTime("2022-03-15"))).setEnd(EventDateTime().setDate(DateTime("2022-03-16"))))
        event.setDuration(60)
        val timeZoneId = ZoneId.of("Africa/Johannesburg")
        val startTime = OffsetDateTime.of(2023, 9, 4, 12, 0, 0, 0, ZoneOffset.ofHours(2))
        event.setStartTime(startTime)
        val dateTime = LocalDateTime.of(2023, 8, 30, 13, 0) // Create a LocalDateTime object with the desired date and time
        val endTime = OffsetDateTime.of(dateTime, ZoneOffset.ofHours(2))
        event.setEndTime(endTime)
        val currentTime = OffsetDateTime.now(timeZoneId)
        val endTimeUpdated = currentTime.plusMinutes(60)
        // doNothing().`when`(userCalendarService.deleteEvent(token, "", startTime, endTime))
        //  doNothing().`when`(userCalendarService.createEvent(token, event))
        `when`(userCalendarService.getAllUserEvents(mockToken)).thenReturn(listOf(event))

        val response = calendarController.rescheduleEvent(mockToken, event)

        assert(response.statusCode == HttpStatus.OK)
        assert(response.body == ResponseConstant.EVENT_UPDATED)
        // assert(event.getStartTime() != null) // Verify startTime is set
        // assert(event.getEndTime() != null) // Verify endTime is set
        // assert(event.getStartTime() == currentTime) // Verify startTime is set
        // assert(event.getEndTime() != endTimeUpdated)
    }

    // TODO: Fix this test
    @Test
    fun `rescheduleEvent should return BAD_REQUEST when event update fails`() {
        val token = "valid_token"
        val event = UserEventDTO(Event().setId("minimanimo").setStart(EventDateTime().setDate(DateTime("2022-03-15"))).setEnd(EventDateTime().setDate(DateTime("2022-03-16"))))
        // doNothing().`when`(userCalendarService.deleteEvent(token, "", OffsetDateTime.now(), OffsetDateTime.now()))
        `when`(userCalendarService.getAllUserEvents(token)).thenReturn(listOf(event))

        val response = calendarController.rescheduleEvent(token, null)

        assert(response.statusCode == HttpStatus.BAD_REQUEST)
        assert(response.body == ResponseConstant.REQUIRED_PARAMETERS_NOT_SET)
    }
}

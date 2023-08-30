package com.teamcaffiene.koja.controller

import com.google.api.services.calendar.model.Event
import com.teamcaffeine.koja.constants.ResponseConstant
import com.teamcaffeine.koja.controller.CalendarController
import com.teamcaffeine.koja.dto.UserEventDTO
import com.teamcaffeine.koja.service.TimezoneUtility
import com.teamcaffeine.koja.service.UserCalendarService
import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.Test
import org.mockito.InjectMocks
import org.mockito.Mock
import org.mockito.Mockito.`when`
import org.mockito.MockitoAnnotations
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import java.time.OffsetDateTime
import java.time.ZoneId

class CalendarControllerUnitTest {
    @Mock
    private lateinit var userCalendarService: UserCalendarService

    @InjectMocks
    private lateinit var calendarController: CalendarController

    @BeforeEach
    fun setup() {
        MockitoAnnotations.openMocks(this)
    }

    @Test
    fun testGetAllUserEvents() {
        // Mock the behavior of the userCalendarService
        val token = "testToken"
        val userEvents = arrayListOf<UserEventDTO>()
        `when`(userCalendarService.getAllUserEvents(token)).thenReturn(userEvents)

        // Invoke the getAllUserEvents method in the calendarController
        val responseEntity: ResponseEntity<out Any> = calendarController.getAllUserEvents(token)

        // Verify the result
        assertEquals(HttpStatus.OK, responseEntity.statusCode)
        assertEquals(userEvents, responseEntity.body)
    }

    @Test
    fun test_empty_userEvent_list() {
        val token = "token"
        val userEvents = emptyList<UserEventDTO>()

        `when`(userCalendarService.getAllUserEvents(token)).thenReturn(userEvents)

        val responseEntity: ResponseEntity<out Any> = calendarController.getAllUserEvents(token)

        assertEquals(userEvents, responseEntity.body)
    }

    @Test
    fun `rescheduleEvent should return BAD_REQUEST when event or token is null`() {
        val response = calendarController.rescheduleEvent(null, null)

        assert(response.statusCode == HttpStatus.BAD_REQUEST)
        assert(response.body == ResponseConstant.REQUIRED_PARAMETERS_NOT_SET)
    }

    @Test
    fun `rescheduleEvent should update event and return OK`() {
        val token = "valid_token"
        val event = UserEventDTO(Event())
        val currentTime = OffsetDateTime.now()

        `when`(userCalendarService.updateEvent(token, event)).thenReturn(true)

        val response = calendarController.rescheduleEvent(token, event)

        assert(response.statusCode == HttpStatus.OK)
        assert(response.body == ResponseConstant.EVENT_UPDATED)
        assert(event.getStartTime() != null) // Verify startTime is set
        assert(event.getEndTime() != null) // Verify endTime is set
        // You might want to verify that startTime and endTime are correctly calculated
    }

    @Test
    fun `rescheduleEvent should return BAD_REQUEST when event update fails`() {
        val token = "valid_token"
        val event = UserEventDTO(Event())

        `when`(userCalendarService.updateEvent(token, event)).thenReturn(false)

        val response = calendarController.rescheduleEvent(token, event)

        assert(response.statusCode == HttpStatus.BAD_REQUEST)
        assert(response.body == ResponseConstant.EVENT_UPDATE_FAILED_INTERNAL_ERROR)
    }

    @Test
    fun `should return bad request when event and token are null`() {
        val response = calendarController.rescheduleEvent(null, null)
        assert(response.statusCode == HttpStatus.BAD_REQUEST)
        assert(response.body == ResponseConstant.REQUIRED_PARAMETERS_NOT_SET)
    }

    @Test
    fun `should return bad request when event is null`() {
        val response = calendarController.rescheduleEvent("token", null)
        assert(response.statusCode == HttpStatus.BAD_REQUEST)
        assert(response.body == ResponseConstant.REQUIRED_PARAMETERS_NOT_SET)
    }

    @Test
    fun `should return bad request when token is null`() {
        val response = calendarController.rescheduleEvent(null, UserEventDTO(Event()))
        assert(response.statusCode == HttpStatus.BAD_REQUEST)
        assert(response.body == ResponseConstant.REQUIRED_PARAMETERS_NOT_SET)
    }

    @Test
    fun `should return bad request when time zone is invalid`() {
        val token = "token"
        val event = UserEventDTO(Event())
        `when`(TimezoneUtility().getTimeOfTimeZone(token)).thenThrow(IllegalArgumentException())
        val response = calendarController.rescheduleEvent(token, event)
        assert(response.statusCode == HttpStatus.BAD_REQUEST)
        assert(response.body == ResponseConstant.EVENT_UPDATE_FAILED_INTERNAL_ERROR)
    }

    @Test
    fun `should return bad request when an exception occurs`() {
        val token = "token"
        val event = UserEventDTO(Event())
        `when`(TimezoneUtility().getTimeOfTimeZone(token)).thenReturn("America/New_York")
        `when`(userCalendarService.updateEvent(token, event)).thenThrow(Exception())
        val response = calendarController.rescheduleEvent(token, event)
        assert(response.statusCode == HttpStatus.BAD_REQUEST)
        assert(response.body == ResponseConstant.EVENT_UPDATE_FAILED_INTERNAL_ERROR)
    }

    @Test
    fun `should return ok when event is successfully updated`() {
        val token = "token"
        val event = UserEventDTO(Event())
        event.setDuration(7200)
        `when`(TimezoneUtility().getTimeOfTimeZone(token)).thenReturn("America/New_York")
        `when`(userCalendarService.updateEvent(token, event)).thenReturn(true)
        val response = calendarController.rescheduleEvent(token, event)

        assertEquals(event.getStartTime(), OffsetDateTime.now(ZoneId.of("America/New_York")))
        assertEquals(event.getEndTime(), OffsetDateTime.now(ZoneId.of("America/New_York")).plusHours(event.getDurationInSeconds() / 60 / 60))
        assert(response.statusCode == HttpStatus.OK)
        assert(response.body == ResponseConstant.EVENT_UPDATED)
    }

    @Test
    fun `should return bad request when event update fails`() {
        val token = "token"
        val event = UserEventDTO(Event())
        `when`(TimezoneUtility().getTimeOfTimeZone(token)).thenReturn("America/New_York")
        `when`(userCalendarService.updateEvent(token, event)).thenReturn(false)
        val response = calendarController.rescheduleEvent(token, event)
        assert(response.statusCode == HttpStatus.BAD_REQUEST)
        assert(response.body == ResponseConstant.EVENT_UPDATE_FAILED_INTERNAL_ERROR)
    }
}

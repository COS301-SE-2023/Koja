package com.teamcaffiene.koja.controller

import com.google.api.client.util.DateTime
import com.google.api.services.calendar.model.Event
import com.google.api.services.calendar.model.EventDateTime
import com.teamcaffeine.koja.constants.ResponseConstant
import com.teamcaffeine.koja.controller.CalendarController
import com.teamcaffeine.koja.dto.UserEventDTO
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
import java.time.LocalDateTime
import java.time.OffsetDateTime
import java.time.ZoneId
import java.time.ZoneOffset

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
    fun `test setSuggestedCalendar with valid input`() {
        // Arrange
        val token = "validToken"
        val eventList = arrayListOf<UserEventDTO>()

        // Act
        val response = calendarController.setSuggestedCalendar(token, eventList)

        // Assert
        assert(response.statusCode == HttpStatus.OK)
        assert(response.body == "New calendar successfully created.")
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
        val token = "valid_token"
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
        `when`(userCalendarService.getAllUserEvents(token)).thenReturn(listOf(event))

        val response = calendarController.rescheduleEvent(token, event)

        assert(response.statusCode == HttpStatus.OK)
        assert(response.body == ResponseConstant.EVENT_UPDATED)
        // assert(event.getStartTime() != null) // Verify startTime is set
        // assert(event.getEndTime() != null) // Verify endTime is set
        // assert(event.getStartTime() == currentTime) // Verify startTime is set
        // assert(event.getEndTime() != endTimeUpdated)
    }

    @Test
    fun `rescheduleEvent should return BAD_REQUEST when event update fails`() {
        val token = "valid_token"
        val event = UserEventDTO(Event().setId("minimanimo").setStart(EventDateTime().setDate(DateTime("2022-03-15"))).setEnd(EventDateTime().setDate(DateTime("2022-03-16"))))
        // doNothing().`when`(userCalendarService.deleteEvent(token, "", OffsetDateTime.now(), OffsetDateTime.now()))
        `when`(userCalendarService.getAllUserEvents(token)).thenReturn(listOf(event))

        val response = calendarController.rescheduleEvent(token, event)

        assert(response.statusCode == HttpStatus.BAD_REQUEST)
        assert(response.body == ResponseConstant.REQUIRED_PARAMETERS_NOT_SET)
    }
}

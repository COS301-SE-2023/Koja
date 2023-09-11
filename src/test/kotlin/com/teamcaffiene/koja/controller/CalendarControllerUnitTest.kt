package com.teamcaffiene.koja.controller

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
    fun `test getAllUserEventsKojaSuggestions with valid token`() {
        // Arrange
        val token = "validToken"

        // Act
        val response = calendarController.getAllUserEventsKojaSuggestions(token)

        // Assert
        assert(response.statusCode == HttpStatus.OK)
    }

    @Test
    fun `test getAllUserEventsKojaSuggestions with missing token`() {
        // Arrange
        val token = null

        // Act
        val response = calendarController.getAllUserEventsKojaSuggestions(token)

        // Assert
        assert(response.statusCode == HttpStatus.BAD_REQUEST)
        assert(response.body == ResponseConstant.REQUIRED_PARAMETERS_NOT_SET)
    }

   /* @Test
    fun `test setSuggestedCalendar with userCalendar exception`() {
        // Arrange
        val token = "validToken"
        val eventList = arrayListOf<UserEventDTO>()
        // Mock an exception in userCalendar.createNewCalendar
        userCalendarService.setThrowException(true)

        // Act and Assert
        assertThrows(ResponseStatusException::class.java) {
            controller.setSuggestedCalendar(token, eventList)
        }
    }*/
}

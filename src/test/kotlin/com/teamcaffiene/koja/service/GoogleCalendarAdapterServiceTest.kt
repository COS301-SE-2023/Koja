package com.teamcaffiene.koja.service

import com.teamcaffeine.koja.controller.CalendarController
import com.teamcaffeine.koja.dto.UserEventDTO
import com.teamcaffeine.koja.service.GoogleCalendarAdapterService
import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.Test
import org.mockito.InjectMocks
import org.mockito.Mock
import org.mockito.Mockito.`when`
import org.mockito.MockitoAnnotations
import java.time.OffsetDateTime


class GoogleCalendarAdapterServiceTest {
    @Mock
    private lateinit var googleCalendarAdapterService: GoogleCalendarAdapterService

    @BeforeEach
    fun setup() {
        MockitoAnnotations.openMocks(this)
    }

    @Test
    fun testGetFutureEventsLocations() {
        // Mock the behavior of the googleCalendarAdapterService
        val accessToken = "testAccessToken"
        val eventList = listOf(
                UserEventDTO("1", "Event 1", "Location 1", OffsetDateTime.now(), OffsetDateTime.now().plusDays(2), 2, listOf(), 1),
                UserEventDTO("2", "Event 2", "Location 2", OffsetDateTime.now(), OffsetDateTime.now().plusDays(3), 3, listOf(), 1),
                UserEventDTO("3", "Event 3", "Location 1", OffsetDateTime.now(), OffsetDateTime.now().plusDays(4), 4, listOf(), 1)
        )
        `when`(googleCalendarAdapterService.getUserEventsInRange(
                accessToken,
                OffsetDateTime.now().minusDays(1),
                OffsetDateTime.now().plusYears(1)
        )).thenReturn(eventList)

        // Invoke the getFutureEventsLocations method in the calendarController
        val result: List<String> = googleCalendarAdapterService.getFutureEventsLocations(accessToken)

        // Verify the result
        assertEquals(listOf("Location 1", "Location 2"), result)
    }
}

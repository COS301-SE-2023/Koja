package com.teamcaffiene.koja.dto

import com.google.api.client.util.DateTime
import com.google.api.services.calendar.model.Event
import com.google.api.services.calendar.model.EventDateTime
import com.teamcaffeine.koja.dto.UserEventDTO
import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.api.Test
import java.time.OffsetDateTime

class UserEventDTOTest {

    @Test
    fun createGoogleEventDTO_SUCCESS() {
        // Given
        val event = Event()
            .setId("1")
            .setSummary("desc1")
            .setLocation("800 Howard St., San Francisco, CA 94103")
        val startDateTime = DateTime("2015-05-28T09:00:00-07:00")
        val start = EventDateTime()
            .setDateTime(startDateTime)
            .setTimeZone("America/Los_Angeles")
        event.setStart(start)

        val endDateTime = DateTime("2015-05-28T17:00:00-07:00")
        val end = EventDateTime()
            .setDateTime(endDateTime)
            .setTimeZone("America/Los_Angeles")
        event.setEnd(end)

        // When
        val userEventDTO = UserEventDTO(event)

        // Then
        assertEquals("desc1", userEventDTO.getSummary())
        assertEquals("1", userEventDTO.getId())
        assertEquals("800 Howard St., San Francisco, CA 94103", userEventDTO.getLocation())
    }

    @Test

    fun CreateUserEventDTO_SUCESS() {
        // When
        val event = UserEventDTO("1", "desc1", "loc1", OffsetDateTime.now().minusDays(2), OffsetDateTime.now().minusDays(1), 1, emptyList(), 1, false)

        // Then
        assertEquals("1", event.getId())
        assertEquals("desc1", event.getSummary())
        assertEquals("loc1", event.getLocation())
    }
}

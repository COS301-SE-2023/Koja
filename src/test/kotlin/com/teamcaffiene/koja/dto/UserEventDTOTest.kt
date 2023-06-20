package com.teamcaffiene.koja.dto
import com.teamcaffeine.koja.dto.UserEventDTO
import com.google.api.client.util.DateTime
import com.google.api.services.calendar.model.Event
import com.google.api.services.calendar.model.EventDateTime
import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.api.Test
import java.util.*


class UserEventDTOTest {

    //private val userEventDTO : UserEventDTO

    @Test
    fun `CreateGoogleEventDTO_SUCCESS`(){
        //Given
        val event = Event()
                .setId("1")
                .setDescription("A chance to hear more about Google's developer products.")
                .setLocation("800 Howard St., San Francisco, CA 94103");
        val startDateTime = DateTime("2015-05-28T09:00:00-07:00");
        val start = EventDateTime()
                .setDateTime(startDateTime)
                .setTimeZone("America/Los_Angeles");
        event.setStart(start);

        val endDateTime = DateTime("2015-05-28T17:00:00-07:00");
        val end = EventDateTime()
                .setDateTime(endDateTime)
                .setTimeZone("America/Los_Angeles");
        event.setEnd(end);

        //When
        val userEventDTO = UserEventDTO(event)

        //Then
        assertEquals("A chance to hear more about Google's developer products.",userEventDTO.getDescription())
        assertEquals("1",userEventDTO.getId())
        assertEquals("800 Howard St., San Francisco, CA 94103",userEventDTO.getLocation())
        assertEquals(Date(DateTime("2015-05-28T09:00:00-07:00").value),userEventDTO.getStartTime())

    }

    @Test

    fun `CreateUserEventDTO_SUCESS`(){
        //When
        val userEventDTO = UserEventDTO("1","5KM Morning Jog", "LC sports center",
                Date(2015,5,28,7,0), Date(2015,5,28,9,0))

        //Then
        assertEquals("1",userEventDTO.getId())
        assertEquals("5KM Morning Jog",userEventDTO.getDescription())
        assertEquals("LC sports center",userEventDTO.getLocation())
        assertEquals(Date(2015,5,28,7,0),userEventDTO.getStartTime())

    }

}
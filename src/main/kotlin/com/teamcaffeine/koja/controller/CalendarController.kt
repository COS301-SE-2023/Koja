package com.teamcaffeine.koja.controller

import com.teamcaffeine.koja.dto.UserEventDTO
import com.teamcaffeine.koja.service.UserCalendarService
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RequestHeader
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController

@RestController
@RequestMapping("/api/v1/user/calendar")
class CalendarController(private val userCalendar: UserCalendarService) {

    data class AddEventRequest(
        val token: String,
        val event: UserEventDTO
    )

    @GetMapping("/userEvents")
    fun getAllUserEvents(@RequestHeader("Authorisation") token: String): ResponseEntity<List<UserEventDTO>> {
        return ResponseEntity.ok(userCalendar.getAllUserEvents(token))
    }

    @PostMapping("/createEvent")
    fun addEvent(@RequestBody addEventRequest: AddEventRequest): ResponseEntity<String> {
        try {
            userCalendar.createEvent(addEventRequest.token, addEventRequest.event)
        } catch (e: Exception) {
            if (e.message.equals("Could not find a time slot where the event can fit"))
                return ResponseEntity.badRequest().body("Event not added, could not find a time slot where the event can fit.")

            return ResponseEntity.internalServerError().body("Event could no be created.")
        }
        return ResponseEntity.ok("Event added.")
    }

    @PostMapping("/updateEvent")
    fun updateEvent(@RequestBody updateEvent: AddEventRequest): ResponseEntity<String> {
        try {
            userCalendar.updateEvent(updateEvent.token, updateEvent.event)
        } catch (e: Exception) {
            return ResponseEntity.badRequest().body("Event could not be updated.")
        }
        return ResponseEntity.ok("Event updated")
    }

    @PostMapping("/deleteEvent")
    fun deleteEvent(@RequestBody eventToDelete: AddEventRequest): ResponseEntity<String> {
        try {
            userCalendar.deleteEvent(eventToDelete.token, eventToDelete.event)
        } catch (e: Exception) {
            return ResponseEntity.badRequest().body("Event could not be deleted.")
        }
        return ResponseEntity.ok("Event deleted.")
    }
}

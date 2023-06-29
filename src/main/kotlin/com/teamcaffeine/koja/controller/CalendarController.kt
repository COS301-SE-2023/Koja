package com.teamcaffeine.koja.controller

import com.teamcaffeine.koja.constants.HeaderConstants
import com.teamcaffeine.koja.dto.UserEventDTO
import com.teamcaffeine.koja.service.UserCalendarService
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.DeleteMapping
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.PutMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RequestHeader
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController

@RestController
@RequestMapping("/api/v1/user/calendar")
class CalendarController(private val userCalendar: UserCalendarService) {

    @PostMapping("/createEvent")
    fun addEvent(@RequestHeader(HeaderConstants.AUTHORISATION) token: String, @RequestBody event: UserEventDTO): ResponseEntity<String> {
        try {
            userCalendar.createEvent(token, event)
        } catch (e: Exception) {
            if (e.message.equals("Could not find a time slot where the event can fit")) {
                return ResponseEntity.badRequest().body("Event not added, could not find a time slot where the event can fit.")
            }

            return ResponseEntity.internalServerError().body("Event could no be created.")
        }
        return ResponseEntity.ok("Event added.")
    }

    @GetMapping("/userEvents")
    fun getAllUserEvents(@RequestHeader(HeaderConstants.AUTHORISATION) token: String): ResponseEntity<List<UserEventDTO>> {
        return ResponseEntity.ok(userCalendar.getAllUserEvents(token))
    }

    @PutMapping("/updateEvent")
    fun updateEvent(@RequestHeader(HeaderConstants.AUTHORISATION) token: String, @RequestBody updatedEvent: UserEventDTO): ResponseEntity<String> {
        try {
            userCalendar.updateEvent(token, updatedEvent)
        } catch (e: Exception) {
            return ResponseEntity.badRequest().body("Event could not be updated.")
        }
        return ResponseEntity.ok("Event updated")
    }

    @DeleteMapping("/deleteEvent")
    fun deleteEvent(@RequestHeader(HeaderConstants.AUTHORISATION) token: String, @RequestBody eventToDeleteID: String): ResponseEntity<String> {
        try {
            userCalendar.deleteEvent(token, eventToDeleteID)
        } catch (e: Exception) {
            return ResponseEntity.badRequest().body("Event could not be deleted.")
        }
        return ResponseEntity.ok("Event deleted.")
    }
}

package com.teamcaffeine.koja.controller

import com.teamcaffeine.koja.dto.UserEventDTO
import com.teamcaffeine.koja.service.UserCalendarService
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController

@RestController
@RequestMapping("/api/v1/user/calendar")
class CalendarController(private val userCalendar: UserCalendarService) {\

    data class AddEventRequest(
        val token: String,
        val event: UserEventDTO
    )


    @GetMapping("/userEvents")
    fun getAllUserEvents(@RequestBody token: String): ResponseEntity<List<UserEventDTO>> {
        return ResponseEntity.ok(userCalendar.getAllUserEvents(token))
    }

    @PostMapping("/addEvent")
    fun addEvent(@RequestBody addEventRequest: AddEventRequest): ResponseEntity<String> {
        userCalendar.ge
        return ResponseEntity.ok("Event added")
    }

}

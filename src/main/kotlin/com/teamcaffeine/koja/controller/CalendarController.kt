package com.teamcaffeine.koja.controller

import com.teamcaffeine.koja.entity.Event
import com.teamcaffeine.koja.entity.UserCalendar
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController

@RestController
@RequestMapping("/api/v1/user/calendar")
class CalendarController(private val userCalendar: UserCalendar) {
    @GetMapping("/events")
    fun getAllUserEvents(@PathVariable userId: String?): ResponseEntity<List<Event>> {
        return ResponseEntity.ok(userCalendar.events)
    }
}

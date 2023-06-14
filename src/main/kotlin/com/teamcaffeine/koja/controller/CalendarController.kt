package com.teamcaffeine.koja.controller

import com.teamcaffeine.koja.entity.UserCalendar
import com.teamcaffeine.koja.entity.UserEvent
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController

@RestController
@RequestMapping("/api/v1/user/calendar")
class CalendarController(private val userCalendar: UserCalendar) {
    @GetMapping("/userEvents")
    fun getAllUserEvents(@PathVariable userId: String?): ResponseEntity<List<UserEvent>> {
        return ResponseEntity.ok(userCalendar.userEvents)
    }
}

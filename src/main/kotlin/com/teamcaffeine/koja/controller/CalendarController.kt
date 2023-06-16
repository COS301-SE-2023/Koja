package com.teamcaffeine.koja.controller

import com.teamcaffeine.koja.repository.UserAccountRepository
import com.teamcaffeine.koja.repository.UserRepository
import com.teamcaffeine.koja.service.GoogleCalendarAdapterService
import com.teamcaffeine.koja.service.UserCalendarService
import com.teamcaffeine.koja.service.UserEventService
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController

@RestController
@RequestMapping("/api/v1/user/calendar")
class CalendarController(private val userCalendar: UserCalendarService, private val userRepository: UserRepository, private val userAccountRepository: UserAccountRepository) {
    @GetMapping("/userEvents")
    fun getAllUserEvents(@RequestBody token: String): ResponseEntity<List<UserEventService>> {
        return ResponseEntity.ok(GoogleCalendarAdapterService(userRepository, userAccountRepository).getUserEvents(token))
        return ResponseEntity.ok(userCalendar.getAllUserEvents(token))
    }
}

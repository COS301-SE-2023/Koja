package com.teamcaffeine.koja.controller

import com.teamcaffeine.koja.constants.ExceptionMessageConstant
import com.teamcaffeine.koja.constants.HeaderConstant
import com.teamcaffeine.koja.constants.ResponseConstant
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
import java.time.OffsetDateTime
import java.time.ZoneId

@RestController
@RequestMapping("/api/v1/user/calendar")
class CalendarController(private val userCalendar: UserCalendarService) {
    @PostMapping("/createEvent")
    fun addEvent(
        @RequestHeader(HeaderConstant.AUTHORISATION) token: String?,
        @RequestBody event: UserEventDTO?,
    ): ResponseEntity<String> {
        return if (token == null || event == null) {
            ResponseEntity.badRequest().body(ResponseConstant.REQUIRED_PARAMETERS_NOT_SET)
        } else {
            try {
                userCalendar.createEvent(token, event)
            } catch (e: Exception) {
                if (e.message.equals(ExceptionMessageConstant.UNABLE_TO_FIT_EVENT)) {
                    ResponseEntity.badRequest()
                        .body(ResponseConstant.EVENT_CREATION_FAILED_COULD_NOT_FIT)
                }
                return ResponseEntity.internalServerError().body(e.message)
            }
            ResponseEntity.ok(ResponseConstant.EVENT_CREATED)
        }
    }

    @GetMapping("/userEvents")
    fun getAllUserEvents(@RequestHeader(HeaderConstant.AUTHORISATION) token: String?): ResponseEntity<out Any> {
        return if (token == null) {
            ResponseEntity.badRequest().body(ResponseConstant.REQUIRED_PARAMETERS_NOT_SET)
        } else {
            ResponseEntity.ok(userCalendar.getAllUserEvents(token))
        }
    }

    @PutMapping("/updateEvent")
    fun updateEvent(
        @RequestHeader(HeaderConstant.AUTHORISATION) token: String?,
        @RequestBody updatedEvent: UserEventDTO?,
    ): ResponseEntity<String> {
        return if (token == null || updatedEvent == null) {
            return ResponseEntity.badRequest().body(ResponseConstant.REQUIRED_PARAMETERS_NOT_SET)
        } else {
            try {
                deleteEvent(token, updatedEvent)
                addEvent(token, updatedEvent)
//                userCalendar.updateEvent(token, updatedEvent)
            } catch (e: Exception) {
                ResponseEntity.badRequest().body(ResponseConstant.EVENT_UPDATE_FAILED_INTERNAL_ERROR)
            }
            ResponseEntity.ok(ResponseConstant.EVENT_UPDATED)
        }
    }

    @DeleteMapping("/deleteEvent")
    fun deleteEvent(
        @RequestHeader(HeaderConstant.AUTHORISATION) token: String?,
        @RequestBody event: UserEventDTO?,
    ): ResponseEntity<String> {
        if (event == null || token == null) {
            return ResponseEntity.badRequest().body(ResponseConstant.REQUIRED_PARAMETERS_NOT_SET)
        }

        try {
            userCalendar.deleteEvent(token, event.getId())
        } catch (e: Exception) {
            return ResponseEntity.badRequest().body(ResponseConstant.EVENT_DELETION_FAILED_INTERNAL_ERROR)
        }

        return ResponseEntity.ok(ResponseConstant.EVENT_DELETED)
    }

    @PostMapping("/rescheduleEvent")
    fun rescheduleEvent(
        @RequestHeader(HeaderConstant.AUTHORISATION) token: String?,
        @RequestBody event: UserEventDTO?,
    ): ResponseEntity<String> {
        if (event == null || token == null) {
            return ResponseEntity.badRequest().body(ResponseConstant.REQUIRED_PARAMETERS_NOT_SET)
        }
        try {
            // val timeZoneId = ZoneId.of(TimezoneUtility(userRepository, googleCalendarAdapterService).getTimeOfTimeZone(token))
            val timeZoneId = ZoneId.of("Africa/Johannesburg")
            val currentTime = OffsetDateTime.now(timeZoneId)
            userCalendar.deleteEvent(token, event.getId())
            event.setStartTime(currentTime)
            event.setEndTime(currentTime.plusSeconds(event.getDurationInSeconds()))
            val events = userCalendar.getAllUserEvents(token)
            if (checkAvailability(events)) {
                userCalendar.createEvent(token, event)
                return ResponseEntity.ok(ResponseConstant.EVENT_UPDATED)
            }
        } catch (e: Exception) {
            return ResponseEntity.badRequest().body(e.stackTraceToString())
        }
        return ResponseEntity.badRequest().body(ResponseConstant.EVENT_UPDATE_FAILED_INTERNAL_ERROR)
    }

    @PostMapping("/rescheduleTimeSlot")
    fun rescheduleEventSlot(
        @RequestHeader(HeaderConstant.AUTHORISATION) token: String?,
        @RequestBody event: UserEventDTO?,
    ): ResponseEntity<String> {
        if (event == null || token == null) {
            return ResponseEntity.badRequest().body(ResponseConstant.REQUIRED_PARAMETERS_NOT_SET)
        }
        try {
            // val timeZoneId = ZoneId.of(TimezoneUtility(userRepository, googleCalendarAdapterService).getTimeOfTimeZone(token))
            val timeZoneId = ZoneId.of("Africa/Johannesburg")
            val currentTime = OffsetDateTime.now(timeZoneId)
            userCalendar.deleteEvent(token, event.getId())
            val events = userCalendar.getAllUserEvents(token)
            val timeslot = userCalendar.findEarliestTimeSlot(events, event)
            event.setStartTime(timeslot.first)
            event.setEndTime(timeslot.second)
            userCalendar.createEvent(token, event)
            return ResponseEntity.ok(ResponseConstant.EVENT_UPDATED)
        } catch (e: Exception) {
            return ResponseEntity.badRequest().body(e.stackTraceToString())
        }
        return ResponseEntity.badRequest().body(ResponseConstant.EVENT_UPDATE_FAILED_INTERNAL_ERROR)
    }

    fun checkAvailability(events: List<UserEventDTO>): Boolean {
        for (e in events) {
            if (e.getStartTime() <= OffsetDateTime.now() && e.getEndTime() >= OffsetDateTime.now()) {
                return false
            }
        }
        return true
    }

    @PostMapping("/setSuggestedCalendar")
    fun setSuggestedCalendar(
        @RequestHeader(HeaderConstant.AUTHORISATION) token: String?,
        @RequestBody eventList: List<UserEventDTO>,
    ): ResponseEntity<out Any> {
        if (eventList == null || token == null) {
            return ResponseEntity.badRequest().body(ResponseConstant.REQUIRED_PARAMETERS_NOT_SET)
        } else {
            try {
                userCalendar.createNewCalendar(token, eventList)
            } catch (e: Exception) {
                return ResponseEntity.badRequest().body(e.printStackTrace())
            }
            return ResponseEntity.ok("New calendar successfully created.")
        }
    }

    @GetMapping("/userEventsKojaSuggestions")
    fun getAllUserEventsKojaSuggestions(@RequestHeader(HeaderConstant.AUTHORISATION) token: String?): ResponseEntity<out Any> {
        return if (token == null) {
            ResponseEntity.badRequest().body(ResponseConstant.REQUIRED_PARAMETERS_NOT_SET)
        } else {
            ResponseEntity.ok(userCalendar.getAllUserEventsKojaSuggestions(token))
        }
    }
}

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
        return when {
            token == null || event == null -> {
                ResponseEntity.badRequest().body(ResponseConstant.REQUIRED_PARAMETERS_NOT_SET)
            }
            !TokenManagerController.isTokenValid(token) -> {
                ResponseEntity.badRequest().body(ResponseConstant.INVALID_TOKEN)
            }
            else -> {
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
    }

    @GetMapping("/userEvents")
    fun getAllUserEvents(@RequestHeader(HeaderConstant.AUTHORISATION) token: String?): ResponseEntity<out Any> {
        return when {
            token == null -> {
                ResponseEntity.badRequest().body(ResponseConstant.REQUIRED_PARAMETERS_NOT_SET)
            }
            !TokenManagerController.isTokenValid(token) -> {
                ResponseEntity.badRequest().body(ResponseConstant.INVALID_TOKEN)
            }
            else -> {
                ResponseEntity.ok(userCalendar.getAllUserEvents(token))
            }
        }
    }

    @PutMapping("/updateEvent")
    fun updateEvent(
        @RequestHeader(HeaderConstant.AUTHORISATION) token: String?,
        @RequestBody updatedEvent: UserEventDTO?,
    ): ResponseEntity<String> {
        return when {
            token == null || updatedEvent == null -> {
                ResponseEntity.badRequest().body(ResponseConstant.REQUIRED_PARAMETERS_NOT_SET)
            }
            !TokenManagerController.isTokenValid(token) -> {
                ResponseEntity.badRequest().body(ResponseConstant.INVALID_TOKEN)
            }
            else -> {
                try {
                    deleteEvent(token, updatedEvent)
                    addEvent(token, updatedEvent)
//                    userCalendar.updateEvent(token, updatedEvent)
                } catch (e: Exception) {
                    ResponseEntity.badRequest().body(ResponseConstant.EVENT_UPDATE_FAILED_INTERNAL_ERROR)
                }
                ResponseEntity.ok(ResponseConstant.EVENT_UPDATED)
            }
        }
    }

    @DeleteMapping("/deleteEvent")
    fun deleteEvent(
        @RequestHeader(HeaderConstant.AUTHORISATION) token: String?,
        @RequestBody event: UserEventDTO?,
    ): ResponseEntity<String> {
        return when {
            token == null || event == null -> {
                ResponseEntity.badRequest().body(ResponseConstant.REQUIRED_PARAMETERS_NOT_SET)
            }
            !TokenManagerController.isTokenValid(token) -> {
                ResponseEntity.badRequest().body(ResponseConstant.INVALID_TOKEN)
            }
            else -> {
                try {
                    userCalendar.deleteEvent(token, event.getId())
                } catch (e: Exception) {
                    ResponseEntity.badRequest().body(ResponseConstant.EVENT_DELETION_FAILED_INTERNAL_ERROR)
                }
                ResponseEntity.ok(ResponseConstant.EVENT_DELETED)
            }
        }
    }

    @PostMapping("/rescheduleEvent")
    fun rescheduleEvent(
        @RequestHeader(HeaderConstant.AUTHORISATION) token: String?,
        @RequestBody event: UserEventDTO?,
    ): ResponseEntity<String> {
        return when {
            token == null || event == null -> {
                ResponseEntity.badRequest().body(ResponseConstant.REQUIRED_PARAMETERS_NOT_SET)
            }
            !TokenManagerController.isTokenValid(token) -> {
                ResponseEntity.badRequest().body(ResponseConstant.INVALID_TOKEN)
            }
            else -> {
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
                    ResponseEntity.badRequest().body(ResponseConstant.EVENT_UPDATE_FAILED_INTERNAL_ERROR)
                }
                ResponseEntity.ok(ResponseConstant.EVENT_UPDATED)
            }
        }
    }

    @PostMapping("/rescheduleTimeSlot")
    fun rescheduleEventSlot(
        @RequestHeader(HeaderConstant.AUTHORISATION) token: String?,
        @RequestBody event: UserEventDTO?,
    ): ResponseEntity<String> {
        return when {
            event == null || token == null -> {
                ResponseEntity.badRequest().body(ResponseConstant.REQUIRED_PARAMETERS_NOT_SET)
            }
            !TokenManagerController.isTokenValid(token) -> {
                ResponseEntity.badRequest().body(ResponseConstant.INVALID_TOKEN)
            }
            else -> {
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
                    ResponseEntity.ok(ResponseConstant.EVENT_UPDATED)
                } catch (e: Exception) {
                    ResponseEntity.badRequest().body(ResponseConstant.EVENT_UPDATE_FAILED_INTERNAL_ERROR)
                }
                ResponseEntity.ok(ResponseConstant.EVENT_UPDATED)
            }
        }
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
        @RequestBody eventList: List<UserEventDTO>?,
    ): ResponseEntity<out Any> {
        return when {
            eventList == null || token == null -> {
                ResponseEntity.badRequest().body(ResponseConstant.REQUIRED_PARAMETERS_NOT_SET)
            }
            !TokenManagerController.isTokenValid(token) -> {
                ResponseEntity.badRequest().body(ResponseConstant.INVALID_TOKEN)
            }
            else -> {
                try {
                    userCalendar.createNewCalendar(token, eventList)
                } catch (e: Exception) {
                    return ResponseEntity.badRequest().body(ResponseConstant.SET_USER_CALENDAR_FAILED_INTERNAL_ERROR)
                }
                ResponseEntity.ok(ResponseConstant.USER_CALENDAR_SET)
            }
        }
    }

    @GetMapping("/userEventsKojaSuggestions")
    fun getAllUserEventsKojaSuggestions(@RequestHeader(HeaderConstant.AUTHORISATION) token: String?): ResponseEntity<out Any> {
        return when {
            token == null -> {
                ResponseEntity.badRequest().body(ResponseConstant.REQUIRED_PARAMETERS_NOT_SET)
            }
            !TokenManagerController.isTokenValid(token) -> {
                ResponseEntity.badRequest().body(ResponseConstant.INVALID_TOKEN)
            }
            else -> {
                ResponseEntity.ok(userCalendar.getAllUserEventsKojaSuggestions(token))
            }
        }
    }
}

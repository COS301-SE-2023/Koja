package com.teamcaffeine.koja.controller

import com.teamcaffeine.koja.constants.ExceptionMessageConstant
import com.teamcaffeine.koja.constants.HeaderConstant
import com.teamcaffeine.koja.constants.ResponseConstant
import com.teamcaffeine.koja.dto.UserEventDTO
import com.teamcaffeine.koja.service.TimezoneUtility
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
                return ResponseEntity.internalServerError().body(ResponseConstant.EVENT_CREATION_FAILED_INTERNAL_ERROR)
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
            userCalendar.deleteEvent(token, event.getSummary(), event.getStartTime(), event.getEndTime())
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
            val timeZoneId = ZoneId.of(TimezoneUtility().getTimeOfTimeZone(token))
            val currentTime = OffsetDateTime.now(timeZoneId)
            event.setStartTime(currentTime)
            event.setEndTime(currentTime.plusHours(event.getDurationInSeconds() / 60 / 60))
            val updated = userCalendar.updateEvent(token, event)
            if (updated) {
                return ResponseEntity.ok(ResponseConstant.EVENT_UPDATED)
            } else {
                return ResponseEntity.badRequest().body(ResponseConstant.EVENT_UPDATE_FAILED_INTERNAL_ERROR)
            }
        } catch (e: Exception) {
            return ResponseEntity.badRequest().body(ResponseConstant.EVENT_UPDATE_FAILED_INTERNAL_ERROR)
        }
    }
}

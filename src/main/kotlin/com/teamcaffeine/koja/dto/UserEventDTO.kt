package com.teamcaffeine.koja.dto

import com.google.api.client.util.DateTime
import com.google.gson.Gson
import com.google.gson.reflect.TypeToken
import java.util.*
import com.google.api.services.calendar.model.Event as GoogleEvent
import com.google.api.services.calendar.model.EventDateTime as GoogleEventDateTime

class UserEventDTO(
    private var id: String,
    private var description: String,
    private var location: String,
    private var startTime: Date,
    private var endTime: Date,
    private var duration: Long,
    private var timeSlots: List<TimeSlot>,
    private var priority: Int,
    private var dynamic: Boolean = false
) {

    constructor(googleEvent: GoogleEvent) : this(
        id = googleEvent.id,
        description = googleEvent.summary ?: "",
        location = googleEvent.location ?: "",
        startTime = toKotlinDate(googleEvent.start) ?: Date(),
        endTime = toKotlinDate(googleEvent.end) ?: Date(),
        duration = googleEvent.extendedProperties?.shared?.get("duration")?.toLong() ?: 0L,
        timeSlots = googleEvent.extendedProperties?.shared?.get("timeSlots")?.let { parseTimeSlots(it) } ?: listOf(),
        priority = googleEvent.extendedProperties?.shared?.get("priority")?.toInt() ?: 0,
        dynamic = googleEvent.extendedProperties?.shared?.get("dynamic") == "true"
    )

    fun getId(): String {
        return id
    }

    fun getDescription(): String {
        return description
    }

    fun getLocation(): String {
        return location
    }

    fun getStartTime(): Date {
        return startTime
    }

    fun getEndTime(): Date {
        return endTime
    }

    fun setId(id: String) {
        this.id = id
    }

    fun setDescription(description: String) {
        this.description = description
    }

    fun setLocation(location: String) {
        this.location = location
    }

    fun setStartTime(startTime: Date) {
        this.startTime = startTime
    }

    fun setEndTime(endTime: Date) {
        this.endTime = endTime
    }

    fun isDynamic(): Boolean {
        return dynamic
    }

    fun setDynamic(dynamic: Boolean) {
        this.dynamic = dynamic
    }

    fun getDuration(): Long {
        return duration
    }

    fun getTimeSlots(): List<TimeSlot> {
        return timeSlots
    }

    fun getPriority(): Int {
        return priority
    }

    fun setDuration(duration: Long) {
        this.duration = duration
    }

    fun setTimeSlots(timeSlots: List<TimeSlot>) {
        this.timeSlots = timeSlots
    }

    fun setPriority(priority: Int) {
        this.priority = priority
    }

    companion object {
        private fun toKotlinDate(eventDateTime: GoogleEventDateTime): Date {
            val dateTime: DateTime? = eventDateTime.dateTime
            val date: DateTime? = eventDateTime.date

            if (dateTime != null) {
                return Date(dateTime.value)
            } else if (date != null) {
                return Date(date.value)
            }

            throw IllegalArgumentException("EventDateTime does not have a valid date or dateTime")
        }

        private fun parseTimeSlots(timeSlotsString: String): List<TimeSlot> {
            val gson = Gson()
            val timeSlotListType = object : TypeToken<List<TimeSlot>>() {}.type
            return gson.fromJson(timeSlotsString, timeSlotListType)
        }
    }
}

data class TimeSlot(val startTime: Date, val endTime: Date)

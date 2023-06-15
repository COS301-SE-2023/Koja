package com.teamcaffeine.koja.entity

import com.google.api.client.util.DateTime
import java.util.*
import com.google.api.services.calendar.model.Event as GoogleEvent
import com.google.api.services.calendar.model.EventDateTime as GoogleEventDateTime

class UserEvent(
    private var id: String,
    private var description: String,
    private var location: String,
    private var startTime: Date,
    private var endTime: Date
) {

    constructor(googleEvent: GoogleEvent) : this(
        id = googleEvent.id,
        description = googleEvent.description,
        location = googleEvent.location,
        startTime = toKotlinDate(googleEvent.start),
        endTime = toKotlinDate(googleEvent.end)
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

    companion object{
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
    }

}

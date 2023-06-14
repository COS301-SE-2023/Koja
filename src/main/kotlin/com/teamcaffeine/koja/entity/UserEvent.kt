package com.teamcaffeine.koja.entity

import java.time.format.DateTimeFormatter

class UserEvent(
    private var id: String,
    private var description: String,
    private var location: String,
    private var startTime: DateTimeFormatter,
    private var endTime: DateTimeFormatter
) {



    fun getId(): String {
        return id
    }

    fun getDescription(): String {
        return description
    }

    fun getLocation(): String {
        return location
    }

    fun getStartTime(): DateTimeFormatter {
        return startTime
    }

    fun getEndTime(): DateTimeFormatter {
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

    fun setStartTime(startTime: DateTimeFormatter) {
        this.startTime = startTime
    }

    fun setEndTime(endTime: DateTimeFormatter) {
        this.endTime = endTime
    }
}
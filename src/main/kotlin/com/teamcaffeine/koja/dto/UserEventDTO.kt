package com.teamcaffeine.koja.dto

import com.google.api.client.util.DateTime
import com.google.gson.GsonBuilder
import com.google.gson.JsonDeserializationContext
import com.google.gson.JsonDeserializer
import com.google.gson.JsonElement
import com.google.gson.reflect.TypeToken
import com.teamcaffeine.koja.enums.TimeBoundaryType
import java.lang.reflect.Type
import java.time.Instant
import java.time.OffsetDateTime
import java.time.ZoneOffset
import com.google.api.services.calendar.model.Event as GoogleEvent
import com.google.api.services.calendar.model.EventDateTime as GoogleEventDateTime

class UserEventDTO(
    private var id: String,
    private var summary: String,
    private var description: String? = null,
    private var location: String,
    private var startTime: OffsetDateTime,
    private var endTime: OffsetDateTime,
    private var duration: Long,
    private var timeSlots: List<TimeSlot>,
    private var priority: Int,
    private var dynamic: Boolean = false,
    private var travelTime: Long = 0L,
    private var userID: String = "",
    private var recurrence: MutableList<String>?  = null

) {

    constructor(googleEvent: GoogleEvent) : this(
        id = googleEvent.id,
        summary = googleEvent.summary ?: "",
        description = googleEvent.description ?: null,
        location = googleEvent.location ?: "",
        startTime = toKotlinDate(googleEvent.start) ?: OffsetDateTime.now(ZoneOffset.UTC),
        endTime = toKotlinDate(googleEvent.end) ?: OffsetDateTime.now(ZoneOffset.UTC),
        duration = googleEvent.extendedProperties?.shared?.get("duration")?.toLong() ?: 0L,
        timeSlots = googleEvent.extendedProperties?.shared?.get("timeSlots")?.let { parseTimeSlots(it) } ?: listOf(),
        priority = googleEvent.extendedProperties?.shared?.get("priority")?.toInt() ?: 0,
        dynamic = googleEvent.extendedProperties?.shared?.get("dynamic") == "true",
        travelTime = googleEvent.extendedProperties?.shared?.get("travelTime")?.toLong() ?: 0L,
        recurrence = googleEvent.recurrence ?: null
    )

    fun getId(): String {
        return id
    }

    fun getSummary(): String {
        return summary
    }

    fun getDescription(): String {
        return if (description == null) "" else description!!
    }

    fun getLocation(): String {
        return location
    }

    fun getStartTime(): OffsetDateTime {
        return startTime
    }

    fun getEndTime(): OffsetDateTime {
        return endTime
    }

    fun setId(id: String) {
        this.id = id
    }

    fun setSummary(summary: String) {
        this.summary = summary
    }

    fun setDescription(description: String) {
        this.description = description
    }

    fun setLocation(location: String) {
        this.location = location
    }

    fun setStartTime(startTime: OffsetDateTime) {
        this.startTime = startTime
    }

    fun setEndTime(endTime: OffsetDateTime) {
        this.endTime = endTime
    }

    fun setRecurrence(recurrence: MutableList<String>?) {
        this.recurrence = recurrence
    }
    fun isDynamic(): Boolean {
        return dynamic
    }

    fun setDynamic(dynamic: Boolean) {
        this.dynamic = dynamic
    }

    fun getDurationInMilliseconds(): Long {
        return duration
    }

    fun getDurationInSeconds(): Long {
        return duration.div(1000L)
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

    fun getTravelTime(): Long {
        return travelTime
    }

    fun setTravelTime(travelTime: Long) {
        this.travelTime = travelTime
    }

    fun setTimeSlots(timeSlots: List<TimeSlot>) {
        this.timeSlots = timeSlots
    }

    fun setPriority(priority: Int) {
        this.priority = priority
    }

    fun getUserID(): String {
        return userID
    }

    fun setUserID(userID: String) {
        this.userID = userID
    }

    fun getRecurrence(): MutableList<String>? {
        return recurrence
    }

    companion object {
        private fun toKotlinDate(eventDateTime: GoogleEventDateTime): OffsetDateTime? {
            val dateTime: DateTime? = eventDateTime.dateTime
            val date: DateTime? = eventDateTime.date

            if (dateTime != null) {
                return Instant.ofEpochMilli(dateTime.value).atOffset(ZoneOffset.UTC)
            } else if (date != null) {
                return Instant.ofEpochMilli(date.value).atOffset(ZoneOffset.UTC)
            }

            throw IllegalArgumentException("EventDateTime does not have a valid date or dateTime")
        }

        private fun parseTimeSlots(timeSlotsString: String): List<TimeSlot> {
            val gson = GsonBuilder()
                .registerTypeAdapter(OffsetDateTime::class.java, OffsetDateTimeAdapter())
                .create()
            val timeSlotListType = object : TypeToken<List<TimeSlot>>() {}.type
            return gson.fromJson(timeSlotsString, timeSlotListType)
        }
    }
}

data class TimeSlot(
    val name: String? = null,
    val startTime: OffsetDateTime,
    val endTime: OffsetDateTime,
    val type: TimeBoundaryType = TimeBoundaryType.ALLOWED,
)

class OffsetDateTimeAdapter : JsonDeserializer<OffsetDateTime> {
    override fun deserialize(json: JsonElement, typeOfT: Type, context: JsonDeserializationContext): OffsetDateTime {
        return OffsetDateTime.parse(json.asString)
    }
}

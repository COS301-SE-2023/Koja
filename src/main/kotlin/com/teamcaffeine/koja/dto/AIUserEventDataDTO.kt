package com.teamcaffeine.koja.dto

class AIUserEventDataDTO(private val timeFrame: List<TimeSlot>, private val userID: String?, private val category: String?, private val weekday: String?) {

    override fun toString(): String {
        return "AIUserEventDataDTO(timeFrame=$timeFrame, userID='$userID', category='$category', weekday='$weekday')"
    }

    fun toJson(): String {
        return mapOf(
            "userID" to userID,
            "category" to category,
            "weekday" to weekday,
            "timeFrame" to timeFrame,
        ).toString()
    }
}

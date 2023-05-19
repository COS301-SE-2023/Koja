package com.teamcaffeine.koja.entity


class User {
    var authToken: String? = null
    var slotGroups: List<TimeSlot>? = null
    var email: String? = null
    var locations: List<String>? = null
    var calendar: Calendar? = null
}
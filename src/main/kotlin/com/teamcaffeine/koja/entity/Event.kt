package com.teamcaffeine.koja.entity

import java.time.LocalDateTime

class Event(
    val eventID: Int? = null,

    val title: String,

    val summary: String? = null,

    val priority: Int? = null,

    val startDateTime: LocalDateTime,

    val endDateTime: LocalDateTime,

    val fixedEvent: Boolean? = null
)

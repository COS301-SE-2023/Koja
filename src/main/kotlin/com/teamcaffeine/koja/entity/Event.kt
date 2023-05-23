package com.teamcaffeine.koja.entity

import com.google.api.client.util.DateTime
import jakarta.persistence.*
import java.time.LocalDateTime

@Entity
@Table(name= "events")
class Event {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private var eventID : Int ?= null
    private var title : String ?= null
    private var summary: String ?= null
    private var priority: Integer ?= null
    private var startDateTime : DateTime?= null
    private var endDateTime : DateTime ?= null
    private var fixedEvent : Boolean ?= null

    constructor(title: String,startDateTime: DateTime?, endDateTime: DateTime?) {
        this.title = title
        this.startDateTime = startDateTime
        this.endDateTime = endDateTime
    }
}
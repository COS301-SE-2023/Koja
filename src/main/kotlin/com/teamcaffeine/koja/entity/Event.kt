package com.teamcaffeine.koja.entity

import com.google.api.client.util.DateTime
import jakarta.persistence.*

@Entity
@Table(name= "events")
class Event(title: String, private var startDateTime: DateTime?, private var endDateTime: DateTime?) {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private var eventID : Int ?= null
    private var title : String ?= title
    private var summary: String ?= null
    private var priority: Integer ?= null
    private var fixedEvent : Boolean ?= null

}
package com.teamcaffeine.koja.entity

import jakarta.persistence.*
import java.time.LocalTime


@Entity
@Table(name = "time_boundaries")
class TimeBoundary (    private var name: String ?=null,
        private var startTime: String ?= null,
        private var endTime: String ?= null) {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private var id: Int? = null

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id")
    var user: User? = null




    fun getName(): String? {
        return name
    }

    fun getStartTime(): String? {
        return startTime
    }

    fun getEndTime(): String? {
        return endTime
    }

}
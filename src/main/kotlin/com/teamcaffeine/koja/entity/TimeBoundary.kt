package com.teamcaffeine.koja.entity

import jakarta.persistence.*
import java.time.LocalTime


@Entity
@Table(name = "time_boundaries")
class TimeBoundary {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private var id: Int? = null

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id")
    var user: User? = null

    private var name: String ?=null
    private var startTime: LocalTime ?= null
    private var endTime: LocalTime ?= null

}
package com.teamcaffeine.koja.entity

import com.google.gson.annotations.Expose
import com.teamcaffeine.koja.enums.TimeBoundaryType
import jakarta.persistence.Entity
import jakarta.persistence.FetchType
import jakarta.persistence.GeneratedValue
import jakarta.persistence.GenerationType
import jakarta.persistence.Id
import jakarta.persistence.ManyToOne
import jakarta.persistence.Table
@Entity
@Table(name = "time_boundaries")
class TimeBoundary(
    @Expose private var name: String ? = null,
    @Expose private var startTime: String ? = null,
    @Expose private var endTime: String ? = null,
    @Expose private var type: TimeBoundaryType = TimeBoundaryType.ALLOWED,
) {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private var id: Int? = null

    @ManyToOne(fetch = FetchType.LAZY)
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

    fun setName(name: String?) {
        this.name = name
    }

    fun setStartTime(startTime: String?) {
        this.startTime = startTime
    }

    fun setEndTime(endTime: String?) {
        this.endTime = endTime
    }

    fun getType(): TimeBoundaryType? {
        return type
    }

    fun setType(type: TimeBoundaryType?) {
        if (type != null) {
            this.type = type
        }
    }
}



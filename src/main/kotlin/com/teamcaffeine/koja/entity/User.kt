package com.teamcaffeine.koja.entity

import jakarta.persistence.Entity
import jakarta.persistence.Id
import jakarta.persistence.Table
import java.time.LocalDateTime
import java.util.*

@Entity
data class User(@Id private val userID : String?, private var userEmail : String,
                private var startactiveTime : LocalDateTime,
                private var endactiveTime : LocalDateTime,
                private var locations : String, private var calendar: Calendar) {
    fun setUserEmail(email : String){
        this.userEmail = email
    }
    fun setStartTime(start : LocalDateTime){
        this.startactiveTime = start
    }

    fun setEndTime(end : LocalDateTime){
        this.endactiveTime = end
    }

    fun setLocatons(loc : String){
        this.locations = loc
    }

    fun setCalendar(calendar: Calendar){
        this.calendar = calendar
    }
}
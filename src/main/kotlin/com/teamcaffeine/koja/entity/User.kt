package com.teamcaffeine.koja.entity

import jakarta.persistence.Entity
import jakarta.persistence.Id
import jakarta.persistence.Table
import java.time.LocalDateTime
import java.util.*

@Entity
data class User(@Id private val userID : String?, private val userEmail : String,
                private val startactiveTime : LocalDateTime,
                private val endactiveTime : LocalDateTime,
                private val locations : String, private val calendar: Calendar) {
}
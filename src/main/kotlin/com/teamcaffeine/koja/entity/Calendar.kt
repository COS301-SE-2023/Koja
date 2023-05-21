package com.teamcaffeine.koja.entity

import com.teamcaffeine.koja.enums.Months
import jakarta.persistence.Entity
import jakarta.persistence.GeneratedValue
import jakarta.persistence.GenerationType
import jakarta.persistence.Id
import jakarta.persistence.Table

@Entity
@Table(name= "calendars")
class Calendar() {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    val id: Int? = null;
    var month: Months? = null;


    var calendar: List<Event>? = null;
}
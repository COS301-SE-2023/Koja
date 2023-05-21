package com.teamcaffeine.koja.entity

import jakarta.persistence.Entity
import jakarta.persistence.Table

@Entity
@Table(name = "users")
class User(private var authToken: String ) {
    private var slotGroups: List<TimeSlot>? = null
    private var email: String? = null
    private var locations: List<String>? = null
    private var calendar: Calendar? = null

fun getAuthToken(): String{
    return authToken;
}

}
package com.teamcaffeine.koja.entity

import jakarta.persistence.Entity
import jakarta.persistence.Id

@Entity
data class User(@Id val userID : String?,val userName : String) {
}
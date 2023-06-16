package com.teamcaffeine.koja.entity

import com.teamcaffeine.koja.enums.AuthProviderEnum
import jakarta.persistence.*

@Entity
@Table(name = "user_account")
class UserAccount() {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private val id: Int? = null
    var email : String = ""
    var refreshToken : String = ""
    var authProvider : AuthProviderEnum = AuthProviderEnum.NONE
    var userID : Int = Int.MAX_VALUE

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id")
    var user: User? = null
}
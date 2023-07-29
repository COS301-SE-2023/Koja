package com.teamcaffeine.koja.repository

import com.teamcaffeine.koja.entity.UserAccount
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository

@Repository
interface
UserAccountRepository : JpaRepository<UserAccount, Int> {
    fun findByEmail(email: String): UserAccount?
    fun findByUserID(userId: Int): List<UserAccount>
    override fun findAll(): List<UserAccount>
}

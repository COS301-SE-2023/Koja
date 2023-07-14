package com.teamcaffeine.koja.repository

import com.teamcaffeine.koja.entity.User
import com.teamcaffeine.koja.entity.UserAccount
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository

@Repository
interface UserRepository : JpaRepository<User, Int> {
    fun findByUserID(userId: Int): User?
}

package com.teamcaffeine.koja.repository

import com.teamcaffeine.koja.entity.User
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository
import java.util.Optional

@Repository
interface UserRepository : JpaRepository<User, Int> {
    override fun findById(id: Int): Optional<User>
    fun findById(id: Int?): Optional<User>
}

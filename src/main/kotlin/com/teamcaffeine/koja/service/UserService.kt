package com.teamcaffeine.koja.service

import com.teamcaffeine.koja.entity.User
import com.teamcaffeine.koja.repository.UserRepository
import org.springframework.jdbc.core.JdbcTemplate
import org.springframework.stereotype.Service
import java.util.*

@Service
class UserService(val db : UserRepository) {
    fun retriveUsers() : List<User>{
        return db.findAll().toList()
    }

    fun saveUser(user : User){
        db.save(user)
    }

    fun <T : Any> Optional<out T>.toList(): List<T> =
        if (isPresent) listOf(get()) else emptyList()
}
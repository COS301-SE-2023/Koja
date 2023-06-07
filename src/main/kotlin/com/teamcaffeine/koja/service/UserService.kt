package com.teamcaffeine.koja.service

import com.teamcaffeine.koja.entity.User
import com.teamcaffeine.koja.repository.UserRepository
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Service
import java.util.*

@Service
class UserService (){
    @Autowired
    private lateinit var userRepository: UserRepository

    fun retrieveUsers() : List<User>{
        return userRepository.findAll().toList()
    }

    fun saveUser(user : User){
        userRepository.save(user)
    }

    fun <T : Any> Optional<out T>.toList(): List<T> =
        if (isPresent) listOf(get()) else emptyList()


    fun getByUserId(id: String): User{
        return userRepository.findById(id);
    }

    fun authenticate(user : User): Boolean{
       val authenticatedUser= userRepository.findByAuthToken(user.getAuthToken());
        if(user == null)
            return false;
        return true;
    }

}
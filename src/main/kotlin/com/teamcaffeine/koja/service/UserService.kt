package com.teamcaffeine.koja.service

import com.teamcaffeine.koja.entity.User
import com.teamcaffeine.koja.repository.UserRepository
import org.springframework.stereotype.Service

@Service
class UserService (val userRepository: UserRepository){




    fun authenticate(user : User): Boolean{
       val authenticatedUser= userRepository.findByAuthToken(user.getAuthToken());
        if(user == null)
            return false;
        return true;
    }

}
package com.teamcaffeine.koja.repository

import com.teamcaffeine.koja.entity.User
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository

@Repository
<<<<<<< HEAD
interface UserRepository: JpaRepository<User, Integer> {

public fun findByAuthToken( authToken:String): User;

}
=======
interface UserRepository : JpaRepository<User, Int>
>>>>>>> d075a8edfcf0503bd2778e6b3d7b1d8fba6186f9

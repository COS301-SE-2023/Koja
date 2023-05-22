package com.teamcaffeine.koja.controller

import com.teamcaffeine.koja.entity.User
import com.teamcaffeine.koja.service.UserService
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RestController

@RestController
class UserController(val service: UserService) {
    @GetMapping("/users")
    fun allUsers() : List<User>{
        return service.retriveUsers()
    }

    @PostMapping("/addUser")
    fun post(@RequestBody user: User) {
        service.saveUser(user)
    }

}
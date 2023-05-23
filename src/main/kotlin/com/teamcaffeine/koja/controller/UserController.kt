package com.teamcaffeine.koja.controller

import com.teamcaffeine.koja.entity.User
import com.teamcaffeine.koja.service.UserService
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.CrossOrigin
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RestController
import java.math.BigInteger
import java.security.SecureRandom

data class Session(val OAuth: Any)

@RestController
class UserController(val userService: UserService) {

    @GetMapping("/users")
    fun allUsers() : List<User>{
        return service.retriveUsers()
    }

    @PostMapping("/addUser")
    fun post(@RequestBody user: User) {
        service.saveUser(user)
    }

    @PostMapping("/authenticate")
    fun authenticateUser(user: User): String {
        if(userService.authenticate(user)){
            return "homepage"
        } else {
            return "signin"
        }
    }

    fun generateRandomToken(length: Int): String {
        val secureRandom = SecureRandom()
        val token = BigInteger(130, secureRandom).toString(32)
        return token.toString()
    }

    @CrossOrigin(origins = ["*"])
    @PostMapping("/establishSession")
    fun establishSession(@RequestBody session : Session) : ResponseEntity<String> {
        println("Received address: $session")
        return ResponseEntity.ok("Data received successfully, $session")
    }
}

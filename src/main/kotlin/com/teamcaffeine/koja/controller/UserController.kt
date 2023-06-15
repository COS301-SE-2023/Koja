package com.teamcaffeine.koja.controller

import com.teamcaffeine.koja.entity.User
import com.teamcaffeine.koja.service.UserService
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*
import java.math.BigInteger
import java.security.SecureRandom

data class Session(val OAuth: Any)

@RestController
@RequestMapping("/api/v1/user")
class UserController(val userService: UserService) {

    @PostMapping("/authenticate")
    fun authenticateUser(user: User): String {
        return if(userService.authenticate(user)){
            "homepage"
        } else {
            "signin"
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

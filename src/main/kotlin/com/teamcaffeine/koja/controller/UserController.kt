package com.teamcaffeine.koja.controller

import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.RestController
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.CrossOrigin
import org.springframework.web.bind.annotation.RequestBody
import java.math.BigInteger
import java.security.SecureRandom

data class Session(val OAuth: Any)

@RestController
@RequestMapping("/api/v1/user")
class UserController() {

//    @PostMapping("/authenticate")
//    fun authenticateUser(user: User): String {
//        return if(userService.authenticate(user)){
//            "homepage"
//        } else {
//            "signin"
//        }
//    }

    fun generateRandomToken(length: Int): String {
        val secureRandom = SecureRandom()
        val token = BigInteger(130, secureRandom).toString(32)
        return token.toString()
    }

    @CrossOrigin(origins = ["*"])
    @PostMapping("/establishSession")
    fun establishSession(@RequestBody session: Session): ResponseEntity<String> {
        println("Received address: $session")
        return ResponseEntity.ok("Data received successfully, $session")
    }
}

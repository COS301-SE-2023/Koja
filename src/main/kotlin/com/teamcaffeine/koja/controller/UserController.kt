package com.teamcaffeine.koja.controller
import com.teamcaffeine.koja.entity.User
import com.teamcaffeine.koja.service.UserService
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RestController
import java.math.BigInteger
import java.security.SecureRandom;
import java.util.Base64;


@RestController
class UserController(val userService: UserService) {

    @PostMapping("/authenticate")
   fun  authenticateUser(user: User): String{

    if(userService.authenticate(user)){
        return "homepage";
    }
        else
            return "signin";
   }

    fun generateRandomToken(length: Int): String {
        val secureRandom = SecureRandom()
        val token = BigInteger(130, secureRandom).toString(32)
        return token.toString()
    }
}
package com.teamcaffeine.koja.controller
import com.teamcaffeine.koja.entity.User
import com.teamcaffeine.koja.service.UserService
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RestController
import java.security.SecureRandom;
import java.util.Base64;


@RestController
class UserController(val userService: UserService) {

    @PostMapping("/authenticate")
   fun  authenticateUser(user: User): User{

    if(userService.authenticate(user)){
        return "homepage";
    }
        else
            return "signin";
   }

    public  String generateToken(int length)
    SecureRandom random = new SecureRandom();
    byte[] bytes = new byte[length];
    random.nextBytes(bytes);
    return Base64.getUrlEncoder().withoutPadding().encodeToString(bytes);
}
package com.teamcaffeine.koja.controller
import java.security.SecureRandom;
import java.util.Base64;


@RestController
class UserController {

    @Autowired
    UserService userService;
    @PostRequest('/authenticate')
    User authenticateUser(User user){

    String oAuth= user.getOAuth();


    }

    public  String generateToken(int length)
    SecureRandom random = new SecureRandom();
    byte[] bytes = new byte[length];
    random.nextBytes(bytes);
    return Base64.getUrlEncoder().withoutPadding().encodeToString(bytes);
}
package com.teamcaffeine.koja.service

class UserService {

    @Autowired
    UserRepository userRepository;


    boolean authenticate(User user){
        String oAuth = user.getOAuth();
    }

}
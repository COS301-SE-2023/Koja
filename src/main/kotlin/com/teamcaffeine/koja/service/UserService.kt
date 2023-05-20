package com.teamcaffeine.koja.service

class UserService {

    @Autowired
    UserRepository userRepository;


    boolean authenticate(User user){
       User authenticatedUser = userRepository.findByAuthToken(user.getAuthToken());
        if(user == null)
            return false;
        return true;
    }

}
package com.teamcaffeine.koja.repository

import com.teamcaffeine.koja.entity.User
import org.springframework.stereotype.Repository

@Repository
public interface UserRepository extends JpaRepository<Project,Integer>{

public fun findByAuthToken(String authToken): User;

}
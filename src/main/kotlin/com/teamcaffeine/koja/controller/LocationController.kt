package com.teamcaffeine.koja.controller

import com.teamcaffeine.koja.entity.User
import com.teamcaffeine.koja.repository.UserRepository
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.PutMapping
import org.springframework.web.bind.annotation.RequestParam
import org.springframework.web.bind.annotation.RestController

@RestController
internal class LocationController {

    @Autowired
    private lateinit var userRepository:UserRepository;
    @PutMapping("/{userId}/place")
    fun updateUserPlace(
        @PathVariable("userId") userId: String?,
        @RequestParam("placeId") placeId: String?
    ): ResponseEntity<String> {
        val user: User = userRepository.findByUserId(userId)
            ?: return ResponseEntity.notFound().build()
        user.setPlaceId(placeId)
        userRepository.save(user)
        return ResponseEntity.ok("User place updated successfully.")
    }
}
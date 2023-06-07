package com.teamcaffeine.koja.controller

import com.teamcaffeine.koja.entity.User
import com.teamcaffeine.koja.repository.UserRepository
import com.teamcaffeine.koja.service.UserService
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.PutMapping
import org.springframework.web.bind.annotation.RequestParam
import org.springframework.web.bind.annotation.RestController

@RestController
internal class LocationController {

    @Autowired
    private lateinit var userService: UserService;
    @PostMapping("/{userId}/homeLocation")
    fun updateUserHomeLocation( @PathVariable("userId") userId: String?,
                                @RequestParam("placeId") placeId: String?
    ): ResponseEntity<String> {
        val user: User = userId?.let { userService.getByUserId(it) }
            ?: return ResponseEntity.notFound().build()
        placeId?.let { user.setHomeLocation(it) }
        userService.saveUser(user)
        return ResponseEntity.ok("User place updated successfully.")
    }

    @PostMapping("/{userId}/homeLocation")
    fun updateUserWorkLocation( @PathVariable("userId") userId: String?,
                                @RequestParam("placeId") placeId: String?
    ): ResponseEntity<String> {
        val user: User = userId?.let { userService.getByUserId(it) }
            ?: return ResponseEntity.notFound().build()
        placeId?.let { user.setWorkLocation(it) }
        userService.saveUser(user)
        return ResponseEntity.ok("User place updated successfully.")
    }
}
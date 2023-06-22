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
import com.google.maps.DistanceMatrixApi
import com.google.maps.GeoApiContext
import com.google.maps.model.DistanceMatrix
import com.google.maps.model.TravelMode
@RestController
internal class
LocationController {

    @Autowired
    private lateinit var userService: UserService;
    @PostMapping("/HLocationU/{userId}")
    fun updateUserHomeLocation(  @PathVariable("userId") userId: String?,
                                @RequestParam("placeId") placeId: String?
    ): ResponseEntity<String> {
        val user: User = userId?.let { userService.getByUserId(it) }
            ?: return ResponseEntity.notFound().build()
        placeId?.let { user.setHomeLocation(it) }
        userService.saveUser(user)
        return ResponseEntity.ok("User place updated successfully.")
    }

    @PostMapping("/HLocationD/{userId}")
    fun deleteUserHomeLocation( @RequestParam @PathVariable("userId") userId: String?
    ): ResponseEntity<String> {
        val user: User = userId?.let { userService.getByUserId(it) }
            ?: return ResponseEntity.notFound().build()
       user.setHomeLocation("")
        userService.saveUser(user)
        return ResponseEntity.ok("User place updated successfully.")
    }

    @PostMapping("/WLocationD/{userId}")
    fun deleteUserWorkLocation(  @PathVariable("userId") userId: String?
    ): ResponseEntity<String> {
        val user: User = userId?.let { userService.getByUserId(it) }
            ?: return ResponseEntity.notFound().build()
        user.setWorkLocation("")
        userService.saveUser(user)
        return ResponseEntity.ok("User place updated successfully.")
    }
    @PostMapping("/WLocationU/{userId}")
    fun updateUserWorkLocation( @PathVariable("userId") userId: String?,
                                @RequestParam("placeId") placeId: String?
    ): ResponseEntity<String> {
        val user: User = userId?.let { userService.getByUserId(it) }
            ?: return ResponseEntity.notFound().build()
        placeId?.let { user.setWorkLocation(it) }
        userService.saveUser(user)
        return ResponseEntity.ok("User place updated successfully.")
    }


    @PostMapping("/distance")
    fun getDistanceBetweenLocations( @PathVariable("origin") origin: String?,
                                @PathVariable("destination") destination: String?){

        val distance = getDistance(origin, destination)
        println("Distance between $origin and $destination: $distance")
    }







    fun getDistance(origin: String?, destination: String?): String? {
        val apiKey = "AIzaSyBF6_0K6jL6q0hp7izxP_GKLffm0NHfK0o" // Replace with your actual API key


        val context = GeoApiContext.Builder()
            .apiKey(apiKey)
            .build()

        val result: DistanceMatrix = DistanceMatrixApi.newRequest(context)
            .origins(origin)
            .destinations(destination)
            .mode(TravelMode.DRIVING) // You can change the travel mode as needed
            .await()

        return result.rows[0].elements[0].distance.humanReadable
    }
}


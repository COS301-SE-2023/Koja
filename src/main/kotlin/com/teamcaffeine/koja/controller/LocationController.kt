package com.teamcaffeine.koja.controller

import com.google.maps.DistanceMatrixApi
import com.google.maps.GeoApiContext
import com.google.maps.model.DistanceMatrix
import com.google.maps.model.TravelMode
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RequestParam
import org.springframework.web.bind.annotation.RestController

@RestController
@RequestMapping("/api/v1/location")
internal class
LocationController {

//    @PostMapping("/HomeLocationUpdater/{userId}")
//    fun updateUserHomeLocation(  @PathVariable("userId") userId: String?, @RequestParam("placeId") placeId: String?): ResponseEntity<String> {
//        val user: User = userId?.let { userService.getByUserId(it) }
//            ?: return ResponseEntity.notFound().build()
//        placeId?.let { user.setHomeLocation(it) }
//        userService.saveUser(user)
//        return ResponseEntity.ok("User place updated successfully.")
//    }
//
//    @PostMapping("/HomeLocationDel/{userId}")
//    fun deleteUserHomeLocation( @RequestParam @PathVariable("userId") userId: String?
//    ): ResponseEntity<String> {
//        val user: User = userId?.let { userService.getByUserId(it) }
//            ?: return ResponseEntity.notFound().build()
//       user.setHomeLocation("")
//        userService.saveUser(user)
//        return ResponseEntity.ok("User place updated successfully.")
//    }
//
//    @PostMapping("/WorkLocationDel/{userId}")
//    fun deleteUserWorkLocation(  @PathVariable("userId") userId: String?
//    ): ResponseEntity<String> {
//        val user: User = userId?.let { userService.getByUserId(it) }
//            ?: return ResponseEntity.notFound().build()
//        user.setWorkLocation("")
//        userService.saveUser(user)
//        return ResponseEntity.ok("User place updated successfully.")
//    }
//    @PostMapping("/WorkLocationUpdater/{userId}")
//    fun updateUserWorkLocation( @PathVariable("userId") userId: String?,
//                                @RequestParam("placeId") placeId: String?
//    ): ResponseEntity<String> {
//        val user: User = userId?.let { userService.getByUserId(it) }
//            ?: return ResponseEntity.notFound().build()
//        placeId?.let { user.setWorkLocation(it) }
//        userService.saveUser(user)
//        return ResponseEntity.ok("User place updated successfully.")
//    }

    @GetMapping("/distance")
    fun getDistanceBetweenLocations(@RequestParam("origin") origin: String?, @RequestParam("destination") destination: String?): ResponseEntity<String> {
        val distance = getDistance(origin, destination)
        return ResponseEntity.ok(distance)
    }

    fun getDistance(origin: String?, destination: String?): String? {
        val context = GeoApiContext.Builder()
            .apiKey(System.getProperty("API_KEY"))
            .build()

        val result: DistanceMatrix = DistanceMatrixApi.newRequest(context)
            .origins(origin)
            .destinations(destination)
            .mode(TravelMode.DRIVING) // You can change the travel mode as needed
            .await()

        return result.rows[0].elements[0].distance.humanReadable
    }

    @GetMapping("/travel-time")
    fun getLocationsTravelTime(
        @RequestParam("placeId") placeId: String?,
        @RequestParam("destLat") destLat: String?,
        @RequestParam("destLng") destLng: String?
    ): ResponseEntity<Long> {

        return if (placeId != null && destLat != null && destLng != null) {
            try {
                val destLatDouble = destLat.toDouble()
                val destLngDouble = destLng.toDouble()
                val result = getTravelTime(placeId, destLatDouble, destLngDouble)
                ResponseEntity.ok().body(result ?: 0L)
            } catch (e: Exception) {
                print(e)
                ResponseEntity.badRequest().build()
            }
        } else
            ResponseEntity.badRequest().build()
    }

    fun getTravelTime(placeId: String, destLat: Double, destLng: Double): Long? {
        val context = GeoApiContext.Builder()
            .apiKey(System.getProperty("API_KEY"))
            .build()

        val result: DistanceMatrix = DistanceMatrixApi.newRequest(context)
            .origins("place_id:$placeId")
            .destinations(com.google.maps.model.LatLng(destLat, destLng))
            .mode(TravelMode.DRIVING)
            .await()

        return result.rows[0].elements[0].duration.inSeconds
    }

//    @GetMapping("/combinedDayDistance")
//    fun getDistances(
//        @RequestParam("origins") origins: List<String>,
//        @RequestParam("destinations") destinations: List<String>,
//    ): DistanceMatrix {
//        val context = GeoApiContext.Builder()
//            .apiKey(retrieveAPIKey())
//            .build()
//
//        return DistanceMatrixApi.newRequest(context)
//            .origins(*origins.toTypedArray())
//            .destinations(*destinations.toTypedArray())
//            .mode(TravelMode.DRIVING) // You can change the travel mode as needed
//            .await()
//    }
//
//    fun retrieveAPIKey() : String?{
//        val jsonFile = File("koja/config.json")
//        val objectMapper = ObjectMapper()
//        var fieldValue: JsonNode? = null
//        try {
//            val jsonNode: JsonNode = objectMapper.readTree(jsonFile)
//            fieldValue = jsonNode.get("apiKey")
//        } catch (e: IOException) {
//            e.printStackTrace()
//        }
//        return fieldValue?.asText()
//    }
//
//    // The distance variable to update, for all collective distance
//    private var distance = 0.0
//    fun startAutoUpdate( updateFunction: Runnable) {
//        val intervalInMinutes = 30
//        val timer = Timer()
//        val intervalInMillis = (intervalInMinutes * 60 * 1000).toLong() // Convert minutes to milliseconds
//        val task: TimerTask = object : TimerTask() {
//            override fun run() {
//                updateFunction.run() // Execute the update function
//            }
//        }
//        // Schedule the task to run at the specified interval
//        timer.scheduleAtFixedRate(task, 0, intervalInMillis)
//    }
//    fun updateDistance() {
//        val increment = 10.0 // Distance increment
//        distance += increment
//        println("Distance updated: $distance")
//    }

/*
    @GetMapping("/location")
    fun getLocation(): String? {
        val latitude = // Retrieve latitude from geolocation
        val longitude = // Retrieve longitude from geolocation

            return if (latitude != null && longitude != null) {
                val address = "$latitude,$longitude"
                return address;
            } else {
                null
            }
    }
*/
    /* val distanceUpdater = DistanceUpdater()
       val intervalInMinutes = 60 // Update distance every 60 minutes
       // Start auto-updating the distance every specified interval
       distanceUpdater.startAutoUpdate(intervalInMinutes, distanceUpdater::updateDistance)*/
}

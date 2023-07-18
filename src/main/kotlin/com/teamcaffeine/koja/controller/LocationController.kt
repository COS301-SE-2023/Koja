package com.teamcaffeine.koja.controller

import com.google.gson.Gson
import com.google.maps.DistanceMatrixApi
import com.google.maps.GeoApiContext
import com.google.maps.model.DistanceMatrix
import com.google.maps.model.TravelMode
import com.teamcaffeine.koja.constants.HeaderConstant
import com.teamcaffeine.koja.constants.ResponseConstant
import com.teamcaffeine.koja.service.LocationService
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RequestHeader
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RequestParam
import org.springframework.web.bind.annotation.RestController
import java.lang.NumberFormatException

@RestController
@RequestMapping("/api/v1/location")
internal class
LocationController(private val locationService: LocationService) {
    /*  @PostMapping("/HomeLocationDel/{userId}")
    fun deleteUserHomeLocation( @RequestParam @PathVariable("userId") userId: String?
    ): ResponseEntity<String> {
        val user: User = userId?.let { userService.getByUserId(it) }
            ?: return ResponseEntity.notFound().build()
       user.setHomeLocation("")
        userService.saveUser(user)
        return ResponseEntity.ok("User place updated successfully.")
    }

    @PostMapping("/WorkLocationDel/{userId}")
    fun deleteUserWorkLocation(  @PathVariable("userId") userId: String?
    ): ResponseEntity<String> {
        val user: User = userId?.let { userService.getByUserId(it) }
            ?: return ResponseEntity.notFound().build()
        user.setWorkLocation("")
        userService.saveUser(user)
        return ResponseEntity.ok("User place updated successfully.")
    }*/

    @PostMapping("/HomeLocationUpdater")
    fun updateUserHomeLocation(@RequestHeader(HeaderConstant.AUTHORISATION) token: String?, @RequestParam("placeId") placeId: String?): ResponseEntity<out Any> {
        return if (token == null) {
            ResponseEntity.badRequest().body(ResponseConstant.REQUIRED_PARAMETERS_NOT_SET)
        } else {
            ResponseEntity.ok(locationService.setHomeLocation(token, placeId))
        }
    }

    @PostMapping("/WorkLocationUpdater")
    fun updateUserWorkLocation(@RequestHeader(HeaderConstant.AUTHORISATION) token: String?, @RequestParam("placeId") placeId: String?): ResponseEntity<out Any> {
        return if (token == null) {
            ResponseEntity.badRequest().body(ResponseConstant.REQUIRED_PARAMETERS_NOT_SET)
        } else {
            try {
                ResponseEntity.ok(locationService.setWorkLocation(token, placeId))
            } catch (e: Exception) {
                ResponseEntity.badRequest().body(ResponseConstant.INVALID_PARAMETERS)
            } catch (e: Exception) {
                ResponseEntity.badRequest().body(ResponseConstant.GENERIC_INTERNAL_ERROR)
            }
        }
    }

    @GetMapping("/distance")
    fun getDistanceBetweenLocations(@RequestHeader(HeaderConstant.AUTHORISATION) token: String?, @RequestParam("origin") origin: String?, @RequestParam("destination") destination: String?): ResponseEntity<String> {
        if (token == null || origin == null || destination == null || origin.isEmpty() || destination.isEmpty()) {
            return ResponseEntity.badRequest().body(ResponseConstant.REQUIRED_PARAMETERS_NOT_SET)
        }

        val distance = getDistance(origin, destination)
        return ResponseEntity.ok(distance)
    }

    @GetMapping("/listOfLocationTravelTime")
    fun getTravelTimeBetweenLocations(
        @RequestHeader(HeaderConstant.AUTHORISATION) token: String?,
        @RequestParam("originLat") originLat: String?,
        @RequestParam("originLng") originLng: String?,
    ): ResponseEntity<out Any> {
        if (token == null || originLng == null || originLat == null) {
            return ResponseEntity.badRequest().body(ResponseConstant.REQUIRED_PARAMETERS_NOT_SET)
        } else {
            val originLatDouble = originLat.toDouble()
            val originLngDouble = originLng.toDouble()
            val gson = Gson()
            var travelTimeList = locationService.getLocationTravelTimes(token, originLatDouble, originLngDouble)

            if (!travelTimeList.isEmpty()) {
                val travelTimeListJson = gson.toJson(travelTimeList)
                return ResponseEntity.ok(travelTimeListJson)
            } else {
                return ResponseEntity.ok("There are no future locations.")
            }
        }
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
        @RequestHeader(HeaderConstant.AUTHORISATION) token: String?,
        @RequestParam("placeId") placeId: String?,
        @RequestParam("destLat") destLat: String?,
        @RequestParam("destLng") destLng: String?,
    ): ResponseEntity<out Any> {
        return if (token == null || placeId == null || destLat == null || destLng == null) {
            ResponseEntity.badRequest().body(ResponseConstant.REQUIRED_PARAMETERS_NOT_SET)
        } else {
            try {
                val destLatDouble = destLat.toDouble()
                val destLngDouble = destLng.toDouble()
                val result = getTravelTime(placeId, destLatDouble, destLngDouble)
                ResponseEntity.ok().body(result ?: 0L)
            } catch (e: NumberFormatException) {
                ResponseEntity.badRequest().body(ResponseConstant.INVALID_PARAMETERS)
            } catch (e: Exception) {
                ResponseEntity.badRequest().body(ResponseConstant.GENERIC_INTERNAL_ERROR)
            }
        }
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

    @PostMapping("/updateLocation")
    fun updateCurrentUserLocation(
        @RequestHeader(HeaderConstant.AUTHORISATION) token: String?,
        @RequestParam("latitude") latitude: String,
        @RequestParam("longitude") longitude: String,
    ): ResponseEntity<out Any> {
        return if (token == null || latitude == null || longitude == null) {
            ResponseEntity.badRequest().body(ResponseConstant.REQUIRED_PARAMETERS_NOT_SET)
        } else {
            try {
                val destLatDouble = latitude.toDouble()
                val destLngDouble = longitude.toDouble()
                val gson = Gson()

                ResponseEntity.ok(gson.toJson(locationService.updateUserLocation(token, destLatDouble, destLngDouble)))
            } catch (e: Exception) {
                ResponseEntity.badRequest().body(ResponseConstant.INVALID_PARAMETERS)
            } catch (e: Exception) {
                ResponseEntity.badRequest().body(ResponseConstant.GENERIC_INTERNAL_ERROR)
            }
        }
    }

    @GetMapping("/savedLocations")
    fun getUserSavedLocations(@RequestHeader(HeaderConstant.AUTHORISATION) token: String?): ResponseEntity<out Any> {
        return if (token == null) {
            ResponseEntity.badRequest().body(ResponseConstant.REQUIRED_PARAMETERS_NOT_SET)
        } else {
            ResponseEntity.ok(locationService.getUserSavedLocations(token))
        }
    }
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

    /* val distanceUpdater = DistanceUpdater()
       val intervalInMinutes = 60 // Update distance every 60 minutes
       // Start auto-updating the distance every specified interval
       distanceUpdater.startAutoUpdate(intervalInMinutes, distanceUpdater::updateDistance)*/

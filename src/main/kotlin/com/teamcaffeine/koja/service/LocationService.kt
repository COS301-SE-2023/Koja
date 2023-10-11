package com.teamcaffeine.koja.service

import com.google.maps.DistanceMatrixApi
import com.google.maps.GeoApiContext
import com.google.maps.GeocodingApi
import com.google.maps.model.DistanceMatrix
import com.google.maps.model.GeocodingResult
import com.google.maps.model.TravelMode
import com.teamcaffeine.koja.controller.TokenManagerController
import com.teamcaffeine.koja.entity.User
import com.teamcaffeine.koja.repository.UserRepository
import jakarta.transaction.Transactional
import org.springframework.stereotype.Service

@Service
class LocationService(private val userRepository: UserRepository, private val googleCalendarAdapterService: GoogleCalendarAdapterService) {

    fun setHomeLocation(accessToken: String, homeLocation: String?) {
        val userJWTTokenData = TokenManagerController.getUserJWTTokenData(accessToken)
        val user = userRepository.findById(userJWTTokenData.userID)

        if (homeLocation != null && !user.isEmpty) {
            val retrievedUser = user.get()
            retrievedUser.setHomeLocation(homeLocation)
            userRepository.save(retrievedUser)
        } else {
            throw Exception("")
        }
    }

    fun setWorkLocation(accessToken: String, workLocation: String?) {
        val userJWTTokenData = TokenManagerController.getUserJWTTokenData(accessToken)
        val user = userRepository.findById(userJWTTokenData.userID)

        if (workLocation != null && !user.isEmpty) {
            val retrievedUser = user.get()
            retrievedUser.setWorkLocation(workLocation)
            userRepository.save(retrievedUser)
        } else {
            throw Exception("")
        }
    }

    fun getLocationTravelTimes(accessToken: String, originLat: Double, originLng: Double): List<Long?> {
        val locations = googleCalendarAdapterService.getFutureEventsLocations(accessToken)

        var travelTimes: MutableList<Long?> = mutableListOf()

        if (!locations.isEmpty()) {
            travelTimes.add(getTravelTime(originLat, originLng, locations.get(0)))
            for (i in 2..locations.size) {
                travelTimes.add(getTravelTime(locations.get(i), locations.get(i + 1)))
            }

            return travelTimes
        }

        return emptyList()
    }

    fun getTravelTime(originLat: Double, originLng: Double, placeId: String): Long? {
        val context = GeoApiContext.Builder()
            .apiKey(System.getProperty("GOOGLE_MAPS_API_KEY"))
            .build()

        val result: DistanceMatrix = DistanceMatrixApi.newRequest(context)
            .origins(com.google.maps.model.LatLng(originLat, originLng))
            .destinations("place_id:$placeId")
            .mode(TravelMode.DRIVING)
            .await()

        return try {
            result.rows[0].elements[0].duration.inSeconds
        } catch (e: Exception) {
            0L
        }
    }

    fun getTravelTime(placeIdOrigin: String, placeIdDestination: String): Long? {
        val context = GeoApiContext.Builder()
            .apiKey(System.getProperty("GOOGLE_MAPS_API_KEY"))
            .build()

        val result: DistanceMatrix = DistanceMatrixApi.newRequest(context)
            .origins("place_id:$placeIdOrigin")
            .destinations(placeIdDestination)
            .mode(TravelMode.DRIVING)
            .await()

        return result.rows[0].elements[0].duration.inSeconds
    }

    @Transactional
    fun updateUserLocation(token: String, latitude: Double, longitude: Double): DistanceMatrix? {
        try {
            val userJWTTokenData = TokenManagerController.getUserJWTTokenData(token)
            val retrievedUser = userRepository.findById(userJWTTokenData.userID).get()

            if (retrievedUser != null) {
                retrievedUser.setCurrentLocation(longitude, latitude)
                userRepository.save(retrievedUser)

                return updateLocationMatrix(longitude, latitude, retrievedUser, *googleCalendarAdapterService.getFutureEventsLocations(token).toTypedArray())
            }
        } catch (e: Exception) {
            // do nothing
        }
        return null
    }

    fun updateLocationMatrix(
        originLat: Double,
        originLng: Double,
        user: User,
        vararg futureEventsLocations: String,
    ): DistanceMatrix? {
        val context = GeoApiContext.Builder()
            .apiKey(System.getProperty("GOOGLE_MAPS_API_KEY"))
            .build()

        try {
            return DistanceMatrixApi.newRequest(context)
                .origins(com.google.maps.model.LatLng(originLat, originLng))
                .origins(user.getHomeLocation(), user.getWorkLocation())
                .destinations(*futureEventsLocations)
                .mode(TravelMode.DRIVING) // You can choose different travel modes (DRIVING, WALKING, BICYCLING, etc.)
                .await()
        } catch (e: Exception) {
            e.printStackTrace()
            return null
        }
    }

    fun getUserSavedLocations(token: String): MutableMap<String, Any> {
        val userJWTTokenData = TokenManagerController.getUserJWTTokenData(token)
        val retrievedUser = userRepository.findById(userJWTTokenData.userID).get()

        val currentLocation = retrievedUser.getCurrentLocation() ?: Pair(0.0, 0.0)

        val results = mutableMapOf<String, Any>()
        results["currentLocation"] = currentLocation
        results["homeLocation"] = retrievedUser.getHomeLocation() ?: ""
        results["workLocation"] = retrievedUser.getWorkLocation() ?: ""

        return results
    }

    fun getLocationCoordinates(placeId: String): Pair<Double, Double>? {
        val context = GeoApiContext.Builder()
            .apiKey(System.getProperty("GOOGLE_MAPS_API_KEY"))
            .build()

        val results: Array<GeocodingResult> = GeocodingApi.newRequest(context)
            .place(placeId)
            .await()

        return if (results.isNotEmpty()) {
            val location = results[0].geometry.location
            Pair(location.lat, location.lng)
        } else {
            null
        }
    }
}

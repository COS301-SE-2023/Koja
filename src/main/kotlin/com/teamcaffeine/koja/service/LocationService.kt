package com.teamcaffeine.koja.service

import com.google.maps.DistanceMatrixApi
import com.google.maps.GeoApiContext
import com.google.maps.model.DistanceMatrix
import com.google.maps.model.TravelMode
import com.teamcaffeine.koja.dto.JWTFunctionality
import com.teamcaffeine.koja.entity.User
import com.teamcaffeine.koja.repository.UserRepository
import net.minidev.json.JSONObject
import org.springframework.stereotype.Service

@Service
class LocationService(
    private var userRepository: UserRepository,
    private var googleCalendarAdapterService: GoogleCalendarAdapterService,
    private var jwtFunctionality: JWTFunctionality,
) {
    fun setHomeLocation(accessToken: String, homeLocation: String?): String? {
        val userJWTTokenData = jwtFunctionality.getUserJWTTokenData(accessToken)
        val user = userRepository.findById(userJWTTokenData.userID)

        if (homeLocation != null && !user.isEmpty) {
            val retrievedUser = user.get()
            retrievedUser.setHomeLocation(homeLocation)
            userRepository.save(retrievedUser)
            return retrievedUser.getHomeLocation()
        }
        return null
    }

    fun setWorkLocation(accessToken: String, workLocation: String?): String? {
        val userJWTTokenData = jwtFunctionality.getUserJWTTokenData(accessToken)

        val user = userRepository.findById(userJWTTokenData.userID)

        if (workLocation != null && !user.isEmpty) {
            val retrievedUser = user.get()
            retrievedUser.setWorkLocation(workLocation)
            userRepository.save(retrievedUser)
            return retrievedUser.getWorkLocation()
        }

        return null
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

        return emptyList<Long?>()
    }

    fun getTravelTime(originLat: Double, originLng: Double, placeId: String): Long? {
        val context = GeoApiContext.Builder()
            .apiKey(System.getProperty("API_KEY"))
            .build()

        val result: DistanceMatrix = DistanceMatrixApi.newRequest(context)
            .origins(com.google.maps.model.LatLng(originLat, originLng))
            .destinations("place_id:$placeId")
            .mode(TravelMode.DRIVING)
            .await()

        return result.rows[0].elements[0].duration.inSeconds
    }

    fun getTravelTime(placeIdOrigin: String, placeIdDestination: String): Long? {
        val context = GeoApiContext.Builder()
            .apiKey(System.getProperty("API_KEY"))
            .build()

        val result: DistanceMatrix = DistanceMatrixApi.newRequest(context)
            .origins("place_id:$placeIdOrigin")
            .destinations(placeIdDestination)
            .mode(TravelMode.DRIVING)
            .await()

        return result.rows[0].elements[0].duration.inSeconds
    }

    fun updateUserLocation(token: String, latitude: Double, longitude: Double): DistanceMatrix? {
        val userJWTTokenData = jwtFunctionality.getUserJWTTokenData(token)
        val retrievedUser = userRepository.findById(userJWTTokenData.userID).get()

        if (retrievedUser != null) {
            retrievedUser.setCurrentLocation(longitude, latitude)

            return updateLocationMatrix(longitude, latitude, retrievedUser, *googleCalendarAdapterService.getFutureEventsLocations(token).toTypedArray())
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
            .apiKey(System.getProperty("API_KEY"))
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

    fun getUserSavedLocations(token: String): JSONObject {
        val userJWTTokenData = jwtFunctionality.getUserJWTTokenData(token)
        val retrievedUser = userRepository.findById(userJWTTokenData.userID).get()
        if(retrievedUser!=null){
        val jsonObject = JSONObject()
        jsonObject.put("originLat", retrievedUser.getCurrentLocation()?.first ?: 0.0)
        jsonObject.put("originLng", retrievedUser.getCurrentLocation()?.second ?: 0.0)
        jsonObject.put("homeLocation", retrievedUser.getHomeLocation())
        jsonObject.put("workLocation", retrievedUser.getWorkLocation())

        return jsonObject
        }
        return JSONObject()
    }
}

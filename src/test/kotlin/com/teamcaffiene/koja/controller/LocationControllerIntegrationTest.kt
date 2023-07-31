package com.teamcaffiene.koja.service

import com.teamcaffeine.koja.controller.LocationController
import com.teamcaffeine.koja.dto.JWTFunctionality
import com.teamcaffeine.koja.repository.UserRepository
import com.teamcaffeine.koja.service.GoogleCalendarAdapterService
import com.teamcaffeine.koja.service.LocationService
import io.github.cdimascio.dotenv.Dotenv
import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.Test
import org.mockito.Mock
import org.mockito.MockitoAnnotations
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest
import org.springframework.boot.test.mock.mockito.MockBean
import org.springframework.http.MediaType
import org.springframework.test.context.ContextConfiguration
import org.springframework.test.web.servlet.MockMvc
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post
import org.springframework.test.web.servlet.result.MockMvcResultMatchers.status

@WebMvcTest(LocationController::class)
@ContextConfiguration(classes = [LocationService::class])
class LocationControllerIntegrationTest {
    private lateinit var dotenv: Dotenv

    @Mock
    private lateinit var jwtFunctionality: JWTFunctionality

    @Mock
    private lateinit var googleCalendarAdapterService: GoogleCalendarAdapterService

    @Mock
    private lateinit var userRepository: UserRepository

    @MockBean
    private lateinit var locationService: LocationService

    @Autowired
    private lateinit var mockMvc: MockMvc

    @BeforeEach
    fun setup() {
        MockitoAnnotations.openMocks(this)
        importEnvironmentVariables()
        locationService = LocationService(userRepository, googleCalendarAdapterService, jwtFunctionality)
    }

    private fun importEnvironmentVariables() {
        dotenv = Dotenv.load()

        dotenv["KOJA_AWS_RDS_DATABASE_URL"]?.let { System.setProperty("KOJA_AWS_RDS_DATABASE_URL", it) }
        dotenv["KOJA_AWS_RDS_DATABASE_ADMIN_USERNAME"]?.let {
            System.setProperty(
                "KOJA_AWS_RDS_DATABASE_ADMIN_USERNAME",
                it,
            )
        }
        dotenv["KOJA_AWS_RDS_DATABASE_ADMIN_PASSWORD"]?.let {
            System.setProperty(
                "KOJA_AWS_RDS_DATABASE_ADMIN_PASSWORD",
                it,
            )
        }

        dotenv["GOOGLE_CLIENT_ID"]?.let { System.setProperty("GOOGLE_CLIENT_ID", it) }
        dotenv["GOOGLE_CLIENT_SECRET"]?.let { System.setProperty("GOOGLE_CLIENT_SECRET", it) }
        dotenv["API_KEY"]?.let { System.setProperty("API_KEY", it) }

        dotenv["KOJA_JWT_SECRET"]?.let { System.setProperty("KOJA_JWT_SECRET", it) }
    }

/*
    @Test
    fun testUpdateUserHomeLocationWithValidInput() {
        // Prepare test data
        val token = "your_valid_auth_token"
        val placeId = "your_valid_place_id"
        val expectedResponseBody = "Your expected response body here"
        // Perform the POST request
        mockMvc.perform(
            post("/api/v1/location/HomeLocationUpdater")
                .header("Authorization", "Bearer $token")
                .param("placeId", placeId)
                .contentType(MediaType.APPLICATION_JSON),
        )
            .andExpect(status().isOk)
            .andExpect(content().string(expectedResponseBody))
    }
*/
    @Test
    fun testUpdateUserHomeLocationWithInvalidToken() {
        // Prepare test data
        val token = null // or any invalid token value
        val placeId = "your_valid_place_id"

        // Perform the POST request
        mockMvc.perform(
            post("/api/v1/location/HomeLocationUpdater")
                .header("Authorization", "Bearer $token")
                .param("placeId", placeId)
                .contentType(MediaType.APPLICATION_JSON),
        )
            .andExpect(status().isForbidden)
    }

/*
    @Test
    fun testUpdateUserHomeLocationWithInvalidPlaceId() {
        // Prepare test data
        val token = "your_valid_auth_token"
        val placeId = null // or any invalid placeId value

        // Perform the POST request
        mockMvc.perform(
            post("/api/v1/location/HomeLocationUpdater")
                .header("Authorization", "Bearer $token")
                .param("placeId", placeId)
                .contentType(MediaType.APPLICATION_JSON),
        )
            .andExpect(status().isBadRequest)
    }
*/
    @Test
    fun testUpdateUserHomeLocationWithMissingParameters() {
        // Perform the POST request without providing any parameters
        mockMvc.perform(
            post("/api/v1/location/HomeLocationUpdater")
                .contentType(MediaType.APPLICATION_JSON),
        )
            .andExpect(status().isForbidden)
    }

    /* @Test
    fun testGetLocationTravelTimesWithSingleLocation() {
        // Given
        val originLat = 40.7128 // Example origin latitude
        val originLng = -74.0060 // Example origin longitude
        val mockUserID = Int.MAX_VALUE
        val userAccounts = mutableListOf<JWTAuthDetailsDTO>()
        val mockUserJWTData = UserJWTTokenDataDTO(userAccounts, mockUserID)
        val jwtToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJlbmNyeXB0ZWQiOiIrT09EZXlqWk1CWjV6b3I1OFRBdVZIT2x3akJvbHY1MGFkTjQ5ajdFMWMweW9TWW9zOTNHMUVWT0ord3Z2dGFLQ1RBbE43TzB1Z3crZm1JUmxGZ25jb3EyUHcxRHc2S2RQMVcydnRFWGdIMlFOTFRLSk1sTGkwOGsrWmtsbzRVM1pTcllJb3hzaFVvSk5YU1lnMmQ2K2tRWUpNUEt3MS9ndi9JWjA4U3BHWnpNM3lJaWFlQUt0UFgwZGVQWUlOSk1ZMm1iTlhnZVVIei9Bb3NtWUthNEY3MmlkSEgra0M4N2x6T1ROcU1mSnVCNHRadE40OVJCVlVxQ0JOQ3VrQzNjOUd6NHB3SHVkVVpnbjVnaXFPaXNDNCtSUXo3Uk9EN2I4R2YzdHpJMDZhR2ZURnZld05QSTFPT3JKb3JELzd2bDVHNEtScU1rZDFJaUlKNmd3SUFZanh5bHh2ck0vUHIvUngyWTdOcmRneTBHNHhXMGZjenkzUDhoQmhsYkNSOGFMVEdZdXF0dVdNOUNTMWJmY2hMS2E4UzBvR1pycVR0ak42QzdBOENEZVNHN29VR1ZKOUViSlBLaDVQMlpxVEpKWFlOYWVUclZEQkMxQkxPQ01JeE9QdU1DTWdreHczNWp2bFkyMmFDcUdFZHRJTy9UOXJIMjl4RWJHQUlXeUQvcjNTaW9KT1d2ZzJvd3B5NExKSitTZWVaVjU4UEtCL2wrVFZzTmZBRzB3Vlk2azMxNFk5R2xTbTROUVcyNFRyeDhja01FdHg1eFE1RHhBS0NOWnBXN2pnPT0iLCJleHAiOjE2ODk3MTY5MDR9.uctphVFxJICf8OexH0ZQHWONI3rTExoyDvdAlMdxMGUQaLjGmONyyt6sGP2wn2DUUtW9M1Mg-kbelZpU-zPgbQ"

        val testUser = User()
        val optionalUserValue = Optional.of(testUser)
        val locations = listOf<String>("ChIJezCDEUDYxh4R902OsdTdIKc")
        whenever(googleCalendarAdapterService.getFutureEventsLocations(jwtToken)).thenReturn(locations)

        // When
        val result = locationService.getLocationTravelTimes(jwtToken, originLat, originLng)

        // Then
        assertEquals(1, result.size)
        // Assert your expected travel time value for this single location
    }

    @Test
    fun testGetLocationTravelTimesWithMultipleLocations() {
        // Given
        val originLat = 40.7128 // Example origin latitude
        val originLng = -74.0060 // Example origin longitude
        val mockUserID = Int.MAX_VALUE
        val userAccounts = mutableListOf<JWTAuthDetailsDTO>()
        val mockUserJWTData = UserJWTTokenDataDTO(userAccounts, mockUserID)
        val jwtToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJlbmNyeXB0ZWQiOiIrT09EZXlqWk1CWjV6b3I1OFRBdVZIT2x3akJvbHY1MGFkTjQ5ajdFMWMweW9TWW9zOTNHMUVWT0ord3Z2dGFLQ1RBbE43TzB1Z3crZm1JUmxGZ25jb3EyUHcxRHc2S2RQMVcydnRFWGdIMlFOTFRLSk1sTGkwOGsrWmtsbzRVM1pTcllJb3hzaFVvSk5YU1lnMmQ2K2tRWUpNUEt3MS9ndi9JWjA4U3BHWnpNM3lJaWFlQUt0UFgwZGVQWUlOSk1ZMm1iTlhnZVVIei9Bb3NtWUthNEY3MmlkSEgra0M4N2x6T1ROcU1mSnVCNHRadE40OVJCVlVxQ0JOQ3VrQzNjOUd6NHB3SHVkVVpnbjVnaXFPaXNDNCtSUXo3Uk9EN2I4R2YzdHpJMDZhR2ZURnZld05QSTFPT3JKb3JELzd2bDVHNEtScU1rZDFJaUlKNmd3SUFZanh5bHh2ck0vUHIvUngyWTdOcmRneTBHNHhXMGZjenkzUDhoQmhsYkNSOGFMVEdZdXF0dVdNOUNTMWJmY2hMS2E4UzBvR1pycVR0ak42QzdBOENEZVNHN29VR1ZKOUViSlBLaDVQMlpxVEpKWFlOYWVUclZEQkMxQkxPQ01JeE9QdU1DTWdreHczNWp2bFkyMmFDcUdFZHRJTy9UOXJIMjl4RWJHQUlXeUQvcjNTaW9KT1d2ZzJvd3B5NExKSitTZWVaVjU4UEtCL2wrVFZzTmZBRzB3Vlk2azMxNFk5R2xTbTROUVcyNFRyeDhja01FdHg1eFE1RHhBS0NOWnBXN2pnPT0iLCJleHAiOjE2ODk3MTY5MDR9.uctphVFxJICf8OexH0ZQHWONI3rTExoyDvdAlMdxMGUQaLjGmONyyt6sGP2wn2DUUtW9M1Mg-kbelZpU-zPgbQ"

        val testUser = User()
        val optionalUserValue = Optional.of(testUser)
        val locations = listOf<String>(
            "ChIJezCDEUDYxh4R902OsdTdIKc",
            "ChIJ4WEudAxglR4RmHDutMnSdZA",
            "ChIJvXv7qr-ZtSQRiWKVgeEJRUE",
        )
        whenever(googleCalendarAdapterService.getFutureEventsLocations(jwtToken)).thenReturn(locations)

        // When
        val result = locationService.getLocationTravelTimes(jwtToken, originLat, originLng)

        // Then
        assertEquals(locations.size, result.size)
    }
  @Test
    fun `getTravelTime should return correct travel time for given location`() {
        // Arrange
        val originLat = -24.3051431561 // Replace with your desired latitude for the origin
        val originLng = 29.4808439319 // Replace with your desired longitude for the origin
        val placeId = "Los Angeles, CA"
        val context = GeoApiContext.Builder()
            .apiKey(System.getProperty("API_KEY"))
            .build()

        // Act
        val result: DistanceMatrix = DistanceMatrixApi.newRequest(context)
            .origins(com.google.maps.model.LatLng(originLat, originLng))
            .destinations("place_id:$placeId")
            .mode(TravelMode.DRIVING)
            .await()

        val travelTimeInSeconds = result.rows[0].elements[0].duration?.inSeconds ?: 0
        // Assert
        // You can add additional assertions here based on the expected result
        // For example, you can check if travelTimeInSeconds is not null, or if the duration is reasonable for the given origin and destination.
        assertNotNull(travelTimeInSeconds)
        assertTrue(travelTimeInSeconds > 0)
    }*/
}

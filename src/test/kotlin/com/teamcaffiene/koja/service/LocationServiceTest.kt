package com.teamcaffiene.koja.service

import com.teamcaffeine.koja.KojaApplication
import com.teamcaffeine.koja.controller.TokenManagerController
import com.teamcaffeine.koja.dto.JWTAuthDetailsDTO
import com.teamcaffeine.koja.dto.JWTFunctionality
import com.teamcaffeine.koja.dto.UserJWTTokenDataDTO
import com.teamcaffeine.koja.entity.User
import com.teamcaffeine.koja.repository.UserRepository
import com.teamcaffeine.koja.service.GoogleCalendarAdapterService
import com.teamcaffeine.koja.service.LocationService
import com.teamcaffeine.koja.service.UserCalendarService
import io.github.cdimascio.dotenv.Dotenv
import org.junit.jupiter.api.Assertions
import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.Test
import org.mockito.Mock
import org.mockito.Mockito
import org.mockito.MockitoAnnotations
import org.mockito.invocation.InvocationOnMock
import org.mockito.kotlin.any
import org.mockito.kotlin.check
import org.mockito.kotlin.spy
import org.mockito.kotlin.whenever
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc
import org.springframework.boot.test.context.SpringBootTest
import org.springframework.test.context.ActiveProfiles
import org.springframework.test.context.junit.jupiter.SpringJUnitConfig
import java.util.Optional

@SpringJUnitConfig
@SpringBootTest(classes = [KojaApplication::class], webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
@AutoConfigureMockMvc
@ActiveProfiles("test")
class LocationServiceTest {

    @Mock
    lateinit var userRepository: UserRepository

    @Mock
    lateinit var googleCalendarAdapterService: GoogleCalendarAdapterService

    @Mock
    private lateinit var jwtFunctionality: JWTFunctionality


    private lateinit var locationService: LocationService
    private lateinit var dotenv: Dotenv

    @BeforeEach
    fun setup() {
        MockitoAnnotations.openMocks(this)

        importEnvironmentVariables()

        locationService = spy(LocationService(userRepository, googleCalendarAdapterService))
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

    @Test
    fun `addTimeBoundary should return true when the timeBoundary is valid and user exists`() {
        // Arrange
        val mockUserID = Int.MAX_VALUE
        val userAccounts = mutableListOf<JWTAuthDetailsDTO>()
        val mockUserJWTData = UserJWTTokenDataDTO(userAccounts, mockUserID)
        val jwtToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJlbmNyeXB0ZWQiOiIrT09EZXlqWk1CWjV6b3I1OFRBdVZIT2x3akJvbHY1MGFkTjQ5ajdFMWMweW9TWW9zOTNHMUVWT0ord3Z2dGFLQ1RBbE43TzB1Z3crZm1JUmxGZ25jb3EyUHcxRHc2S2RQMVcydnRFWGdIMlFOTFRLSk1sTGkwOGsrWmtsbzRVM1pTcllJb3hzaFVvSk5YU1lnMmQ2K2tRWUpNUEt3MS9ndi9JWjA4U3BHWnpNM3lJaWFlQUt0UFgwZGVQWUlOSk1ZMm1iTlhnZVVIei9Bb3NtWUthNEY3MmlkSEgra0M4N2x6T1ROcU1mSnVCNHRadE40OVJCVlVxQ0JOQ3VrQzNjOUd6NHB3SHVkVVpnbjVnaXFPaXNDNCtSUXo3Uk9EN2I4R2YzdHpJMDZhR2ZURnZld05QSTFPT3JKb3JELzd2bDVHNEtScU1rZDFJaUlKNmd3SUFZanh5bHh2ck0vUHIvUngyWTdOcmRneTBHNHhXMGZjenkzUDhoQmhsYkNSOGFMVEdZdXF0dVdNOUNTMWJmY2hMS2E4UzBvR1pycVR0ak42QzdBOENEZVNHN29VR1ZKOUViSlBLaDVQMlpxVEpKWFlOYWVUclZEQkMxQkxPQ01JeE9QdU1DTWdreHczNWp2bFkyMmFDcUdFZHRJTy9UOXJIMjl4RWJHQUlXeUQvcjNTaW9KT1d2ZzJvd3B5NExKSitTZWVaVjU4UEtCL2wrVFZzTmZBRzB3Vlk2azMxNFk5R2xTbTROUVcyNFRyeDhja01FdHg1eFE1RHhBS0NOWnBXN2pnPT0iLCJleHAiOjE2ODk3MTY5MDR9.uctphVFxJICf8OexH0ZQHWONI3rTExoyDvdAlMdxMGUQaLjGmONyyt6sGP2wn2DUUtW9M1Mg-kbelZpU-zPgbQ"

        val timeBoundary = TimeBoundary("Partying", "12:00", "05:00")
        val mockUser = User()
        val optionalUserValue = Optional.of(mockUser)

        whenever(jwtFunctionality.getUserJWTTokenData(jwtToken)).thenReturn(mockUserJWTData)
        whenever(userRepository.findById(mockUserID)).thenReturn(optionalUserValue)
        whenever(userRepository.save(any<User>())).thenAnswer { invocation: InvocationOnMock -> invocation.getArgument<User>(0) }

        // Act
        val result = userCalendarService.addTimeBoundary(jwtToken, timeBoundary)

        // Assert
        Assertions.assertTrue(result)

        // Verify that the time boundary is added to the user and saved in the repository
        Assertions.assertEquals(timeBoundary, mockUser.getUserTimeBoundaries()[0])

        // Verify that the user is saved in the repository
        Mockito.verify(userRepository).save(
            check<User> { savedUser ->
                Assertions.assertEquals(mockUser, savedUser)
                Assertions.assertEquals(timeBoundary, savedUser.getUserTimeBoundaries()[0])
            },
        )
    }
    fun setHomeLocation(accessToken: String, homeLocation: String?): String? {
        val userJWTTokenData = TokenManagerController.getUserJWTTokenData(accessToken)
        val user = userRepository.findById(userJWTTokenData.userID)

        if (homeLocation != null && !user.isEmpty) {
            val retrievedUser = user.get()
            retrievedUser.setHomeLocation(homeLocation)
            userRepository.save(retrievedUser)
            return retrievedUser.getHomeLocation()
        }

        return null
    }

    @Test
    fun `test setHomeLocation with valid input`() {
        val accessToken = "validAccessToken"
        val userID = 1L
        val homeLocation = "New York, USA"

        // Mock the behavior of the userRepository.findById method
        val user = User(userID, "John Doe", "john@example.com", null)
        `when`(userRepository.findById(userID)).thenReturn(user)

        val result = userCalendarService.setHomeLocation(accessToken, homeLocation)

        assertEquals(homeLocation, result)
        assertEquals(homeLocation, user.getHomeLocation())
    }

    @Test
    fun `test setHomeLocation with null homeLocation`() {
        val accessToken = "validAccessToken"
        val userID = 1L

        // Mock the behavior of the userRepository.findById method
        val user = User(userID, "John Doe", "john@example.com", "Previous Home")
        `when`(userRepository.findById(userID)).thenReturn(user)

        val result = userCalendarService.setHomeLocation(accessToken, null)

        assertEquals("Previous Home", result)
        assertEquals("Previous Home", user.getHomeLocation())
    }

    @Test
    fun `test setHomeLocation with invalid accessToken`() {
        val accessToken = "invalidAccessToken"
        val homeLocation = "New York, USA"

        // Mock the behavior of the TokenManagerController.getUserJWTTokenData method to return null
        `when`(TokenManagerController.getUserJWTTokenData(accessToken)).thenReturn(null)

        val result = userCalendarService.setHomeLocation(accessToken, homeLocation)

        assertEquals(null, result)
    }

    @Test
    fun `test setHomeLocation with invalid user`() {
        val accessToken = "validAccessToken"
        val userID = 1L
        val homeLocation = "New York, USA"

        // Mock the behavior of the userRepository.findById method to return empty optional
        `when`(userRepository.findById(userID)).thenReturn(empty())

        val result = userCalendarService.setHomeLocation(accessToken, homeLocation)

        assertEquals(null, result)
    }
}
}

package com.teamcaffiene.koja.service

import com.teamcaffeine.koja.controller.UserController
import com.teamcaffeine.koja.dto.JWTFunctionality
import com.teamcaffeine.koja.entity.TimeBoundary
import com.teamcaffeine.koja.entity.User
import com.teamcaffeine.koja.enums.TimeBoundaryType
import com.teamcaffeine.koja.repository.TimeBoundaryRepository
import com.teamcaffeine.koja.repository.UserAccountRepository
import com.teamcaffeine.koja.repository.UserRepository
import com.teamcaffeine.koja.service.UserCalendarService
import io.github.cdimascio.dotenv.Dotenv
import org.junit.jupiter.api.Assertions.assertFalse
import org.junit.jupiter.api.Assertions.assertNull
import org.junit.jupiter.api.Assertions.assertTrue
import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.Test
import org.mockito.Mock
import org.mockito.MockitoAnnotations
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.test.web.servlet.MockMvc
import org.springframework.test.web.servlet.setup.MockMvcBuilders.standaloneSetup

class UserCalendarServiceIntergrationTest {

    private lateinit var userController: UserController
    private lateinit var dotenv: Dotenv

    @Mock
    private lateinit var timeBoundaryRepository: TimeBoundaryRepository

    @Mock
    private lateinit var jwtFunctionality: JWTFunctionality

    @Mock
    private lateinit var userRepository: UserRepository

    @Mock
    private lateinit var userAccountRepository: UserAccountRepository

    @Autowired
    private lateinit var userCalendarService: UserCalendarService

    var mockMvc: MockMvc? = null

    @BeforeEach
    fun setup() {
        MockitoAnnotations.openMocks(this)
        importEnvironmentVariables()
        userCalendarService = UserCalendarService(userRepository, jwtFunctionality, userAccountRepository)
        mockMvc = standaloneSetup(userCalendarService).build()
        userController = UserController(userAccountRepository, userRepository, userCalendarService, timeBoundaryRepository)
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
    fun `test addTimeBoundary with valid time boundary`() {
        val token = "validToken"
        val userID = "user123"

        // Prepare the user data in the database for the given token
        val user = User(userID, "John Doe")
        userRepository.save(user)

        // Create a valid time boundary
        val timeBoundary = TimeBoundary("Office hours", "09:00", "17:00", TimeBoundaryType.ALLOWED)

        // Perform the function call
        val result = userCalendarService.addTimeBoundary(token, timeBoundary)

        // Optionally, verify the database state after adding the time boundary
        val retrievedUser = userRepository.findById(userID).orElse(null)
        assertNotNull(retrievedUser)
        assertTrue(result)
        assertTrue(retrievedUser.getTimeBoundaries().contains(timeBoundary))
    }*/

    @Test
    fun `test addTimeBoundary with invalid token`() {
        val token = "invalidToken"
        val userID = "789"

        // Perform the function call with an invalid token
        val result = userCalendarService.addTimeBoundary(token, TimeBoundary("Office hours", "09:00", "17:00", TimeBoundaryType.ALLOWED))

        // Ensure the function returns false since the token is invalid
        assertFalse(result)

        // Optionally, verify that the time boundary was not added to the user in the database
        val retrievedUser = userRepository.findById(userID.toInt()).orElse(null)
        assertNull(retrievedUser)
    }

    @Test
    fun `test removeTimeBoundary with invalid token`() {
        val token = "invalidToken"
        val userID = "789"

        // Perform the function call with an invalid token
        val result = userCalendarService.removeTimeBoundary(token, "Office hours")

        assertFalse(result)

        // Optionally, verify that the time boundary was not added to the user in the database
        val retrievedUser = userRepository.findById(userID.toInt()).orElse(null)
        assertNull(retrievedUser)
    }

    /*@Test
    fun `test getUserTimeBoundaries with valid token and time boundaries`() {
        val token = "validToken"
        val userID = "user123"

        // Prepare the user data in the database for the given token
        val user = User(userID, "John Doe")
        val timeBoundary1 = TimeBoundary("Office hours", "09:00", "17:00", TimeBoundaryType.ALLOWED)
        val timeBoundary2 = TimeBoundary("Lunch break", "12:00", "13:00", TimeBoundaryType.ALLOWED)
        user.addTimeBoundary(timeBoundary1)
        user.addTimeBoundary(timeBoundary2)
        userRepository.save(user)

        // Perform the function call with a valid token
        val timeBoundaries = userCalendarService.getUserTimeBoundaries(token)

        // Verify that the function returns the correct time boundaries
        assertEquals(2, timeBoundaries.size)
        assertTrue(timeBoundaries.contains(timeBoundary1))
        assertTrue(timeBoundaries.contains(timeBoundary2))
    }*/

    @Test
    fun `test getUserTimeBoundaries with valid token and no time boundaries`() {
        val token = "validToken"
        val userID = "user456"

        // Prepare the user data in the database for the given token
        val user = User()
        userRepository.save(user)

        // Perform the function call with a valid token and no time boundaries
        val timeBoundaries = userCalendarService.getUserTimeBoundaries(token)

        // Verify that the function returns an empty list
        assertTrue(timeBoundaries.isEmpty())
    }

    @Test
    fun `test getUserTimeBoundaries with invalid token`() {
        val token = "invalidToken"

        // Perform the function call with an invalid token
        val timeBoundaries = userCalendarService.getUserTimeBoundaries(token)

        // Verify that the function returns an empty list since the token is invalid
        assertTrue(timeBoundaries.isEmpty())
    }

   /* @Test
    fun `test getUserTimeBoundaryAndLocation with valid token and name`() {
        val token = "validToken"
        val userID = "user123"
        val name = "Work"

        // Prepare the user data in the database for the given token
        val user = User()
        user.setWorkLocation("WorkLocation")
        userRepository.save(user)

        // Add a time boundary with the given name
        val timeBoundary = TimeBoundary(name, "09:00", "17:00", TimeBoundaryType.ALLOWED)
        user.addTimeBoundary(timeBoundary)
        userRepository.save(user)

        // Perform the function call with a valid token and name
        val (resultTimeBoundary, resultLocation) = userCalendarService.getUserTimeBoundaryAndLocation(token, name)

        // Verify that the function returns the correct time boundary and location
        assertEquals(timeBoundary, resultTimeBoundary)
        assertEquals("WorkLocation", resultLocation)
    }
*/
    @Test
    fun `test getUserTimeBoundaryAndLocation with valid token and invalid name`() {
        val token = "validToken"
        val userID = "user456"
        val name = null

        // Prepare the user data in the database for the given token
        val user = User()
        userRepository.save(user)

        // Perform the function call with a valid token and invalid name
        val (resultTimeBoundary, resultLocation) = userCalendarService.getUserTimeBoundaryAndLocation(token, name)

        // Verify that the function returns null for both time boundary and location
        assertNull(resultTimeBoundary)
        assertNull(resultLocation)
    }

    @Test
    fun `test getUserTimeBoundaryAndLocation with invalid token`() {
        val token = "invalidToken"
        val name = "Work"

        // Perform the function call with an invalid token
        val (resultTimeBoundary, resultLocation) = userCalendarService.getUserTimeBoundaryAndLocation(token, name)

        // Verify that the function returns null for both time boundary and location
        assertNull(resultTimeBoundary)
        assertNull(resultLocation)
    }
}

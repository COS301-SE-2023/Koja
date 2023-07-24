package com.teamcaffiene.koja.service

import com.fasterxml.jackson.databind.ObjectMapper
import com.teamcaffeine.koja.KojaApplication
import com.teamcaffeine.koja.controller.TokenManagerController
import com.teamcaffeine.koja.entity.TimeBoundary
import com.teamcaffeine.koja.entity.User
import com.teamcaffeine.koja.repository.UserAccountRepository
import com.teamcaffeine.koja.repository.UserRepository
import com.teamcaffeine.koja.service.GoogleCalendarAdapterService
import com.teamcaffeine.koja.service.UserCalendarService
import io.github.cdimascio.dotenv.Dotenv
import io.mockk.mockk
import jakarta.transaction.Transactional
import org.junit.jupiter.api.Assertions
import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.extension.ExtendWith
import org.mockito.Mock
import org.mockito.Mockito
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.autoconfigure.jdbc.AutoConfigureTestDatabase
import org.springframework.boot.test.autoconfigure.json.AutoConfigureJsonTesters
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc
import org.springframework.boot.test.context.SpringBootTest
import org.springframework.boot.test.json.JacksonTester
import org.springframework.boot.test.mock.mockito.MockBean
import org.springframework.test.context.ActiveProfiles
import org.springframework.test.context.junit.jupiter.SpringExtension
import org.springframework.test.context.junit.jupiter.SpringJUnitConfig
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner
import org.springframework.test.web.servlet.MockMvc
import org.springframework.test.web.servlet.setup.MockMvcBuilders
import java.util.*

@SpringJUnitConfig
@SpringBootTest(classes = [KojaApplication::class], webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
@AutoConfigureMockMvc
@ActiveProfiles("test")
class UserCalendarServiceTest {

    @Mock
    lateinit var userRepository: UserRepository

    @Mock
    lateinit var userAccountRepository: UserAccountRepository

    private lateinit var service: GoogleCalendarAdapterService
    private lateinit var dotenv: Dotenv
    private lateinit var userCalendarService: UserCalendarService
    @BeforeEach
    fun setup() {
        val dotenv: Dotenv = Dotenv.load()

        System.setProperty("KOJA_AWS_RDS_DATABASE_URL", dotenv["KOJA_AWS_RDS_DATABASE_URL"]!!)
        System.setProperty("KOJA_AWS_RDS_DATABASE_ADMIN_USERNAME", dotenv["KOJA_AWS_RDS_DATABASE_ADMIN_USERNAME"]!!)
        System.setProperty("KOJA_AWS_RDS_DATABASE_ADMIN_PASSWORD", dotenv["KOJA_AWS_RDS_DATABASE_ADMIN_PASSWORD"]!!)

        // Set Google Sign In client ID and client secret properties
        System.setProperty("GOOGLE_CLIENT_ID", dotenv["GOOGLE_CLIENT_ID"]!!)
        System.setProperty("GOOGLE_CLIENT_SECRET", dotenv["GOOGLE_CLIENT_SECRET"]!!)
        System.setProperty("API_KEY", dotenv["API_KEY"]!!)

        // Set JWT secret key property
        System.setProperty("KOJA_JWT_SECRET", dotenv["KOJA_JWT_SECRET"]!!)
    }
    /*  @BeforeEach
    fun setup() {
        val dotenv: Dotenv = Dotenv.load()
        System.setProperty("KOJA_JWT_SECRET", dotenv["KOJA_JWT_SECRET"]!!)
        userRepository = mockk()
        userAccountRepository = mockk()
        userCalendarService = UserCalendarService(userRepository)
    }*/

//    @Test
//    fun getAllUserEvents_ReturnsEmptyList_WhenNoUserAccountsFound() {
//        // Arrange
//        val token = "***redacted***"
//        val userJWTTokenDataDTO = UserJWTTokenDataDTO(userID = 123, userAuthDetails = emptyList())
//        every { getUserJWTTokenData(token) } returns userJWTTokenDataDTO
//        every { userAccountRepository.findByUserID(userJWTTokenDataDTO.userID) } returns emptyList()
//
//        // Act
//        val result = userCalendarService.getAllUserEvents(token)
//
//        // Assert
//        assertEquals(emptyList<UserEventDTO>(), result)
//    }

//    @Test
//    fun getAllUserEvents_ReturnsUserEventsFromCalendarAdapters() {
//        val token = "***redacted***"
//        val userJWTTokenDataDTO = UserJWTTokenDataDTO(
//            userID = 123,
//            userAuthDetails = listOf(JWTGoogleDTO(token, "dummyRefresh", 1L))
//        )
//        val userAccount = listOf(UserAccount(123))
//        val calendarAdapterFactoryService = mockk<CalendarAdapterFactoryService>()
//        val calendarAdapterService = mockk<CalendarAdapterService>()
//        val userEvents = arrayListOf<UserEventDTO>()
//
//        every { getUserJWTTokenData(token) } returns userJWTTokenDataDTO
//        every { userAccountRepository.findByUserID(userJWTTokenDataDTO.userID) } returns userAccount
//        every { userCalendarService.getAllUserEvents(token) } returns userEvents
//        every { calendarAdapterFactoryService.createCalendarAdapter(any()) } returns calendarAdapterService
//
//        val result = userCalendarService.getAllUserEvents(token)
//
//        assertEquals(userEvents, result)
//    }
    @Test
    fun `addTimeBoundary should return true when the timeBoundary is valid and user exists`() {
        // Arrange
        val token = "test_token"
        val timeBoundary = TimeBoundary("Partying", "12:00", "05:00")

        // Act
        val result = userCalendarService.addTimeBoundary(token, timeBoundary)

        // Assert
        Assertions.assertTrue(result)
        Mockito.verify(userRepository).save(Mockito.any(User::class.java))
    }

    @Test
    fun `addTimeBoundary should return false when the timeBoundary is null`() {
        // Arrange
        val token = "test_token"
        val timeBoundary = TimeBoundary("Play", "01:00", "03:00")
        // Act
        val result = userCalendarService.addTimeBoundary(token, timeBoundary)

        // Assert
        Assertions.assertFalse(result)
        Mockito.verify(userRepository, Mockito.never()).save(Mockito.any(User::class.java))
    }

    @Test
    fun `addTimeBoundary should return false when the user does not exist`() {
        // Arrange
        val token = "test_token"
        val timeBoundary = TimeBoundary()

        // Act
        val result = userCalendarService.addTimeBoundary(token, timeBoundary)

        // Assert
        Assertions.assertFalse(result)
        Mockito.verify(userRepository, Mockito.never()).save(Mockito.any(User::class.java))
    }

    @Test
    fun `removeTimeBoundary should return true when the name is valid and user exists`() {
        // Arrange
        val token = "test_token"
        val name = "TimeBoundary1"
        val retrievedUser = User()
        val timeBoundary1 = TimeBoundary()
        timeBoundary1.setName("TimeBoundary1")
        val timeBoundary2 = TimeBoundary()
        timeBoundary2.setName("TimeBoundary2")
        retrievedUser.addTimeBoundary(timeBoundary1)
        retrievedUser.addTimeBoundary(timeBoundary2)
        Mockito.`when`(userRepository.save(retrievedUser)).thenReturn(retrievedUser)

        // Act
        val result = userCalendarService.removeTimeBoundary(token, name)

        // Assert
        Assertions.assertTrue(result)
        Assertions.assertNull(timeBoundary1.user)
        Assertions.assertEquals(1, retrievedUser.getUserTimeBoundaries()?.size)
        Mockito.verify(userRepository).save(retrievedUser)
    }

    @Test
    fun `removeTimeBoundary should return false when the name is null`() {
        // Arrange
        val token = "test_token"
        val name: String? = null

        // Act
        val result = userCalendarService.removeTimeBoundary(token, name)

        // Assert
        Assertions.assertFalse(result)
        Mockito.verify(userRepository, Mockito.never()).save(Mockito.any(User::class.java))
    }

    @Test
    fun `removeTimeBoundary should return false when the user does not exist`() {
        // Arrange
        val token = "test_token"
        val name = "TimeBoundary1"

        // Act
        val result = userCalendarService.removeTimeBoundary(token, name)

        // Assert
        Assertions.assertFalse(result)
        Mockito.verify(userRepository, Mockito.never()).save(Mockito.any(User::class.java))
    }

    @Test
    fun `getUserTimeBoundaries should return user's time boundaries when user exists`() {
        // Arrange
        val token = "test_token"

        val retrievedUser = User()
        val timeBoundary1 = TimeBoundary("Family")
        val timeBoundary2 = TimeBoundary("Friends")
        retrievedUser.addTimeBoundary(timeBoundary1)
        retrievedUser.addTimeBoundary(timeBoundary2)
        val timeBoundaries = mutableListOf(
            TimeBoundary(name = "TimeBoundary1"),
            TimeBoundary(name = "TimeBoundary2"),
        )
        // Act
        val result = userCalendarService.getUserTimeBoundaries(token)

        // Assert
        Assertions.assertEquals(timeBoundaries, result)
    }

    @Test
    fun `getUserTimeBoundaries should return an empty list when user does not exist`() {
        // Arrange
        val token = "test_token"

        // Act
        val result = userCalendarService.getUserTimeBoundaries(token)

        // Assert
        Assertions.assertTrue(result.isEmpty())
    }
}

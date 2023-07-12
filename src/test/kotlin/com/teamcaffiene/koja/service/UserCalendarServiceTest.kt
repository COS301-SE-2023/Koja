package com.teamcaffiene.koja.service

import com.teamcaffeine.koja.repository.UserAccountRepository
import com.teamcaffeine.koja.repository.UserRepository
import com.teamcaffeine.koja.service.UserCalendarService
import io.github.cdimascio.dotenv.Dotenv
import io.mockk.mockk
import org.junit.jupiter.api.BeforeEach

class UserCalendarServiceTest {
    private lateinit var userAccountRepository: UserAccountRepository
    private lateinit var userRepository: UserRepository
    private lateinit var userCalendarService: UserCalendarService

    @BeforeEach
    fun setup() {
        val dotenv: Dotenv = Dotenv.load()
        System.setProperty("KOJA_JWT_SECRET", dotenv["KOJA_JWT_SECRET"]!!)
        userRepository = mockk()
        userAccountRepository = mockk()
        userCalendarService = UserCalendarService(userAccountRepository, userRepository)
    }

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
}

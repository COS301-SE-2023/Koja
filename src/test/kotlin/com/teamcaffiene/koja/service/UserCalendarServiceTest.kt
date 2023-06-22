package com.teamcaffiene.koja.service

import com.teamcaffeine.koja.controller.TokenManagerController.Companion.getUserJWTTokenData
import com.teamcaffeine.koja.dto.JWTGoogleDTO
import com.teamcaffeine.koja.dto.UserEventDTO
import com.teamcaffeine.koja.dto.UserJWTTokenDataDTO
import com.teamcaffeine.koja.entity.UserAccount
import com.teamcaffeine.koja.repository.UserAccountRepository
import com.teamcaffeine.koja.repository.UserRepository
import com.teamcaffeine.koja.service.CalendarAdapterFactoryService
import com.teamcaffeine.koja.service.CalendarAdapterService
import com.teamcaffeine.koja.service.UserCalendarService
import io.mockk.every
import io.mockk.mockk
import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.Test
import java.util.*

class UserCalendarServiceTest {
    private lateinit var userAccountRepository: UserAccountRepository
    private lateinit var userRepository: UserRepository
    private lateinit var userCalendarService: UserCalendarService

    @BeforeEach
    fun setup() {
        userRepository = mockk(relaxed = true)
        userAccountRepository = mockk(relaxed = true)
        userCalendarService = UserCalendarService(userAccountRepository,userRepository)
    }

    @Test
    fun getAllUserEvents_ReturnsEmptyList_WhenNoUserAccountsFound() {
        // Arrange
        val token = "dummyToken"
        val userJWTTokenDataDTO = UserJWTTokenDataDTO(userID = 123, userAuthDetails = emptyList())
        every { getUserJWTTokenData(token) } returns userJWTTokenDataDTO
        every { userAccountRepository.findByUserID(userJWTTokenDataDTO.userID) } returns emptyList()

        // Act
        val result = userCalendarService.getAllUserEvents(token)

        // Assert
        assertEquals(emptyList<UserEventDTO>(), result)
    }

    @Test
    fun getAllUserEvents_ReturnsUserEventsFromCalendarAdapters() {
        val token = "dummyToken"
        val userJWTTokenDataDTO = UserJWTTokenDataDTO(
            userID = 123,
            userAuthDetails = listOf(JWTGoogleDTO(token,"dummyRefresh", 1L))
        )
        val userAccount = listOf(UserAccount(123))
        val calendarAdapterFactoryService = mockk<CalendarAdapterFactoryService>()
        val calendarAdapterService = mockk<CalendarAdapterService>()
        val userEvents = listOf(UserEventDTO(
                "1", "5KM Morning Jog", "LC sports center", Date(2015, 5, 28, 7, 0), Date(2015, 5, 28, 9, 0)
                )
        )

        every { getUserJWTTokenData(token) } returns userJWTTokenDataDTO
        every { userAccountRepository.findByUserID(userJWTTokenDataDTO.userID) } returns userAccount
        every { userCalendarService.getAllUserEvents(token) } returns userEvents
        every { calendarAdapterFactoryService.createCalendarAdapter(any()) } returns calendarAdapterService

        val result = userCalendarService.getAllUserEvents(token)

        assertEquals(userEvents, result)



    }
}
package com.teamcaffiene.koja.service

import com.teamcaffeine.koja.repository.UserAccountRepository
import com.teamcaffeine.koja.repository.UserRepository
import com.teamcaffeine.koja.service.CalendarAdapterFactoryService
import io.mockk.mockk
import org.junit.jupiter.api.BeforeEach

internal class CalendarAdapterFactoryServiceTest {
    private lateinit var userRepository: UserRepository
    private lateinit var userAccountRepository: UserAccountRepository
    private lateinit var calendarAdapterFactoryService: CalendarAdapterFactoryService

    @BeforeEach
    fun setUp() {
        userRepository = mockk()
        userAccountRepository = mockk()
        calendarAdapterFactoryService = CalendarAdapterFactoryService(userRepository, userAccountRepository)
    }

//    @Test
//    fun `createCalendarAdapter should return GoogleCalendarAdapterService for AuthProviderEnum GOOGLE`() {
//        val authProvider = AuthProviderEnum.GOOGLE
//
//        val result = calendarAdapterFactoryService.createCalendarAdapter(authProvider)
//
//        assertEquals(GoogleCalendarAdapterService::class.java, result::class.java)
//    }

//    @Test
//    fun `createCalendarAdapter should throw IllegalArgumentException for invalid AuthProviderEnum value`() {
//        val authProvider = AuthProviderEnum.NONE
//
//        assertThrows(IllegalArgumentException::class.java) {
//            calendarAdapterFactoryService.createCalendarAdapter(authProvider)
//        }
//    }
}

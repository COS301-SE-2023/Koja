package com.teamcaffiene.koja.service

import com.teamcaffeine.koja.enums.AuthProviderEnum
import com.teamcaffeine.koja.repository.UserAccountRepository
import com.teamcaffeine.koja.repository.UserRepository
import com.teamcaffeine.koja.service.CalendarAdapterFactoryService
import com.teamcaffeine.koja.service.CalendarAdapterService
import org.junit.jupiter.api.Assertions.assertDoesNotThrow
import org.junit.jupiter.api.Assertions.assertThrows
import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.Test
import org.mockito.InjectMocks
import org.mockito.Mock
import org.mockito.MockitoAnnotations

class CalendarAdapterFactoryServiceTest {
    @Mock
    private lateinit var userRepository: UserRepository

    @Mock
    private lateinit var userAccountRepository: UserAccountRepository

    @InjectMocks
    private lateinit var calendarAdapterFactoryService: CalendarAdapterFactoryService

    @BeforeEach
    fun setup() {
        MockitoAnnotations.openMocks(this)
    }

    @Test
    fun testCreateCalendarAdapter_withValidAuthProvider() {
        // Prepare test data
        val authProvider = AuthProviderEnum.GOOGLE

        assertDoesNotThrow {
            calendarAdapterFactoryService.createCalendarAdapter(authProvider)
        }
    }

    @Test
    fun testCreateCalendarAdapter_withInvalidAuthProvider() {
        // Prepare test data
        val authProvider = AuthProviderEnum.NONE

        // Invoke and verify
        assertThrows(IllegalArgumentException::class.java) {
            calendarAdapterFactoryService.createCalendarAdapter(authProvider)
        }
    }
}
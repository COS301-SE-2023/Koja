package com.teamcaffeine.koja.service

import com.teamcaffeine.koja.repository.UserAccountRepository
import com.teamcaffeine.koja.repository.UserRepository
import org.springframework.stereotype.Service

@Service
class CalendarAdapterFactoryService() {
    companion object{
        fun createCalendarAdapter(authProvider: String, userRepository: UserRepository, userAccountRepository: UserAccountRepository): CalendarAdapterService {
            return when (authProvider) {
                "GOOGLE" -> GoogleCalendarAdapterService(userRepository, userAccountRepository)
                else -> throw IllegalArgumentException("Invalid AuthProviderEnum value: $authProvider")
            }
        }
    }
}
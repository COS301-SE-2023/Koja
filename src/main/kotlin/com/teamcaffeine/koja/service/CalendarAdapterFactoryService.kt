package com.teamcaffeine.koja.service

import com.teamcaffeine.koja.enums.AuthProviderEnum
import com.teamcaffeine.koja.repository.UserAccountRepository
import com.teamcaffeine.koja.repository.UserRepository
import org.springframework.stereotype.Service

@Service
class CalendarAdapterFactoryService(
    private val userRepository: UserRepository,
    private val userAccountRepository: UserAccountRepository
) {
    private val creationMap: Map<AuthProviderEnum, (UserRepository, UserAccountRepository) -> CalendarAdapterService> = mapOf(
        AuthProviderEnum.GOOGLE to { userRepository: UserRepository, userAccountRepository: UserAccountRepository -> GoogleCalendarAdapterService(userRepository, userAccountRepository) },
    )

    public fun createCalendarAdapter(authProvider: AuthProviderEnum): CalendarAdapterService {
        val factoryFunction = creationMap[authProvider]
            ?: throw IllegalArgumentException("Invalid AuthProviderEnum value: $authProvider")
        return factoryFunction(userRepository, userAccountRepository)
    }
}

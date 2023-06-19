package com.teamcaffeine.koja.config

import com.teamcaffeine.koja.repository.UserAccountRepository
import com.teamcaffeine.koja.repository.UserRepository
import com.teamcaffeine.koja.service.GoogleCalendarAdapterService
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration

@Configuration
class AuthConfig {
    @Autowired
    private lateinit var userRepository: UserRepository

    @Autowired
    private lateinit var userAccountRepository: UserAccountRepository

    @Bean
    fun googleCalendarAdapter(): GoogleCalendarAdapterService {
        return GoogleCalendarAdapterService(this.userRepository, this.userAccountRepository)
    }
}

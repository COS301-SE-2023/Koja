package com.teamcaffiene.koja.service

import com.teamcaffeine.koja.repository.UserAccountRepository
import com.teamcaffeine.koja.repository.UserRepository
import com.teamcaffeine.koja.service.GoogleCalendarAdapterService
import io.github.cdimascio.dotenv.Dotenv
import org.mockito.Mock

class LocationServiceTest {

    @Mock
    lateinit var userRepository: UserRepository

    @Mock
    lateinit var userAccountRepository: UserAccountRepository

    private lateinit var service: GoogleCalendarAdapterService
    private lateinit var dotenv: Dotenv
}
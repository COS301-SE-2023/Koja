package com.teamcaffeine.koja.service

import com.teamcaffeine.koja.dto.UserEventDTO
import com.teamcaffeine.koja.repository.UserAccountRepository
import com.teamcaffeine.koja.repository.UserRepository
import org.springframework.stereotype.Service

@Service
class AIUserDataService(private val userRepository: UserRepository, private val userAccountRepository: UserAccountRepository) {
    private val clientId = System.getProperty("GOOGLE_CLIENT_ID")
    private val clientSecret = System.getProperty("GOOGLE_CLIENT_SECRET")
    fun getUserEventData(authKey: String) {
        val userAccounts = userAccountRepository.findAll()
        val userEvents = ArrayList<UserEventDTO>()
        for (userAccount in userAccounts) {
            val adapter = CalendarAdapterFactoryService(userRepository, userAccountRepository).createCalendarAdapter(userAccount.authProvider)

            val accessToken = adapter.refreshAccessToken(clientId, clientSecret, userAccount.refreshToken)
            val events = accessToken?.let { adapter.getUserEvents(it.getAccessToken()) }
            if (events != null) {
                for (event in events) {
                    userEvents.add(event)
                }
            }
        }
    }
}

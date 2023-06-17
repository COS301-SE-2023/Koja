package com.teamcaffeine.koja.service

import com.teamcaffeine.koja.controller.TokenManagerController.Companion.decodeJwtToken
import com.teamcaffeine.koja.dto.UserEventDTO
import com.teamcaffeine.koja.enums.JWTTokenStructureEnum
import com.teamcaffeine.koja.repository.UserAccountRepository
import com.teamcaffeine.koja.repository.UserRepository
import org.springframework.stereotype.Service

@Service
class UserCalendarService(private val userAccountRepository: UserAccountRepository, private val userRepository: UserRepository) {

    public fun getAllUserEvents(token: String): List<UserEventDTO> {
        val decodedJWT = decodeJwtToken(token)
        val userID = decodedJWT.getClaim(JWTTokenStructureEnum.USER_ID.claimName).asInt()
        val userAccounts = userAccountRepository.findByUserID(userID)

        val calendarAdapters = ArrayList<CalendarAdapterService>()
        val adapterFactory = CalendarAdapterFactoryService( userRepository, userAccountRepository)

        for (ua in userAccounts) {
            val adapter = adapterFactory.createCalendarAdapter(ua.authProvider)
            calendarAdapters.add(adapterFactory.createCalendarAdapter(ua.authProvider))
        }

        val userEvents = ArrayList<UserEventDTO>()

        for (ca in calendarAdapters) {
            val events = ca.getUserEvents(token)
            userEvents.addAll(events)
        }

        return userEvents
    }

    private fun consolidateEvents(userEvent: UserEventDTO?) {
        TODO("Not yet implemented");
    }


}

package com.teamcaffeine.koja.service

import com.teamcaffeine.koja.controller.TokenManagerController
import com.teamcaffeine.koja.dto.UserEventDTO
import org.springframework.stereotype.Service
import com.teamcaffeine.koja.controller.TokenManagerController.Companion.decodeJwtToken
import com.teamcaffeine.koja.enums.JWTTokenStructure
import com.teamcaffeine.koja.repository.UserAccountRepository

@Service
class UserCalendarService(private val userAccountRepository: UserAccountRepository) {

    public fun getAllUserEvents(token: String): List<UserEventDTO> {
        val decodedJWT = decodeJwtToken(token)
        val userID = decodedJWT.getClaim(JWTTokenStructure.USER_ID.claimName).asInt()
        val userAccounts = userAccountRepository.findByUserID(userID)

        val calendarAdapters = ArrayList<CalendarAdapterService>()

        for (ua in userAccounts) {
            calendarAdapters.add(CalendarAdapterFactory.getCalendarAdapter(userAccount.authProvider))
        }
    }

    private fun consolidateEvents(userEvent: UserEventDTO?) {
        TODO("Not yet implemented");
    }


}

package com.teamcaffeine.koja.service

import com.teamcaffeine.koja.controller.TokenManagerController.Companion.getUserJWTTokenData
import com.teamcaffeine.koja.dto.UserEventDTO
import com.teamcaffeine.koja.dto.UserJWTTokenDataDTO
import com.teamcaffeine.koja.entity.UserAccount
import com.teamcaffeine.koja.repository.UserAccountRepository
import com.teamcaffeine.koja.repository.UserRepository
import org.springframework.stereotype.Service
import java.util.Calendar
import java.util.Date

@Service
class UserCalendarService(
    private val userAccountRepository: UserAccountRepository,
    private val userRepository: UserRepository
) {

    fun getAllUserEvents(token: String): List<UserEventDTO> {
        val userJWTTokenData = getUserJWTTokenData(token)

        val (userAccounts, calendarAdapters) = getUserCalendarAdapters(userJWTTokenData)

        val userEvents = ArrayList<UserEventDTO>()

        for (adapter in calendarAdapters) {
            val userAccount = userAccounts[calendarAdapters.indexOf(adapter)]
            val accessToken =
                userJWTTokenData.userAuthDetails.firstOrNull() { it.getRefreshToken() == userAccount.refreshToken }
                    ?.getAccessToken()
            if (accessToken != null) {
                userEvents.addAll(adapter.getUserEvents(accessToken))
            }
        }

        return userEvents
    }

    private fun getUserCalendarAdapters(userJWTTokenData: UserJWTTokenDataDTO): Pair<List<UserAccount>, ArrayList<CalendarAdapterService>> {
        val userAccounts = userAccountRepository.findByUserID(userJWTTokenData.userID)
        val calendarAdapters = ArrayList<CalendarAdapterService>()
        val adapterFactory = CalendarAdapterFactoryService(userRepository, userAccountRepository)

        for (ua in userAccounts) {
            calendarAdapters.add(adapterFactory.createCalendarAdapter(ua.authProvider))
        }
        return Pair(userAccounts, calendarAdapters)
    }

    private fun consolidateEvents(userEvent: UserEventDTO?) {
        TODO("Not yet implemented")
    }

    fun createEvent(token: String, eventDTO: UserEventDTO) {
        val userJWTTokenData = getUserJWTTokenData(token)
        val (userAccounts, calendarAdapters) = getUserCalendarAdapters(userJWTTokenData)
        val userEvents = ArrayList<UserEventDTO>()

        for (adapter in calendarAdapters) {
            val userAccount = userAccounts[calendarAdapters.indexOf(adapter)]
            val accessToken = userJWTTokenData.userAuthDetails.firstOrNull {
                it.getRefreshToken() == userAccount.refreshToken
            }?.getAccessToken()
            if (accessToken != null) {
                userEvents.addAll(adapter.getUserEventsInRange(accessToken!!, eventDTO.getStartTime(), eventDTO.getEndTime()))
            }
        }

        val (earliestSlotStartTime, earliestSlotEndTime) = findEarliestTimeSlot(userEvents, eventDTO)
        eventDTO.setStartTime(earliestSlotStartTime)
        eventDTO.setEndTime(earliestSlotEndTime)

        for (adapter in calendarAdapters) {
            val userAccount = userAccounts[calendarAdapters.indexOf(adapter)]
            val accessToken = userJWTTokenData.userAuthDetails.firstOrNull {
                it.getRefreshToken() == userAccount.refreshToken
            }?.getAccessToken()
            if (accessToken != null) {
                adapter.createEvent(accessToken, eventDTO)
            }
        }
    }

    private fun findEarliestTimeSlot(userEvents: List<UserEventDTO>, eventDTO: UserEventDTO): Pair<Date, Date> {
        val sortedUserEvents = userEvents.sortedBy { it.getStartTime() }

        var earliestSlotStartTime = eventDTO.getStartTime().let { originalDate ->
            val calendar = Calendar.getInstance()
            calendar.time = originalDate
            calendar.set(Calendar.HOUR_OF_DAY, 0)
            calendar.set(Calendar.MINUTE, 0)
            calendar.set(Calendar.SECOND, 0)
            calendar.time
        }

        for (i in sortedUserEvents.indices) {
            val currentEvent = sortedUserEvents[i]
            val nextEvent = sortedUserEvents.getOrNull(i + 1)

            if (earliestSlotStartTime.after(currentEvent.getEndTime()) &&
                (nextEvent == null || earliestSlotStartTime.before(nextEvent.getStartTime()))
            ) {

                break
            }

            // Otherwise, the earliestSlotStartTime is updated to after the current event ends
            earliestSlotStartTime = currentEvent.getEndTime()
        }

        // Calculate end time based on the duration of the event
        val duration = eventDTO.getEndTime().time - eventDTO.getStartTime().time
        val earliestSlotEndTime = Date(earliestSlotStartTime.time + duration)

        return Pair(earliestSlotStartTime, earliestSlotEndTime)
    }
}

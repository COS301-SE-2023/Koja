package com.teamcaffeine.koja.service

import com.teamcaffeine.koja.controller.TokenManagerController.Companion.getUserJWTTokenData
import com.teamcaffeine.koja.dto.UserEventDTO
import com.teamcaffeine.koja.dto.UserJWTTokenDataDTO
import com.teamcaffeine.koja.entity.UserAccount
import com.teamcaffeine.koja.repository.UserAccountRepository
import com.teamcaffeine.koja.repository.UserRepository
import org.springframework.stereotype.Service
import java.time.OffsetDateTime

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
    fun updateEvent(token: String, eventDTO: UserEventDTO){
        var userJWTTokenData = getUserJWTTokenData(token)
        val (userAccounts, calendarAdapters) = getUserCalendarAdapters(userJWTTokenData)

        for (adapter in calendarAdapters) {
            val userAccount = userAccounts[calendarAdapters.indexOf(adapter)]
            val accessToken = userJWTTokenData.userAuthDetails.firstOrNull {
                it.getRefreshToken() == userAccount.refreshToken
            }?.getAccessToken()
            if (accessToken != null){
                adapter.updateEvent(accessToken, eventDTO)
            }
        }
    }

    fun deleteEvent(token: String, eventDTO: UserEventDTO){
        var userJWTTokenData = getUserJWTTokenData(token)
        val (userAccounts, calendarAdapters) = getUserCalendarAdapters(userJWTTokenData)

        for (adapter in calendarAdapters){
            val userAccount = userAccounts[calendarAdapters.indexOf(adapter)]
            val accessToken = userJWTTokenData.userAuthDetails.firstOrNull {
                it.getRefreshToken() == userAccount.refreshToken
            }?.getAccessToken()
            if (accessToken != null){
                adapter.deleteEvent(accessToken, eventDTO)
            }
        }
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
                userEvents.addAll(adapter.getUserEventsInRange(accessToken, eventDTO.getStartTime(), eventDTO.getEndTime()))
            }
        }

        if (eventDTO.isDynamic()) {
            val (earliestSlotStartTime, earliestSlotEndTime) = findEarliestTimeSlot(userEvents, eventDTO)
            eventDTO.setStartTime(earliestSlotStartTime)
            eventDTO.setEndTime(earliestSlotEndTime)
        }

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

    private fun findEarliestTimeSlot(userEvents: List<UserEventDTO>, eventDTO: UserEventDTO): Pair<OffsetDateTime, OffsetDateTime> {
        val sortedUserEvents = userEvents.sortedBy { it.getStartTime() }

        val currentDateTime = OffsetDateTime.now()
        val sortedAvailableTimeSlots = eventDTO.getTimeSlots()
            .filter { it.endTime.isAfter(currentDateTime) }
            .sortedBy { it.startTime }

        var earliestSlotStartTime: OffsetDateTime? = null
        var earliestSlotEndTime: OffsetDateTime? = null

        for (timeSlot in sortedAvailableTimeSlots) {
            val potentialSlotEndTime = timeSlot.startTime.plusSeconds(eventDTO.getDuration())

            if (!potentialSlotEndTime.isAfter(timeSlot.endTime)) {
                val conflictingEvent = sortedUserEvents.find {
                    (it.getStartTime().isAfter(timeSlot.startTime) && it.getStartTime().isBefore(potentialSlotEndTime)) ||
                        (it.getEndTime().isAfter(timeSlot.startTime) && it.getEndTime().isBefore(potentialSlotEndTime)) ||
                        (it.getStartTime().isBefore(timeSlot.startTime) && it.getEndTime().isAfter(potentialSlotEndTime))
                }

                if (conflictingEvent == null) {
                    earliestSlotStartTime = timeSlot.startTime
                    earliestSlotEndTime = potentialSlotEndTime
                    break
                }
            }
        }

        if (earliestSlotStartTime == null || earliestSlotEndTime == null) {
            throw Exception("Could not find a time slot where the event can fit")
        }

        return Pair(earliestSlotStartTime, earliestSlotEndTime)
    }
}

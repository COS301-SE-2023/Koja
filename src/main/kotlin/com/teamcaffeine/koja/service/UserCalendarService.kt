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

    private fun findEarliestTimeSlot(userEvents: List<UserEventDTO>, eventDTO: UserEventDTO): Pair<Date, Date> {
        val sortedUserEvents = userEvents.sortedBy { it.getStartTime() }

        val currentDateTime = Calendar.getInstance().time
        val sortedAvailableTimeSlots = eventDTO.getTimeSlots()
            .filter { it.endTime.after(currentDateTime) }
            .sortedBy { it.startTime }

        var earliestSlotStartTime: Date? = null
        var earliestSlotEndTime: Date? = null

        for (timeSlot in sortedAvailableTimeSlots) {
            val potentialSlotEndTime = Date(timeSlot.startTime.time + eventDTO.getDuration())

            if (!potentialSlotEndTime.after(timeSlot.endTime)) {
                val conflictingEvent = sortedUserEvents.find {
                    (it.getStartTime().after(timeSlot.startTime) && it.getStartTime().before(potentialSlotEndTime)) ||
                        (it.getEndTime().after(timeSlot.startTime) && it.getEndTime().before(potentialSlotEndTime)) ||
                        (it.getStartTime().before(timeSlot.startTime) && it.getEndTime().after(potentialSlotEndTime))
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

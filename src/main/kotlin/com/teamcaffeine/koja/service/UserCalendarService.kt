package com.teamcaffeine.koja.service

import com.teamcaffeine.koja.controller.TokenManagerController.Companion.getUserJWTTokenData
import com.teamcaffeine.koja.dto.JWTFunctionality
import com.teamcaffeine.koja.dto.UserEventDTO
import com.teamcaffeine.koja.dto.UserJWTTokenDataDTO
import com.teamcaffeine.koja.entity.TimeBoundary
import com.teamcaffeine.koja.entity.UserAccount
import com.teamcaffeine.koja.repository.TimeBoundaryRepository
import com.teamcaffeine.koja.repository.UserAccountRepository
import com.teamcaffeine.koja.repository.UserRepository
import jakarta.transaction.Transactional
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Service
import java.time.Duration
import java.time.OffsetDateTime

@Service
class UserCalendarService(
    @Autowired
    private var userRepository: UserRepository,
    private val jwtFunctionality: JWTFunctionality,
) {

    @Autowired
    private lateinit var userAccountRepository: UserAccountRepository

    @Autowired
    private lateinit var timeBoundaryRepository: TimeBoundaryRepository

    fun getAllUserEvents(token: String): List<UserEventDTO> {
        val userJWTTokenData = jwtFunctionality.getUserJWTTokenData(token)

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

    @Transactional
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

    fun updateEvent(token: String, eventDTO: UserEventDTO) {
        val userJWTTokenData = jwtFunctionality.getUserJWTTokenData(token)
        val (userAccounts, calendarAdapters) = getUserCalendarAdapters(userJWTTokenData)

        for (adapter in calendarAdapters) {
            val userAccount = userAccounts[calendarAdapters.indexOf(adapter)]
            val accessToken = userJWTTokenData.userAuthDetails.firstOrNull {
                it.getRefreshToken() == userAccount.refreshToken
            }?.getAccessToken()

            if (accessToken != null) {
                adapter.updateEvent(accessToken, eventDTO)
            }
        }
    }

    fun deleteEvent(token: String, eventID: String) {
        val userJWTTokenData = getUserJWTTokenData(token)
        val (userAccounts, calendarAdapters) = getUserCalendarAdapters(userJWTTokenData)

        for (adapter in calendarAdapters) {
            val userAccount = userAccounts[calendarAdapters.indexOf(adapter)]
            val accessToken = userJWTTokenData.userAuthDetails.firstOrNull {
                it.getRefreshToken() == userAccount.refreshToken
            }?.getAccessToken()

            if (accessToken != null) {
                adapter.deleteEvent(accessToken, eventID)
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
                userEvents.addAll(
                    adapter.getUserEventsInRange(
                        accessToken,
                        eventDTO.getStartTime().withHour(0).withMinute(0).withSecond(0).withNano(0),
                        eventDTO.getEndTime().withHour(23).withMinute(59).withSecond(59).withNano(999999999),
                    ),
                )
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

    private fun findEarliestTimeSlot(
        userEvents: List<UserEventDTO>,
        eventDTO: UserEventDTO,
    ): Pair<OffsetDateTime, OffsetDateTime> {
        val sortedUserEvents = userEvents.sortedBy { it.getStartTime() }

        var currentDateTime = OffsetDateTime.now()
        val sortedAvailableTimeSlots = eventDTO.getTimeSlots()
            .filter {
                it.endTime.isAfter(currentDateTime) && Duration.between(currentDateTime, it.endTime).seconds >= eventDTO.getDurationInSeconds()
            }
            .sortedBy { it.startTime }

        if (sortedAvailableTimeSlots.isNotEmpty()) {
            currentDateTime = currentDateTime.withOffsetSameInstant(sortedAvailableTimeSlots.first().startTime.offset)
        }

        var newEventStartTime: OffsetDateTime? = null
        var newEventEndTime: OffsetDateTime? = null

        for (timeSlot in sortedAvailableTimeSlots) {
            var potentialStartTime = timeSlot.startTime
            var potentialEndTime = potentialStartTime.plusSeconds(eventDTO.getDurationInSeconds())
            val potentialEndTimeLimit = timeSlot.endTime

            while (!potentialEndTime.isAfter(potentialEndTimeLimit)) {
                val conflictingEvent = sortedUserEvents.find {
                    val userEventStartTime = it.getStartTime()
                    val userEventEndTime = it.getEndTime()

                    (userEventEndTime.isAfter(potentialStartTime) && userEventStartTime.isBefore(potentialStartTime)) ||
                        (userEventStartTime.isBefore(potentialEndTime) && userEventEndTime.isAfter(potentialEndTime)) ||
                        (userEventStartTime.isAfter(potentialStartTime) && userEventEndTime.isBefore(potentialEndTime)) ||
                        (userEventStartTime.isBefore(potentialStartTime) && userEventEndTime.isAfter(potentialEndTime)) ||
                        (userEventStartTime.isEqual(potentialStartTime) && userEventEndTime.isEqual(potentialEndTime)) ||
                        (userEventStartTime.isEqual(potentialStartTime) && userEventEndTime.isBefore(potentialEndTime)) ||
                        (userEventEndTime.isEqual(potentialEndTime) && userEventStartTime.isAfter(potentialStartTime)) ||
                        (userEventEndTime.isEqual(potentialEndTime) && userEventStartTime.isBefore(potentialStartTime)) ||
                        (userEventStartTime.isEqual(potentialStartTime) && userEventEndTime.isAfter(potentialEndTime))
                }

                if (conflictingEvent == null) {
                    newEventStartTime = potentialStartTime
                    newEventEndTime = potentialEndTime
                    break
                } else {
                    potentialStartTime = conflictingEvent.getEndTime()
                    potentialEndTime = potentialStartTime.plusSeconds(eventDTO.getDurationInSeconds())
                }
            }

            if (newEventStartTime != null && newEventEndTime != null) {
                break
            }
        }

        if (newEventStartTime == null || newEventEndTime == null) {
            throw Exception("Could not find a time slot where the event can fit")
        }

        return Pair(newEventStartTime, newEventEndTime)
    }

    @Transactional
    fun addTimeBoundary(token: String, timeBoundary: TimeBoundary): Boolean {
        val userJWTTokenData = jwtFunctionality.getUserJWTTokenData(token)
        val user = userRepository.findById(userJWTTokenData.userID)
        if (timeBoundary != null && !user.isEmpty) {
            val retrievedUser = user.get()
            retrievedUser.addTimeBoundary(timeBoundary)
            timeBoundary.user = retrievedUser
            userRepository.save(retrievedUser)
            return true
        }
        return false
    }

    @Transactional
    fun removeTimeBoundary(token: String, name: String?): Boolean {
        val userJWTTokenData = getUserJWTTokenData(token)
        val user = userRepository.findById(userJWTTokenData.userID)
        if (name != null && !user.isEmpty) {
            val retrievedUser = user.get()
            for (i in 1..retrievedUser.getUserTimeBoundaries()!!.size) {
                if (retrievedUser.getUserTimeBoundaries()!!.get(i).getName() == name) {
                    val boundaryToRemove = retrievedUser.getUserTimeBoundaries()!!.get(i)
                    boundaryToRemove.user = null
                    retrievedUser.getUserTimeBoundaries()!!.removeAt(i)
                    userRepository.save(retrievedUser)
                    return true
                }
            }
        }
        return false
    }

    fun getUserTimeBoundaries(token: String): MutableList<TimeBoundary> {
        val userJWTTokenData = getUserJWTTokenData(token)
        val user = userRepository.findById(userJWTTokenData.userID)
        if (user != null) {
            return user.get().getUserTimeBoundaries()
        }
        return mutableListOf()
    }

    fun getUserTimeBoundaryAndLocation(token: String, name: String): Pair<TimeBoundary?, String?> {
        val userJWTTokenData = getUserJWTTokenData(token)
        val user = userRepository.findById(userJWTTokenData.userID).get()
        var timeBoundary: TimeBoundary ? = null

        if (user != null) {
            for (i in 0..(user.getUserTimeBoundaries()?.size ?: 0))
                if (user.getUserTimeBoundaries()?.get(i)?.getName() == name) {
                    timeBoundary = user.getUserTimeBoundaries()?.get(i)
                }
        }
        when (name) {
            "Work" -> return Pair(timeBoundary, user.getWorkLocation())
            "Resting" -> return Pair(timeBoundary, user.getHomeLocation())
            "School" -> return Pair(timeBoundary, user.getWorkLocation())
            "Hobby" -> return Pair(timeBoundary, "")
            "Chore" -> return Pair(timeBoundary, "")
        }
        return Pair(null, null)
    }
}

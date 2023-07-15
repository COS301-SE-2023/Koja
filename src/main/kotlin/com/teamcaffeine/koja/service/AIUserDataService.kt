package com.teamcaffeine.koja.service

import com.teamcaffeine.koja.dto.AIUserEventDataDTO
import com.teamcaffeine.koja.dto.UserEventDTO
import com.teamcaffeine.koja.repository.UserAccountRepository
import com.teamcaffeine.koja.repository.UserRepository
import jakarta.transaction.Transactional
import org.springframework.stereotype.Service
import java.time.OffsetDateTime

@Service
@Transactional
class AIUserDataService(private val userRepository: UserRepository, private val userAccountRepository: UserAccountRepository) {
    private val clientId = System.getProperty("GOOGLE_CLIENT_ID")
    private val clientSecret = System.getProperty("GOOGLE_CLIENT_SECRET")
    fun getUserEventData(authKey: String): MutableList<Map<Any, Any>> {
        val userAccounts = userAccountRepository.findAll()
        val userEvents = ArrayList<UserEventDTO>()
        for (userAccount in userAccounts) {
            val adapter = CalendarAdapterFactoryService(userRepository, userAccountRepository).createCalendarAdapter(userAccount.authProvider)

            val accessToken = adapter.refreshAccessToken(clientId, clientSecret, userAccount.refreshToken)
            val events = accessToken?.let { adapter.getUserEvents(it.getAccessToken()) }
            if (events != null) {
                for (event in events) {
                    event.setUserID(userAccount.userID.toString())
                    userEvents.add(event)
                }
            }
        }

        userEvents.sortBy { it.getStartTime() }

        val eventSemesterMap = mutableMapOf<Int, List<UserEventDTO>>()
        var semesterNum = 1
        var startTime = userEvents.first().getStartTime()
        var endTime = startTime.plusMonths(6)

        do {
            val semesterEvents = userEvents.filter { it.getStartTime().isBefore(endTime) && (it.getStartTime().isAfter(startTime) || it.getStartTime().isEqual(startTime)) }

            if (semesterEvents.isNotEmpty()) eventSemesterMap[semesterNum++] = semesterEvents
            startTime = endTime
            endTime = endTime.plusMonths(6)
        } while (endTime.isBefore(OffsetDateTime.now().plusMonths(6)))

        val results = mutableListOf<Map<Any, Any>>()

        val semesterTrainingData = ArrayList<AIUserEventDataDTO>()
        val semesterTestingData = ArrayList<AIUserEventDataDTO>()

        for (semester in eventSemesterMap.values) {
            val semesterTrainingDataSize = (semester.size * 0.8).toInt()
            for (i in 0 until semesterTrainingDataSize) {
                semesterTrainingData.add(
                    AIUserEventDataDTO(
                        semester[i].getTimeSlots(),
                        semester[i].getUserID(),
                        semester[i].getDescription(),
                        semester[i].getStartTime().dayOfWeek!!.toString(),
                    ),
                )
            }

            for (i in semesterTrainingDataSize until semester.size) {
                semesterTestingData.add(
                    AIUserEventDataDTO(
                        semester[i].getTimeSlots(),
                        semester[i].getUserID(),
                        semester[i].getDescription(),
                        semester[i].getStartTime().dayOfWeek!!.toString(),
                    ),
                )
            }

            results.add(mapOf("training" to semesterTrainingData, "testing" to semesterTestingData))
        }
        return results
    }
}

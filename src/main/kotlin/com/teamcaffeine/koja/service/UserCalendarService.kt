package com.teamcaffeine.koja.service

import com.teamcaffeine.koja.constants.EnvironmentVariableConstant
import com.teamcaffeine.koja.controller.TokenManagerController.Companion.getUserJWTTokenData
import com.teamcaffeine.koja.dto.JWTFunctionality
import com.teamcaffeine.koja.dto.UserEventDTO
import com.teamcaffeine.koja.dto.UserJWTTokenDataDTO
import com.teamcaffeine.koja.entity.TimeBoundary
import com.teamcaffeine.koja.entity.UserAccount
import com.teamcaffeine.koja.enums.TimeBoundaryType
import com.teamcaffeine.koja.repository.TimeBoundaryRepository
import com.teamcaffeine.koja.repository.UserAccountRepository
import com.teamcaffeine.koja.repository.UserRepository
import jakarta.transaction.Transactional
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Service
import software.amazon.awssdk.auth.credentials.AwsBasicCredentials
import software.amazon.awssdk.regions.Region
import software.amazon.awssdk.services.dynamodb.DynamoDbClient
import software.amazon.awssdk.services.dynamodb.model.AttributeValue
import software.amazon.awssdk.services.dynamodb.model.QueryRequest
import java.time.DayOfWeek
import java.time.Duration
import java.time.Instant
import java.time.LocalTime
import java.time.OffsetDateTime
import java.time.ZoneOffset
import java.time.format.DateTimeFormatter
import java.time.temporal.TemporalAdjusters

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

        val userEvents = mutableMapOf<String, UserEventDTO>()

        for (adapter in calendarAdapters) {
            val userAccount = userAccounts[calendarAdapters.indexOf(adapter)]
            val userAuthDetails = userJWTTokenData.userAuthDetails
            for (authDetails in userAuthDetails) {
                if (authDetails.getRefreshToken() == userAccount.refreshToken) {
                    val accessToken = authDetails.getAccessToken()
                    userEvents.putAll(adapter.getUserEvents(accessToken))
                }
            }
        }

        return userEvents.values.toList()
    }

    fun getAllUserEventsKojaSuggestions(token: String): List<UserEventDTO> {
        val userJWTTokenData = jwtFunctionality.getUserJWTTokenData(token)
        val userID = userJWTTokenData.userID

        val (userAccounts, calendarAdapters) = getUserCalendarAdapters(userJWTTokenData)

        val userEvents = mutableMapOf<String, UserEventDTO>()

        for (adapter in calendarAdapters) {
            val userAccount = userAccounts[calendarAdapters.indexOf(adapter)]
            val userAuthDetails = userJWTTokenData.userAuthDetails
            for (authDetails in userAuthDetails) {
                if (authDetails.getRefreshToken() == userAccount.refreshToken) {
                    val accessToken = authDetails.getAccessToken()
                    userEvents.putAll(adapter.getUserEventsKojaSuggestions(accessToken))
                }
            }
        }

        return userEvents.values.toList()
    }

    @Transactional
    fun getUserCalendarAdapters(userJWTTokenData: UserJWTTokenDataDTO): Pair<List<UserAccount>, ArrayList<CalendarAdapterService>> {
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

    fun updateEvent(token: String, eventDTO: UserEventDTO): Boolean {
        val userJWTTokenData = jwtFunctionality.getUserJWTTokenData(token)
        val (userAccounts, calendarAdapters) = getUserCalendarAdapters(userJWTTokenData)

        for (adapter in calendarAdapters) {
            val userAccount = userAccounts[calendarAdapters.indexOf(adapter)]
            val accessToken = userJWTTokenData.userAuthDetails.firstOrNull {
                it.getRefreshToken() == userAccount.refreshToken
            }?.getAccessToken()

            if (accessToken != null) {
                adapter.updateEvent(accessToken, eventDTO)
                return true
            }
        }
        return false
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
        val userBedTime = getUserTimeBoundaries(token).firstOrNull {
            it.getName() == "Bed-Time"
        }
        val adapterAccessTokenMap = HashMap<CalendarAdapterService, String?>()

        if (userBedTime != null) {
            val startTimeString = userBedTime.getStartTime()
            val endTimeString = userBedTime.getEndTime()

            if (startTimeString != null && endTimeString != null) {
                val startTime = LocalTime.parse(startTimeString)
                val endTime = LocalTime.parse(endTimeString)
                val eventDay = eventDTO.getStartTime().toLocalDate()

                val startTimeOffsetDateTime = OffsetDateTime.of(eventDay.minusDays(1), startTime, ZoneOffset.UTC)
                var endTimeOffsetDateTime = OffsetDateTime.of(eventDay, endTime, ZoneOffset.UTC)

                if (endTimeOffsetDateTime.isBefore(startTimeOffsetDateTime)) {
                    endTimeOffsetDateTime = endTimeOffsetDateTime.plusDays(1)
                }

                userEvents.add(
                    UserEventDTO(
                        id = "${Long.MAX_VALUE}",
                        summary = "Bed-Time Event",
                        location = "location1",
                        startTime = startTimeOffsetDateTime,
                        endTime = endTimeOffsetDateTime,
                        duration = 1,
                        timeSlots = emptyList(),
                        priority = 1,
                        dynamic = false,
                        userID = "1",
                    ),
                )
            }
        }

        var travelDuration = 0L

        for (adapter in calendarAdapters) {
            val googleCalendarAdapter: GoogleCalendarAdapterService? = try {
                adapter as GoogleCalendarAdapterService
            } catch (e: Exception) {
                null
            }

            var locationService: LocationService?
            val locationID = eventDTO.getLocation()
            if (travelDuration == 0L && googleCalendarAdapter != null && locationID.isNotEmpty()) {
                locationService = LocationService(userRepository, googleCalendarAdapter)
                val currentLocation: Pair<Double, Double> =
                    anyToPair(locationService.getUserSavedLocations(token)["currentLocation"])

                val latitude = currentLocation.second
                val longitude = currentLocation.first
                val travelTime = locationService.getTravelTime(
                    latitude,
                    longitude,
                    eventDTO.getLocation(),
                )

                if (travelTime != null) {
                    travelDuration = travelTime
                    eventDTO.setTravelTime(travelTime)
                }

                val locationCoordinates = locationService.getLocationCoordinates(locationID)

                if (locationCoordinates != null) {
                    eventDTO.setLocation("${locationCoordinates.first},${locationCoordinates.second}")
                }
            }

            val userAccount = userAccounts[calendarAdapters.indexOf(adapter)]
            val accessToken = userJWTTokenData.userAuthDetails.firstOrNull {
                it.getRefreshToken() == userAccount.refreshToken
            }?.getAccessToken()

            adapterAccessTokenMap[adapter] = accessToken

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

        val dynamicFutureEvents = ArrayList<UserEventDTO>()
        if (eventDTO.isDynamic()) {
            handleRecurrence(eventDTO, token)

            dynamicFutureEvents.addAll(
                userEvents.filter {
                    it.isDynamic() && it.getStartTime().isAfter(
                        OffsetDateTime.now().withOffsetSameInstant(eventDTO.getStartTime().offset),
                    )
                },
            )

            val newEventDuration =
                (eventDTO.getDurationInSeconds() + travelDuration) * 1000L // Multiply by 1000 to convert to milliseconds
            eventDTO.setDuration(newEventDuration)

            for ((adapter, accessToken) in adapterAccessTokenMap) {
                if (accessToken != null) {
                    for (dynamicFutureEvent in dynamicFutureEvents) {
                        adapter.deleteEvent(accessToken, dynamicFutureEvent.getId())
                    }
                    dynamicFutureEvents.add(eventDTO)
                    dynamicFutureEvents.sortBy { it.getPriority() }
                }
            }

            userEvents.removeAll(dynamicFutureEvents.toSet())

            if (dynamicFutureEvents.isEmpty()) {
                val (earliestSlotStartTime, earliestSlotEndTime) = findEarliestTimeSlot(userEvents, eventDTO)
                eventDTO.setStartTime(earliestSlotStartTime)
                eventDTO.setEndTime(earliestSlotEndTime)
            } else {
                for (dynamicFutureEvent in dynamicFutureEvents) {
                    val (earliestSlotStartTime, earliestSlotEndTime) = findEarliestTimeSlot(userEvents, dynamicFutureEvent)
                    dynamicFutureEvent.setStartTime(earliestSlotStartTime)
                    dynamicFutureEvent.setEndTime(earliestSlotEndTime)
                    userEvents.add(dynamicFutureEvent)
                }
            }
        } else {
            eventDTO.setStartTime(eventDTO.getStartTime().minusSeconds(travelDuration))
        }

        for ((adapter, accessToken) in adapterAccessTokenMap) {
            if (accessToken != null && dynamicFutureEvents.isEmpty()) {
                adapter.createEvent(accessToken, eventDTO, token)
            } else if (accessToken != null) {
                for (dynamicFutureEvent in dynamicFutureEvents) {
                    adapter.createEvent(accessToken, dynamicFutureEvent, token)
                }
            } else {
                // Do nothing
            }
        }
    }

    private fun handleRecurrence(eventDTO: UserEventDTO, token: String): UserEventDTO {
        val recurrence = eventDTO.getRecurrence()
        if (!recurrence.isNullOrEmpty()) {
            val interval = recurrence[1].toLong()
            val endDate = Instant.from(DateTimeFormatter.ISO_INSTANT.parse(recurrence[2])).atOffset(ZoneOffset.UTC).toLocalDate()
            val startDate = eventDTO.getStartTime().toLocalDate()
            val originalDate = eventDTO.getStartTime()
            when (recurrence[0]) {
                "DAILY" -> {
                    var date = startDate.plusDays(interval)
                    while (!date.isAfter(endDate)) {
                        val newEvent = eventDTO.copy()
                        newEvent.setRecurrence(null)
                        newEvent.setStartTime(newEvent.getStartTime().with(date))
                        newEvent.setEndTime(newEvent.getEndTime().with(date))
                        for (timeFrame in newEvent.getTimeSlots()) {
                            val difference = Duration.between(timeFrame.startTime, timeFrame.endTime).toHours()
                            if (difference in 23..25) {
                                timeFrame.startTime = timeFrame.startTime.with(date)
                                    .withHour(0).withMinute(0).withSecond(0)
                                    .withOffsetSameInstant(originalDate.offset)
                                timeFrame.endTime = timeFrame.endTime.with(date)
                                    .withHour(23).withMinute(59).withSecond(59)
                                    .withOffsetSameInstant(originalDate.offset)
                            }
                        }
                        createEvent(token, newEvent)
                        date = date.plusDays(interval)
                    }
                }
                "WEEKLY" -> {
                    var date = startDate.plusWeeks(interval)
                    while (!date.isAfter(endDate)) {
                        val newEvent = eventDTO.copy()
                        newEvent.setRecurrence(null)
                        newEvent.setStartTime(newEvent.getStartTime().with(date))
                        newEvent.setEndTime(newEvent.getEndTime().with(date))
                        for (timeFrame in newEvent.getTimeSlots()) {
                            val difference = Duration.between(timeFrame.startTime, timeFrame.endTime).toHours()
                            if (difference in 23..25) {
                                timeFrame.startTime = timeFrame.startTime.with(date)
                                    .withHour(0).withMinute(0).withSecond(0)
                                    .withOffsetSameInstant(originalDate.offset)
                                timeFrame.endTime = timeFrame.endTime.with(date)
                                    .withHour(23).withMinute(59).withSecond(59)
                                    .withOffsetSameInstant(originalDate.offset)
                            }
                        }
                        createEvent(token, newEvent)
                        date = date.plusWeeks(interval)
                    }
                }
                "MONTHLY" -> {
                    var date = startDate.plusMonths(interval)
                    while (!date.isAfter(endDate)) {
                        val newEvent = eventDTO.copy()
                        newEvent.setRecurrence(null)
                        newEvent.setStartTime(newEvent.getStartTime().with(date))
                        newEvent.setEndTime(newEvent.getEndTime().with(date))
                        for (timeFrame in newEvent.getTimeSlots()) {
                            val difference = Duration.between(timeFrame.startTime, timeFrame.endTime).toHours()
                            if (difference in 23..25) {
                                timeFrame.startTime = timeFrame.startTime.with(date)
                                    .withHour(0).withMinute(0).withSecond(0)
                                    .withOffsetSameInstant(originalDate.offset)
                                timeFrame.endTime = timeFrame.endTime.with(date)
                                    .withHour(23).withMinute(59).withSecond(59)
                                    .withOffsetSameInstant(originalDate.offset)
                            }
                        }
                        createEvent(token, newEvent)
                        date = date.plusMonths(interval)
                    }
                }
                "YEARLY" -> {
                    var date = startDate.plusYears(interval)
                    while (!date.isAfter(endDate)) {
                        val newEvent = eventDTO.copy()
                        newEvent.setRecurrence(null)
                        newEvent.setStartTime(newEvent.getStartTime().with(date))
                        newEvent.setEndTime(newEvent.getEndTime().with(date))
                        for (timeFrame in newEvent.getTimeSlots()) {
                            val difference = Duration.between(timeFrame.startTime, timeFrame.endTime).toHours()
                            if (difference in 23..25) {
                                timeFrame.startTime = timeFrame.startTime.with(date)
                                    .withHour(0).withMinute(0).withSecond(0)
                                    .withOffsetSameInstant(originalDate.offset)
                                timeFrame.endTime = timeFrame.endTime.with(date)
                                    .withHour(23).withMinute(59).withSecond(59)
                                    .withOffsetSameInstant(originalDate.offset)
                            }
                        }
                        createEvent(token, newEvent)
                        date = date.plusYears(interval)
                    }
                }
            }

            eventDTO.setRecurrence(null)
        }

        return eventDTO
    }

    private fun anyToPair(any: Any?): Pair<Double, Double> {
        return if (any is Pair<*, *> &&
            any.first is Double &&
            any.second is Double
        ) {
            Pair(any.first as Double, any.second as Double)
        } else {
            Pair(0.0, 0.0)
        }
    }

    fun findEarliestTimeSlot(
        userEvents: List<UserEventDTO>,
        eventDTO: UserEventDTO,
    ): Pair<OffsetDateTime, OffsetDateTime> {
        var currentDateTime = OffsetDateTime.now()
        val eventTimeslots = eventDTO.getTimeSlots()

        val sortedAvailableTimeSlots = eventTimeslots
            .filter {
                it.endTime.isAfter(currentDateTime) &&
                    Duration.between(currentDateTime, it.endTime).seconds >= eventDTO.getDurationInSeconds() &&
                    it.type == TimeBoundaryType.ALLOWED
            }
            .sortedBy { it.startTime }

        val unavailableTimeSlots = eventTimeslots
            .filter {
                it.type == TimeBoundaryType.BLOCKED
            }
            .sortedBy { it.startTime }

        // Add unavailable time slots as events
        val userEventsUpdated = userEvents.toMutableList()
        val unavailableTimeSlotsAsEvents = ArrayList<UserEventDTO>()
        for (unavailableSlot in unavailableTimeSlots) {
            unavailableTimeSlotsAsEvents.add(
                UserEventDTO(
                    id = "",
                    summary = "Unavailable",
                    location = "",
                    startTime = unavailableSlot.startTime,
                    endTime = unavailableSlot.endTime,
                    duration = 0L,
                    timeSlots = listOf(),
                    priority = 0,
                    recurrence = mutableListOf(""),

                ),
            )
        }
        userEventsUpdated.addAll(unavailableTimeSlotsAsEvents)

        val sortedUserEvents = userEventsUpdated.sortedBy { it.getStartTime() }

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
    fun addTimeBoundary(token: String, timeBoundary: TimeBoundary?): Boolean {
        val userJWTTokenData = jwtFunctionality.getUserJWTTokenData(token) ?: return false
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
        val userJWTTokenData = jwtFunctionality.getUserJWTTokenData(token) ?: return false
        val user = userRepository.findById(userJWTTokenData.userID)
        if (name != null && !user.isEmpty) {
            val retrievedUser = user.get()
            for (i in 0 until retrievedUser.getUserTimeBoundaries()!!.size) {
                if (retrievedUser.getUserTimeBoundaries()!![i].getName() == name) {
                    val boundaryToRemove = retrievedUser.getUserTimeBoundaries()!![i]
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
        val userJWTTokenData = jwtFunctionality.getUserJWTTokenData(token) ?: return mutableListOf()
        val user = userRepository.findById(userJWTTokenData.userID)
        if (!user.isEmpty) {
            return user.get().getUserTimeBoundaries()
        }
        return mutableListOf()
    }

    fun getUserTimeBoundaryAndLocation(token: String, name: String?): Pair<TimeBoundary?, String?> {
        val userJWTTokenData = jwtFunctionality.getUserJWTTokenData(token) ?: return Pair(null, null)
        val user = userRepository.findById(userJWTTokenData.userID).get()
        var timeBoundary: TimeBoundary? = null

        if (user != null && name != null) {
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

    fun getUserSuggestions(userID: String): Any {
        val awsCreds = AwsBasicCredentials.create(
            System.getProperty(EnvironmentVariableConstant.KOJA_AWS_DYNAMODB_ACCESS_KEY_ID),
            System.getProperty(EnvironmentVariableConstant.KOJA_AWS_DYNAMODB_ACCESS_KEY_SECRET),
        )

        val dynamoDBClient = DynamoDbClient.builder()
            .region(Region.EU_NORTH_1)
            .credentialsProvider { awsCreds }
            .build()

        val attrValues = mutableMapOf<String, AttributeValue>()
        attrValues[":v_user"] = AttributeValue.builder().s(userID).build()

        val attrNames = mutableMapOf<String, String>()
        attrNames["#n_user"] = "user"

        val request = QueryRequest.builder()
            .tableName("Koja-AI")
            .keyConditionExpression("#n_user = :v_user") // Query for items with matching "userID"
            .expressionAttributeValues(attrValues)
            .expressionAttributeNames(attrNames)
            .build()

        var toReturn: Map<String, List<Map<String, List<String>>>>? = null

        val response = dynamoDBClient.query(request)
        val items = response.items()
        if (items.isNotEmpty()) {
            val userItem = items.firstOrNull()
            if (userItem != null) {
                val recommendations = userItem["recommendations"]?.m()
                if (recommendations != null) {
                    toReturn = recommendations.mapValues { entry ->
                        entry.value.l().map {
                                value ->
                            value.m()["week_days"]?.m()?.mapValues {
                                    attr ->
                                attr.value.l().map {
                                    it.s() ?: ""
                                }
                            } ?: mapOf()
                        }
                    }
                }
            }
        }

        val categoryRequest = QueryRequest.builder()
            .tableName("User-Category-Events")
            .keyConditionExpression("#n_user = :v_user")
            .expressionAttributeValues(attrValues)
            .expressionAttributeNames(attrNames)
            .build()

        var userCategoryEvents = mapOf<String, List<Map<String, Any>>>()

        val categoryResponse = dynamoDBClient.query(categoryRequest)
        val categoryItems = categoryResponse.items()
        if (categoryItems.isNotEmpty()) {
            val userCategoryItem = categoryItems.firstOrNull()
            if (userCategoryItem != null) {
                val categories = userCategoryItem["categories"]?.m()
                if (categories != null) {
                    userCategoryEvents = categories.mapValues { entry ->
                        entry.value.l().map { categoryItem ->
                            categoryItem.m().mapValues { attr ->
                                if (attr.value.type() == AttributeValue.Type.S) {
                                    attr.value.s() ?: ""
                                } else {
                                    attr.value.n() ?: ""
                                }
                            }
                        }
                    }
                }
            }
        }

        val results = toReturn?.let { createPermutations(userCategoryEvents, it) }
        return results ?: emptyList<String>()
    }

    fun createPermutations(userCategoryEvents: Map<String, List<Map<String, Any>>>, toReturn: Map<String, List<Map<String, List<String>>>>): MutableList<MutableList<UserEventDTO>> {
        val categoryPermutations = mutableListOf<UserEventDTO>()

        // For each category
        for ((category, events) in userCategoryEvents) {
            val orderedEvents = events.sortedByDescending { it["occurrence"].toString().toInt() }.map { it }

            // Get days and timeframes for this category
            val daysAndTimeframes = toReturn[category]?.flatMap { it.entries } ?: listOf()

            // Generate permutations
            for ((day, timeframes) in daysAndTimeframes) {
                for (timeframe in timeframes) {
                    for (event in orderedEvents) {
                        val eventNameStr = event["name"].toString()
                        var evenStart = OffsetDateTime.now().withOffsetSameLocal(ZoneOffset.UTC)
                        var eventEnd = OffsetDateTime.now().withOffsetSameLocal(ZoneOffset.UTC)
                        val timeFrameSplit = timeframe.split("-")
                        val startTimeSplit = timeFrameSplit[0].split(":")
                        val avgEventDurr = event["total_time"].toString().toLong() / event["occurrence"].toString().toLong()

                        when (day.lowercase()) {
                            "monday" -> {
                                evenStart = evenStart.with(TemporalAdjusters.next(DayOfWeek.MONDAY))
                                    .withHour(startTimeSplit[0].toInt())
                                    .withMinute(startTimeSplit[1].toInt())
                                eventEnd = evenStart.plusMinutes(avgEventDurr)
                            }
                            "tuesday" -> {
                                evenStart = evenStart.with(TemporalAdjusters.next(DayOfWeek.TUESDAY))
                                    .withHour(startTimeSplit[0].toInt())
                                    .withMinute(startTimeSplit[1].toInt())
                                eventEnd = evenStart.plusMinutes(avgEventDurr)
                            }
                            "wednesday" -> {
                                evenStart = evenStart.with(TemporalAdjusters.next(DayOfWeek.WEDNESDAY))
                                    .withHour(startTimeSplit[0].toInt())
                                    .withMinute(startTimeSplit[1].toInt())
                                eventEnd = evenStart.plusMinutes(avgEventDurr)
                            }
                            "thursday" -> {
                                evenStart = evenStart.with(TemporalAdjusters.next(DayOfWeek.THURSDAY))
                                    .withHour(startTimeSplit[0].toInt())
                                    .withMinute(startTimeSplit[1].toInt())
                                eventEnd = evenStart.plusMinutes(avgEventDurr)
                            }
                            "friday" -> {
                                evenStart = evenStart.with(TemporalAdjusters.next(DayOfWeek.FRIDAY))
                                    .withHour(startTimeSplit[0].toInt())
                                    .withMinute(startTimeSplit[1].toInt())
                                eventEnd = evenStart.plusMinutes(avgEventDurr)
                            }
                            "saturday" -> {
                                evenStart = evenStart.with(TemporalAdjusters.next(DayOfWeek.SATURDAY))
                                    .withHour(startTimeSplit[0].toInt())
                                    .withMinute(startTimeSplit[1].toInt())
                                eventEnd = evenStart.plusMinutes(avgEventDurr)
                            }
                            "sunday" -> {
                                evenStart = evenStart.with(TemporalAdjusters.next(DayOfWeek.SUNDAY))
                                    .withHour(startTimeSplit[0].toInt())
                                    .withMinute(startTimeSplit[1].toInt())
                                eventEnd = evenStart.plusMinutes(avgEventDurr)
                            }
                        }

                        if (evenStart.isAfter(eventEnd)) {
                            val temp = evenStart
                            evenStart = eventEnd
                            eventEnd = temp
                        }

                        val toAdd = UserEventDTO()
                        toAdd.setSummary(eventNameStr)
                        toAdd.setStartTime(startTime = evenStart)
                        toAdd.setEndTime(endTime = eventEnd)

                        categoryPermutations.add(
                            toAdd,
                        )
                    }
                }
            }
        }

        categoryPermutations.shuffle()

        val noClashPermutations = mutableListOf<MutableList<UserEventDTO>>()
        for (event in categoryPermutations) {
            var added = false
            for (list in noClashPermutations) {
                if (!hasClash(list, event) && list.size < 21) {
                    list.add(event)
                    added = true
                    break
                }
            }
            if (!added) {
                val newList = mutableListOf(event)
                noClashPermutations.add(newList)
            }
        }

        for (list in noClashPermutations) {
            if (list.size < 12) {
                for (event in categoryPermutations) {
                    if (!hasClash(list, event)) {
                        list.add(event)
                        if (list.size == 12) break
                    }
                }
            }
        }

        return noClashPermutations.sortedByDescending { it.size }.toMutableList()
    }

    fun hasClash(list: List<UserEventDTO>, event: UserEventDTO): Boolean {
        val potentialStartTime = event.getStartTime()
        val potentialEndTime = event.getEndTime()

        val conflictingEvent = list.find {
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

        return conflictingEvent != null
    }

    fun getAllDynamicUserEvents(token: String): List<UserEventDTO> {
        val userJWTTokenData = jwtFunctionality.getUserJWTTokenData(token)

        val (userAccounts, calendarAdapters) = getUserCalendarAdapters(userJWTTokenData)

        val userEvents = mutableMapOf<String, UserEventDTO>()

        for (adapter in calendarAdapters) {
            val userAccount = userAccounts[calendarAdapters.indexOf(adapter)]
            val userAuthDetails = userJWTTokenData.userAuthDetails
            for (authDetails in userAuthDetails) {
                if (authDetails.getRefreshToken() == userAccount.refreshToken) {
                    val accessToken = authDetails.getAccessToken()
                    userEvents.putAll(adapter.getUserEvents(accessToken))
                }
            }
        }

        val dynamicEvents = mutableMapOf<String, UserEventDTO>()
        for (event in userEvents) {
            if (event.value.isDynamic()) {
                dynamicEvents[event.key] = event.value
            }
        }

        return dynamicEvents.values.toList()
    }

    fun createNewCalendar(accessToken: String, eventList: List<UserEventDTO>) {
        val userJWTTokenData = getUserJWTTokenData(accessToken)
        val (userAccounts, calendarAdapters) = getUserCalendarAdapters(userJWTTokenData)
        for (adapter in calendarAdapters) {
            adapter.createNewCalendar(userAccounts, eventList, accessToken)
        }
    }
}

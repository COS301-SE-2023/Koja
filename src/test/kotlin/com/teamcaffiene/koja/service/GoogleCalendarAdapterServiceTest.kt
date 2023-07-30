package com.teamcaffiene.koja.service

import com.teamcaffeine.koja.dto.UserEventDTO
import com.teamcaffeine.koja.repository.UserAccountRepository
import com.teamcaffeine.koja.repository.UserRepository
import com.teamcaffeine.koja.service.GoogleCalendarAdapterService
import io.github.cdimascio.dotenv.Dotenv
import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.assertThrows
import org.mockito.Mock
import org.mockito.MockitoAnnotations
import org.mockito.kotlin.any
import org.mockito.kotlin.eq
import org.mockito.kotlin.spy
import org.mockito.kotlin.whenever
import java.lang.System.setProperty
import java.time.OffsetDateTime

class GoogleCalendarAdapterServiceTest {
    @Mock
    lateinit var userRepository: UserRepository

    @Mock
    lateinit var userAccountRepository: UserAccountRepository

    private lateinit var service: GoogleCalendarAdapterService
    private lateinit var dotenv: Dotenv

    @BeforeEach
    fun setup() {
        MockitoAnnotations.openMocks(this)

        importEnvironmentVariables()

        service = spy(GoogleCalendarAdapterService(userRepository, userAccountRepository))
    }

    private fun importEnvironmentVariables() {
        dotenv = Dotenv.load()

        dotenv["KOJA_AWS_RDS_DATABASE_URL"]?.let { setProperty("KOJA_AWS_RDS_DATABASE_URL", it) }
        dotenv["KOJA_AWS_RDS_DATABASE_ADMIN_USERNAME"]?.let { setProperty("KOJA_AWS_RDS_DATABASE_ADMIN_USERNAME", it) }
        dotenv["KOJA_AWS_RDS_DATABASE_ADMIN_PASSWORD"]?.let { setProperty("KOJA_AWS_RDS_DATABASE_ADMIN_PASSWORD", it) }

        dotenv["GOOGLE_CLIENT_ID"]?.let { setProperty("GOOGLE_CLIENT_ID", it) }
        dotenv["GOOGLE_CLIENT_SECRET"]?.let { setProperty("GOOGLE_CLIENT_SECRET", it) }
        dotenv["API_KEY"]?.let { setProperty("API_KEY", it) }

        dotenv["KOJA_JWT_SECRET"]?.let { setProperty("KOJA_JWT_SECRET", it) }
    }

    /*
        Scenario 1: Only one location that are in the future
     */
    @Test
    fun testGetFutureEventsLocationsScenario1() {
        val accessToken = "test_token"

        val location1 = "loc1"
        val location2 = "loc2"

        val event1 = UserEventDTO(
            id = "1",
            summary = "desc1",
            location = location1,
            startTime = OffsetDateTime.now().plusDays(2),
            endTime = OffsetDateTime.now().plusDays(2),
            duration = 1,
            timeSlots = emptyList(),
            priority = 1,
            dynamic = false,
            userID = "1",
        )
        val event2 = UserEventDTO(
            id = "2",
            summary = "desc2",
            location = location2,
            startTime = OffsetDateTime.now().minusDays(2),
            endTime = OffsetDateTime.now().minusDays(1),
            duration = 1,
            timeSlots = emptyList(),
            priority = 1,
            dynamic = false,
            userID = "1",
        )

        val mockResponse: List<UserEventDTO> = listOf(event1, event2)

        whenever(service.getUserEventsInRange(eq(accessToken), any<OffsetDateTime>(), any<OffsetDateTime>())).thenReturn(mockResponse)

        val futureEvents = service.getFutureEventsLocations(eq(accessToken))

        assertEquals((listOf(location1)), (futureEvents))
    }

    /*
            Scenario 2: More than one location that are in the future
     */
    @Test
    fun testGetFutureEventsLocationsScenario2() {
        val accessToken = "test_token"

        val location1 = "loc1"
        val location2 = "loc2"

        val event1 = UserEventDTO(
            id = "1",
            summary = "desc1",
            location = location1,
            startTime = OffsetDateTime.now().plusDays(5),
            endTime = OffsetDateTime.now().plusDays(6),
            duration = 1,
            timeSlots = emptyList(),
            priority = 1,
            dynamic = false,
            userID = "1",
        )
        val event2 = UserEventDTO(
            id = "2",
            summary = "desc2",
            location = location2,
            startTime = OffsetDateTime.now().plusDays(2),
            endTime = OffsetDateTime.now().plusDays(3),
            duration = 1,
            timeSlots = emptyList(),
            priority = 1,
            dynamic = false,
            userID = "1",
        )
        val event3 = UserEventDTO(
            id = "3",
            summary = "desc3",
            location = location1,
            startTime = OffsetDateTime.now().minusDays(2),
            endTime = OffsetDateTime.now().minusDays(1),
            duration = 1,
            timeSlots = emptyList(),
            priority = 1,
            dynamic = false,
            userID = "1",
        )
        // Define your mock response

        val mockResponse: List<UserEventDTO> = listOf(event1, event2, event3)

        whenever(service.getUserEventsInRange(eq(accessToken), any<OffsetDateTime>(), any<OffsetDateTime>())).thenReturn(mockResponse)

        val futureEvents = service.getFutureEventsLocations(eq(accessToken))

        assertEquals((listOf(location1, location2)), (futureEvents))
    }

    /*
            Scenario 3: No locations that are in the future
     */
    @Test
    fun testGetFutureEventsLocationsScenario3() {
        val accessToken = "test_token"

        val location1 = "loc1"
        val location2 = "loc2"

        val event1 = UserEventDTO(
            id = "1",
            summary = "desc1",
            location = location1,
            startTime = OffsetDateTime.now().minusDays(2),
            endTime = OffsetDateTime.now().minusDays(1),
            duration = 1,
            timeSlots = emptyList(),
            priority = 1,
            dynamic = false,
            userID = "1",
        )
        val event2 = UserEventDTO(
            id = "2",
            summary = "desc2",
            location = location2,
            startTime = OffsetDateTime.now().minusDays(2),
            endTime = OffsetDateTime.now().minusDays(1),
            duration = 1,
            timeSlots = emptyList(),
            priority = 1,
            dynamic = false,
            userID = "1",
        )
        val event3 = UserEventDTO(
            id = "3",
            summary = "desc3",
            location = location1,
            startTime = OffsetDateTime.now().minusDays(2),
            endTime = OffsetDateTime.now().minusDays(1),
            duration = 1,
            timeSlots = emptyList(),
            priority = 1,
            dynamic = false,
            userID = "1",
        )
        // Define your mock response

        val mockResponse: List<UserEventDTO> = listOf(event1, event2, event3)

        whenever(service.getUserEventsInRange(eq(accessToken), any<OffsetDateTime>(), any<OffsetDateTime>())).thenReturn(mockResponse)

        val futureEvents = service.getFutureEventsLocations(eq(accessToken))

        assertEquals((emptyList<String>()), (futureEvents))
    }

    /*
            Scenario 4: Parameter is null
     */
    @Test
    fun testGetFutureEventsLocationsScenario4() {
        assertThrows<IllegalArgumentException> { service.getFutureEventsLocations(null) }
    }
}

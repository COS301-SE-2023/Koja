package com.teamcaffiene.koja.service

import com.teamcaffeine.koja.controller.TokenManagerController
import com.teamcaffeine.koja.controller.TokenRequest
import com.teamcaffeine.koja.dto.JWTAuthDetailsDTO
import com.teamcaffeine.koja.dto.JWTFunctionality
import com.teamcaffeine.koja.dto.JWTGoogleDTO
import com.teamcaffeine.koja.dto.TimeSlot
import com.teamcaffeine.koja.dto.UserEventDTO
import com.teamcaffeine.koja.dto.UserJWTTokenDataDTO
import com.teamcaffeine.koja.entity.TimeBoundary
import com.teamcaffeine.koja.entity.User
import com.teamcaffeine.koja.entity.UserAccount
import com.teamcaffeine.koja.enums.AuthProviderEnum
import com.teamcaffeine.koja.enums.TimeBoundaryType
import com.teamcaffeine.koja.repository.UserAccountRepository
import com.teamcaffeine.koja.repository.UserRepository
import com.teamcaffeine.koja.service.CalendarAdapterFactoryService
import com.teamcaffeine.koja.service.CalendarAdapterService
import com.teamcaffeine.koja.service.GoogleCalendarAdapterService
import com.teamcaffeine.koja.service.UserCalendarService
import io.github.cdimascio.dotenv.Dotenv
import org.junit.jupiter.api.Assertions
import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.Test
import org.mockito.Mock
import org.mockito.Mockito
import org.mockito.MockitoAnnotations
import org.mockito.invocation.InvocationOnMock
import org.mockito.kotlin.any
import org.mockito.kotlin.check
import org.mockito.kotlin.whenever
import java.time.OffsetDateTime
import java.util.Optional

class UserCalendarServiceTest {

    @Mock
    lateinit var userRepository: UserRepository

    @Mock
    lateinit var userAccountRepository: UserAccountRepository

    @Mock
    private lateinit var jwtFunctionality: JWTFunctionality

    @Mock
    private lateinit var calendarAdapterFactoryService: CalendarAdapterFactoryService

    @Mock
    private lateinit var googleCalendarAdapterService: GoogleCalendarAdapterService

    @Mock
    private lateinit var calendarAdapterService: CalendarAdapterService

    @Mock
    private lateinit var userCalendarService: UserCalendarService
    private lateinit var dotenv: Dotenv

    init {
        importEnvironmentVariables()
    }

    @BeforeEach
    fun setup() {
        MockitoAnnotations.openMocks(this)

        importEnvironmentVariables()
        googleCalendarAdapterService = GoogleCalendarAdapterService(userRepository, userAccountRepository)
        userCalendarService = UserCalendarService(userRepository, jwtFunctionality, userAccountRepository)
    }

    private fun importEnvironmentVariables() {
        dotenv = Dotenv.load()

        dotenv["KOJA_AWS_RDS_DATABASE_URL"]?.let { System.setProperty("KOJA_AWS_RDS_DATABASE_URL", it) }
        dotenv["KOJA_AWS_RDS_DATABASE_ADMIN_USERNAME"]?.let {
            System.setProperty(
                "KOJA_AWS_RDS_DATABASE_ADMIN_USERNAME",
                it,
            )
        }
        dotenv["KOJA_AWS_RDS_DATABASE_ADMIN_PASSWORD"]?.let {
            System.setProperty(
                "KOJA_AWS_RDS_DATABASE_ADMIN_PASSWORD",
                it,
            )
        }

        dotenv["GOOGLE_CLIENT_ID"]?.let { System.setProperty("GOOGLE_CLIENT_ID", it) }
        dotenv["GOOGLE_CLIENT_SECRET"]?.let { System.setProperty("GOOGLE_CLIENT_SECRET", it) }
        dotenv["API_KEY"]?.let { System.setProperty("API_KEY", it) }

        dotenv["KOJA_JWT_SECRET"]?.let { System.setProperty("KOJA_JWT_SECRET", it) }
    }

    /*  @BeforeEach
    fun setup() {
        val dotenv: Dotenv = Dotenv.load()
        System.setProperty("KOJA_JWT_SECRET", dotenv["KOJA_JWT_SECRET"]!!)
        userRepository = mockk()
        userAccountRepository = mockk()
        userCalendarService = UserCalendarService(userRepository)
    }*/

//    @Test
//    fun getAllUserEvents_ReturnsEmptyList_WhenNoUserAccountsFound() {
//        // Arrange
//        val token = "***redacted***"
//        val userJWTTokenDataDTO = UserJWTTokenDataDTO(userID = 123, userAuthDetails = emptyList())
//        every { getUserJWTTokenData(token) } returns userJWTTokenDataDTO
//        every { userAccountRepository.findByUserID(userJWTTokenDataDTO.userID) } returns emptyList()
//
//        // Act
//        val result = userCalendarService.getAllUserEvents(token)
//
//        // Assert
//        assertEquals(emptyList<UserEventDTO>(), result)
//    }

//    @Test
//    fun getAllUserEvents_ReturnsUserEventsFromCalendarAdapters() {
//        val token = "***redacted***"
//        val userJWTTokenDataDTO = UserJWTTokenDataDTO(
//            userID = 123,
//            userAuthDetails = listOf(JWTGoogleDTO(token, "dummyRefresh", 1L))
//        )
//        val userAccount = listOf(UserAccount(123))
//        val calendarAdapterFactoryService = mockk<CalendarAdapterFactoryService>()
//        val calendarAdapterService = mockk<CalendarAdapterService>()
//        val userEvents = arrayListOf<UserEventDTO>()
//
//        every { getUserJWTTokenData(token) } returns userJWTTokenDataDTO
//        every { userAccountRepository.findByUserID(userJWTTokenDataDTO.userID) } returns userAccount
//        every { userCalendarService.getAllUserEvents(token) } returns userEvents
//        every { calendarAdapterFactoryService.createCalendarAdapter(any()) } returns calendarAdapterService
//
//        val result = userCalendarService.getAllUserEvents(token)
//
//        assertEquals(userEvents, result)
//    }
    @Test
    fun `addTimeBoundary should return true when the timeBoundary is valid and user exists`() {
        // Arrange
        val mockUserID = Int.MAX_VALUE
        val userAccounts = mutableListOf<JWTAuthDetailsDTO>()
        val mockUserJWTData = UserJWTTokenDataDTO(userAccounts, mockUserID)
        val authDetails = JWTGoogleDTO("access", "refresh", 60 * 60)
        val jwtToken = TokenManagerController.createToken(
            TokenRequest(
                arrayListOf(authDetails),
                AuthProviderEnum.GOOGLE,
                mockUserID,
            ),
        )

        val timeBoundary = TimeBoundary("Partying", "12:00", "05:00")
        val mockUser = User()
        val optionalUserValue = Optional.of(mockUser)

        whenever(jwtFunctionality.getUserJWTTokenData(jwtToken)).thenReturn(mockUserJWTData)
        whenever(userRepository.findById(mockUserID)).thenReturn(optionalUserValue)
        whenever(userRepository.save(any<User>())).thenAnswer { invocation: InvocationOnMock -> invocation.getArgument<User>(0) }

        // Act
        val result = userCalendarService.addTimeBoundary(jwtToken, timeBoundary)

        // Assert
        Assertions.assertTrue(result)

        // Verify that the time boundary is added to the user and saved in the repository
        Assertions.assertEquals(timeBoundary, mockUser.getUserTimeBoundaries()[0])

        // Verify that the user is saved in the repository
        Mockito.verify(userRepository).save(
            check<User> { savedUser ->
                Assertions.assertEquals(mockUser, savedUser)
                Assertions.assertEquals(timeBoundary, savedUser.getUserTimeBoundaries()[0])
            },
        )
    }

    @Test
    fun `addTimeBoundary should return false when the timeBoundary is null`() {
        // Arrange
        val mockUserID = Int.MAX_VALUE
        val userAccounts = mutableListOf<JWTAuthDetailsDTO>()
        val mockUserJWTData = UserJWTTokenDataDTO(userAccounts, mockUserID)
        val authDetails = JWTGoogleDTO("access", "refresh", 60 * 60)
        val jwtToken = TokenManagerController.createToken(
            TokenRequest(
                arrayListOf(authDetails),
                AuthProviderEnum.GOOGLE,
                mockUserID,
            ),
        )

        val timeBoundary = null
        val mockUser = User()
        val optionalUserValue = Optional.of(mockUser)

        // mock
        whenever(jwtFunctionality.getUserJWTTokenData(jwtToken)).thenReturn(mockUserJWTData)
        whenever(userRepository.findById(mockUserID)).thenReturn(optionalUserValue)
        whenever(userRepository.save(any<User>())).thenAnswer { invocation: InvocationOnMock -> invocation.getArgument<User>(0) }

        // Act
        val result = userCalendarService.addTimeBoundary(jwtToken, timeBoundary)

        // Assert
        Assertions.assertFalse(result)
        Mockito.verify(userRepository, Mockito.never()).save(Mockito.any(User::class.java))
    }

    @Test
    fun `addTimeBoundary should return false when the user does not exist`() {
        // Arrange
        val mockUserID = Int.MAX_VALUE
        val userAccounts = mutableListOf<JWTAuthDetailsDTO>()
        val mockUserJWTData = UserJWTTokenDataDTO(userAccounts, mockUserID)
        val authDetails = JWTGoogleDTO("access", "refresh", 60 * 60)
        val jwtToken = TokenManagerController.createToken(
            TokenRequest(
                arrayListOf(authDetails),
                AuthProviderEnum.GOOGLE,
                mockUserID,
            ),
        )
        //  val jwtToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJlbmNyeXB0ZWQiOiIrT09EZXlqWk1CWjV6b3I1OFRBdVZIT2x3akJvbHY1MGFkTjQ5ajdFMWMweW9TWW9zOTNHMUVWT0ord3Z2dGFLQ1RBbE43TzB1Z3crZm1JUmxGZ25jb3EyUHcxRHc2S2RQMVcydnRFWGdIMlFOTFRLSk1sTGkwOGsrWmtsbzRVM1pTcllJb3hzaFVvSk5YU1lnMmQ2K2tRWUpNUEt3MS9ndi9JWjA4U3BHWnpNM3lJaWFlQUt0UFgwZGVQWUlOSk1ZMm1iTlhnZVVIei9Bb3NtWUthNEY3MmlkSEgra0M4N2x6T1ROcU1mSnVCNHRadE40OVJCVlVxQ0JOQ3VrQzNjOUd6NHB3SHVkVVpnbjVnaXFPaXNDNCtSUXo3Uk9EN2I4R2YzdHpJMDZhR2ZURnZld05QSTFPT3JKb3JELzd2bDVHNEtScU1rZDFJaUlKNmd3SUFZanh5bHh2ck0vUHIvUngyWTdOcmRneTBHNHhXMGZjenkzUDhoQmhsYkNSOGFMVEdZdXF0dVdNOUNTMWJmY2hMS2E4UzBvR1pycVR0ak42QzdBOENEZVNHN29VR1ZKOUViSlBLaDVQMlpxVEpKWFlOYWVUclZEQkMxQkxPQ01JeE9QdU1DTWdreHczNWp2bFkyMmFDcUdFZHRJTy9UOXJIMjl4RWJHQUlXeUQvcjNTaW9KT1d2ZzJvd3B5NExKSitTZWVaVjU4UEtCL2wrVFZzTmZBRzB3Vlk2azMxNFk5R2xTbTROUVcyNFRyeDhja01FdHg1eFE1RHhBS0NOWnBXN2pnPT0iLCJleHAiOjE2ODk3MTY5MDR9.uctphVFxJICf8OexH0ZQHWONI3rTExoyDvdAlMdxMGUQaLjGmONyyt6sGP2wn2DUUtW9M1Mg-kbelZpU-zPgbQ"

        val timeBoundary = TimeBoundary()

        // mock
        whenever(jwtFunctionality.getUserJWTTokenData(jwtToken)).thenReturn(mockUserJWTData)
        whenever(userRepository.findById(mockUserID)).thenReturn(Optional.empty())
        whenever(userRepository.save(any<User>())).thenAnswer { invocation: InvocationOnMock -> invocation.getArgument<User>(0) }

        // Act
        val result = userCalendarService.addTimeBoundary(jwtToken, timeBoundary)

        // Assert
        Assertions.assertFalse(result)
        Mockito.verify(userRepository, Mockito.never()).save(Mockito.any(User::class.java))
    }

    @Test
    fun `removeTimeBoundary should return true when the name is valid and user exists`() {
        // Arrange
        val mockUserID = Int.MAX_VALUE
        val userAccounts = mutableListOf<JWTAuthDetailsDTO>()
        val mockUserJWTData = UserJWTTokenDataDTO(userAccounts, mockUserID)
        val authDetails = JWTGoogleDTO("access", "refresh", 60 * 60)
        val jwtToken = TokenManagerController.createToken(
            TokenRequest(
                arrayListOf(authDetails),
                AuthProviderEnum.GOOGLE,
                mockUserID,
            ),
        )

        val timeBoundary1 = TimeBoundary("TimeBoundary1")
        val timeBoundary2 = TimeBoundary("TimeBoundary2")
        val mockUser = User()
        mockUser.addTimeBoundary(timeBoundary1)
        mockUser.addTimeBoundary(timeBoundary2)
        val optionalUserValue = Optional.of(mockUser)

        // mock
        whenever(jwtFunctionality.getUserJWTTokenData(jwtToken)).thenReturn(mockUserJWTData)
        whenever(userRepository.findById(mockUserID)).thenReturn(optionalUserValue)
        whenever(userRepository.save(any<User>())).thenAnswer { invocation: InvocationOnMock -> invocation.getArgument<User>(0) }

        // Act
        val result = userCalendarService.removeTimeBoundary(jwtToken, timeBoundary1.getName())

        // Assert
        Assertions.assertTrue(result)
        Assertions.assertNull(timeBoundary1.user)
        Assertions.assertEquals(1, mockUser.getUserTimeBoundaries().size)
        Mockito.verify(userRepository).save(mockUser)
    }

    @Test
    fun `removeTimeBoundary should return false when the name is null`() {
        // Arrange
        val mockUserID = Int.MAX_VALUE
        val userAccounts = mutableListOf<JWTAuthDetailsDTO>()
        val mockUserJWTData = UserJWTTokenDataDTO(userAccounts, mockUserID)
        val authDetails = JWTGoogleDTO("access", "refresh", 60 * 60)
        val jwtToken = TokenManagerController.createToken(
            TokenRequest(
                arrayListOf(authDetails),
                AuthProviderEnum.GOOGLE,
                mockUserID,
            ),
        )

        val timeBoundary1 = TimeBoundary("TimeBoundary1")
        val timeBoundary2 = TimeBoundary("TimeBoundary2")
        val mockUser = User()
        mockUser.addTimeBoundary(timeBoundary1)
        mockUser.addTimeBoundary(timeBoundary2)
        val optionalUserValue = Optional.of(mockUser)

        // mock
        whenever(jwtFunctionality.getUserJWTTokenData(jwtToken)).thenReturn(mockUserJWTData)
        whenever(userRepository.findById(mockUserID)).thenReturn(optionalUserValue)
        whenever(userRepository.save(any<User>())).thenAnswer { invocation: InvocationOnMock -> invocation.getArgument<User>(0) }

        // Act
        val result = userCalendarService.removeTimeBoundary(jwtToken, null)

        // Assert
        Assertions.assertFalse(result)
        Mockito.verify(userRepository, Mockito.never()).save(Mockito.any(User::class.java))
    }

    @Test
    fun `removeTimeBoundary should return false when the user does not exist`() {
        // Arrange
        val mockUserID = Int.MAX_VALUE
        val userAccounts = mutableListOf<JWTAuthDetailsDTO>()
        val mockUserJWTData = UserJWTTokenDataDTO(userAccounts, mockUserID)
        val authDetails = JWTGoogleDTO("access", "refresh", 60 * 60)
        val jwtToken = TokenManagerController.createToken(
            TokenRequest(
                arrayListOf(authDetails),
                AuthProviderEnum.GOOGLE,
                mockUserID,
            ),
        )

        val timeBoundary1 = TimeBoundary("TimeBoundary1")
        val timeBoundary2 = TimeBoundary("TimeBoundary2")
        val mockUser = User()
        mockUser.addTimeBoundary(timeBoundary1)
        mockUser.addTimeBoundary(timeBoundary2)
        val optionalUserValue = Optional.of(mockUser)

        // mock
        whenever(jwtFunctionality.getUserJWTTokenData(jwtToken)).thenReturn(mockUserJWTData)
        whenever(userRepository.findById(mockUserID)).thenReturn(Optional.empty())
        whenever(userRepository.save(any<User>())).thenAnswer { invocation: InvocationOnMock -> invocation.getArgument<User>(0) }

        // Act
        val result = userCalendarService.removeTimeBoundary(jwtToken, timeBoundary1.getName())

        // Assert
        Assertions.assertFalse(result)
        Mockito.verify(userRepository, Mockito.never()).save(Mockito.any(User::class.java))
    }

    @Test
    fun `getUserTimeBoundaries should return user's time boundaries when user exists`() {
        // Arrange
        val mockUserID = Int.MAX_VALUE
        val userAccounts = mutableListOf<JWTAuthDetailsDTO>()
        val mockUserJWTData = UserJWTTokenDataDTO(userAccounts, mockUserID)
        val authDetails = JWTGoogleDTO("access", "refresh", 60 * 60)
        val jwtToken = TokenManagerController.createToken(
            TokenRequest(
                arrayListOf(authDetails),
                AuthProviderEnum.GOOGLE,
                mockUserID,
            ),
        )

        val timeBoundary1 = TimeBoundary("TimeBoundary1")
        val timeBoundary2 = TimeBoundary("TimeBoundary2")
        val mockUser = User()
        mockUser.addTimeBoundary(timeBoundary1)
        mockUser.addTimeBoundary(timeBoundary2)
        val optionalUserValue = Optional.of(mockUser)

        // mock
        whenever(jwtFunctionality.getUserJWTTokenData(jwtToken)).thenReturn(mockUserJWTData)
        whenever(userRepository.findById(mockUserID)).thenReturn(optionalUserValue)

        val timeBoundaries = mutableListOf(
            timeBoundary1,
            timeBoundary2,
        )
        // Act
        val result = userCalendarService.getUserTimeBoundaries(jwtToken)

        // Assert
        Assertions.assertEquals(timeBoundaries, result)
    }

    @Test
    fun `getUserTimeBoundaries should return an empty list when user does not exist`() {
        // Arrange
        val mockUserID = Int.MAX_VALUE
        val userAccounts = mutableListOf<JWTAuthDetailsDTO>()
        val mockUserJWTData = UserJWTTokenDataDTO(userAccounts, mockUserID)
        val authDetails = JWTGoogleDTO("access", "refresh", 60 * 60)
        val jwtToken = TokenManagerController.createToken(
            TokenRequest(
                arrayListOf(authDetails),
                AuthProviderEnum.GOOGLE,
                mockUserID,
            ),
        )

        val timeBoundary1 = TimeBoundary("TimeBoundary1")
        val timeBoundary2 = TimeBoundary("TimeBoundary2")
        val mockUser = User()
        mockUser.addTimeBoundary(timeBoundary1)
        mockUser.addTimeBoundary(timeBoundary2)

        // mock
        whenever(jwtFunctionality.getUserJWTTokenData(jwtToken)).thenReturn(mockUserJWTData)
        whenever(userRepository.findById(mockUserID)).thenReturn(Optional.empty())

        // Act
        val result = userCalendarService.getUserTimeBoundaries(jwtToken)

        // Assert
        Assertions.assertTrue(result.isEmpty())
    }

    @Test
    fun `test getAllUserEvents`() {
        // Mock necessary dependencies and objects
        val mockUserID = Int.MAX_VALUE
        val userAccountList = mutableListOf<JWTAuthDetailsDTO>()
        val userEvents = mutableMapOf<String, UserEventDTO>()
        val userAccount = UserAccount()
        userAccount.authProvider = AuthProviderEnum.GOOGLE
        val (userAccounts, calendarAdapters) = Pair(listOf(userAccount), ArrayList<CalendarAdapterService>())
        val accessToken = "your_access_token"
        val mockUserJWTData = UserJWTTokenDataDTO(userAccountList, mockUserID)

        // Mock necessary method calls
        whenever(jwtFunctionality.getUserJWTTokenData(accessToken)).thenReturn(mockUserJWTData)

        // Call the function to test
        val result = userCalendarService.getAllUserEvents(accessToken)

        // Assert the result
        assertEquals(userEvents.values.toList(), result)
    }

    @Test
    fun `test getUserCalendarAdapters with no adapter`() {
        // Mock necessary dependencies and objects
        val mockUserID = Int.MAX_VALUE
        val userAccountList = mutableListOf<JWTAuthDetailsDTO>()
        val userAccounts = listOf<UserAccount>()
        val calendarAdapters = ArrayList<CalendarAdapterService>()

        val mockUserJWTData = UserJWTTokenDataDTO(userAccountList, mockUserID)
        val authDetails = JWTGoogleDTO("access", "refresh", 60 * 60)
        val jwtToken = TokenManagerController.createToken(
            TokenRequest(
                arrayListOf(authDetails),
                AuthProviderEnum.GOOGLE,
                mockUserID,
            ),
        )
        // Mock necessary method calls
        whenever(userAccountRepository.findByUserID(mockUserID)).thenReturn(userAccounts)
        whenever(calendarAdapterFactoryService.createCalendarAdapter(AuthProviderEnum.GOOGLE)).thenReturn(googleCalendarAdapterService)
        // Call the function to test
        val result = userCalendarService.getUserCalendarAdapters(mockUserJWTData)

        // Assert the result
        assertEquals(Pair(userAccounts, calendarAdapters), result)
    }

    @Test
    fun `test getUserCalendarAdapters with adapters`() {
        // Mock necessary dependencies and objects
        val mockUserID = Int.MAX_VALUE
        val userAccountList = mutableListOf<JWTAuthDetailsDTO>()
        val account = UserAccount()
        account.authProvider = AuthProviderEnum.GOOGLE
        val userAccounts = listOf(account)
        val calendarAdapters = ArrayList<CalendarAdapterService>()

        val mockUserJWTData = UserJWTTokenDataDTO(userAccountList, mockUserID)
        val authDetails = JWTGoogleDTO("access", "refresh", 60 * 60)
        val jwtToken = TokenManagerController.createToken(
            TokenRequest(
                arrayListOf(authDetails),
                AuthProviderEnum.GOOGLE,
                mockUserID,
            ),
        )
        // Mock necessary method calls
        whenever(userAccountRepository.findByUserID(mockUserID)).thenReturn(userAccounts)
        whenever(calendarAdapterFactoryService.createCalendarAdapter(AuthProviderEnum.GOOGLE)).thenReturn(googleCalendarAdapterService)
        // Call the function to test
        val result = userCalendarService.getUserCalendarAdapters(mockUserJWTData)

        // Assert the result
        assertEquals(userAccounts.get(0).authProvider, result.first.get(0).authProvider)
    }

    @Test
    fun `test updateEvent should return true if event is updated successfully`() {
        val token = "your_access_token"
        val event1 = UserEventDTO(
            id = "1",
            summary = "desc1",
            location = "",
            startTime = OffsetDateTime.now().plusDays(2),
            endTime = OffsetDateTime.now().plusDays(2),
            duration = 1,
            timeSlots = emptyList(),
            priority = 1,
            dynamic = false,
            userID = "1",
        )
        val mockUserID = Int.MAX_VALUE
        val userAccountList = mutableListOf<JWTAuthDetailsDTO>()
        val userAccount = UserAccount()
        userAccount.authProvider = AuthProviderEnum.GOOGLE
        userAccount.refreshToken = "refresh"
        val mockUserJWTData = UserJWTTokenDataDTO(userAccountList, mockUserID)
        whenever(jwtFunctionality.getUserJWTTokenData(token)).thenReturn(mockUserJWTData)
        whenever(calendarAdapterService.updateEvent(token, event1)).thenReturn(null)
        val result = userCalendarService.updateEvent(token, event1)

        assertEquals(true, result)
    }

    @Test
    fun `test updateEvent should return false if event is not updated`() {
        val token = "your_access_token"
        val event1 = UserEventDTO(
            id = "1",
            summary = "desc1",
            location = "",
            startTime = OffsetDateTime.now().plusDays(2),
            endTime = OffsetDateTime.now().plusDays(2),
            duration = 1,
            timeSlots = emptyList(),
            priority = 1,
            dynamic = false,
            userID = "1",
        )
        val mockUserID = Int.MAX_VALUE
        val userAccountz = mutableListOf<JWTAuthDetailsDTO>()
        val authDetails = JWTGoogleDTO("access", "refresh", 60 * 60)
        val jwtToken = TokenManagerController.createToken(
            TokenRequest(
                arrayListOf(authDetails),
                AuthProviderEnum.GOOGLE,
                mockUserID,
            ),
        )
        val mockUserJWTData = UserJWTTokenDataDTO(userAccountz, mockUserID)

        whenever(jwtFunctionality.getUserJWTTokenData(token)).thenReturn(mockUserJWTData)
        whenever(calendarAdapterService.updateEvent(token, event1)).thenReturn(null)

        val result = userCalendarService.updateEvent(token, event1)

        assertEquals(false, result)
    }

    @Test
    fun testAnyToPairWithValidInput() {
        // Arrange
        val validPair: Pair<Double, Double> = Pair(1.0, 2.0)

        // Act
        val result = userCalendarService.anyToPair(validPair)

        // Assert
        assertEquals(Pair(1.0, 2.0), result)
    }

    @Test
    fun testFindEarliestTimeSlotWithValidInput() {
        // Arrange
        val currentDateTime = OffsetDateTime.now()
        val timeSlot1 = TimeSlot(
            name = "Example Time Slot",
            startTime = OffsetDateTime.now(),
            endTime = OffsetDateTime.now().plusHours(1),
            type = TimeBoundaryType.ALLOWED,
        )
        val event1 = UserEventDTO(
            id = "1",
            summary = "desc1",
            location = "",
            startTime = OffsetDateTime.now().plusDays(2),
            endTime = OffsetDateTime.now().plusDays(2),
            duration = 1,
            timeSlots = listOf(timeSlot1),
            priority = 1,
            dynamic = false,
            userID = "1",
        )

        val timeSlot2 = TimeSlot(
            name = "Example Time Slot",
            startTime = OffsetDateTime.now(),
            endTime = OffsetDateTime.now().plusHours(1),
            type = TimeBoundaryType.BLOCKED,
        )
        val event2 = UserEventDTO(
            id = "1",
            summary = "desc1",
            location = "",
            startTime = OffsetDateTime.now().plusDays(3),
            endTime = OffsetDateTime.now().plusDays(3),
            duration = 1,
            timeSlots = listOf(timeSlot2),
            priority = 1,
            dynamic = false,
            userID = "1",
        )
        val userEvents = listOf(event1, event2)

        // Act
        val result = userCalendarService.findEarliestTimeSlot(userEvents, event1)

        // Assert
        // Add assertions to verify the expected behavior with valid input
    }
}

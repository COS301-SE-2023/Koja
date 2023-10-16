package com.teamcaffiene.koja.service

import com.teamcaffeine.koja.constants.EnvironmentVariableConstant
import com.teamcaffeine.koja.controller.TokenManagerController
import com.teamcaffeine.koja.controller.TokenRequest
import com.teamcaffeine.koja.dto.JWTAuthDetailsDTO
import com.teamcaffeine.koja.dto.JWTFunctionality
import com.teamcaffeine.koja.dto.JWTGoogleDTO
import com.teamcaffeine.koja.dto.UserJWTTokenDataDTO
import com.teamcaffeine.koja.entity.TimeBoundary
import com.teamcaffeine.koja.entity.User
import com.teamcaffeine.koja.enums.AuthProviderEnum
import com.teamcaffeine.koja.repository.UserAccountRepository
import com.teamcaffeine.koja.repository.UserRepository
import com.teamcaffeine.koja.service.UserCalendarService
import io.github.cdimascio.dotenv.Dotenv
import org.junit.jupiter.api.Assertions
import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.assertThrows
import org.mockito.Mock
import org.mockito.Mockito
import org.mockito.MockitoAnnotations
import org.mockito.invocation.InvocationOnMock
import org.mockito.kotlin.any
import org.mockito.kotlin.check
import org.mockito.kotlin.eq
import org.mockito.kotlin.spy
import org.mockito.kotlin.whenever
import java.util.Optional

class UserCalendarServiceTest {

    @Mock
    lateinit var userRepository: UserRepository

    @Mock
    private lateinit var userAccountRepository: UserAccountRepository

    @Mock
    private lateinit var jwtFunctionality: JWTFunctionality

    private lateinit var userCalendarService: UserCalendarService
    private lateinit var dotenv: Dotenv

    init {
        importEnvironmentVariables()
    }

    @BeforeEach
    fun setup() {
        MockitoAnnotations.openMocks(this)

        importEnvironmentVariables()

        userCalendarService = spy(UserCalendarService(userRepository, jwtFunctionality))
    }

    private fun importEnvironmentVariables() {
        val dotenv: Dotenv = Dotenv.load()

        System.setProperty(
            EnvironmentVariableConstant.KOJA_AWS_RDS_DATABASE_URL,
            dotenv[EnvironmentVariableConstant.KOJA_AWS_RDS_DATABASE_URL]!!,
        )
        System.setProperty(
            EnvironmentVariableConstant.KOJA_AWS_RDS_DATABASE_ADMIN_USERNAME,
            dotenv[EnvironmentVariableConstant.KOJA_AWS_RDS_DATABASE_ADMIN_USERNAME]!!,
        )
        System.setProperty(
            EnvironmentVariableConstant.KOJA_AWS_RDS_DATABASE_ADMIN_PASSWORD,
            dotenv[EnvironmentVariableConstant.KOJA_AWS_RDS_DATABASE_ADMIN_PASSWORD]!!,
        )
        System.setProperty(
            EnvironmentVariableConstant.KOJA_AWS_DYNAMODB_ACCESS_KEY_ID,
            dotenv[EnvironmentVariableConstant.KOJA_AWS_DYNAMODB_ACCESS_KEY_ID]!!,
        )
        System.setProperty(
            EnvironmentVariableConstant.KOJA_AWS_DYNAMODB_ACCESS_KEY_SECRET,
            dotenv[EnvironmentVariableConstant.KOJA_AWS_DYNAMODB_ACCESS_KEY_SECRET]!!,
        )
        System.setProperty(
            EnvironmentVariableConstant.OPENAI_API_KEY,
            dotenv[EnvironmentVariableConstant.OPENAI_API_KEY]!!,
        )
        System.setProperty(
            EnvironmentVariableConstant.SERVER_ADDRESS,
            dotenv[EnvironmentVariableConstant.SERVER_ADDRESS]!!,
        )
        System.setProperty(
            EnvironmentVariableConstant.SERVER_PORT,
            dotenv[EnvironmentVariableConstant.SERVER_PORT] ?: "",
        )
        // Set Google Sign In client ID and client secret properties
        System.setProperty(
            EnvironmentVariableConstant.GOOGLE_CLIENT_ID,
            dotenv[EnvironmentVariableConstant.GOOGLE_CLIENT_ID]!!,
        )
        System.setProperty(
            EnvironmentVariableConstant.GOOGLE_CLIENT_SECRET,
            dotenv[EnvironmentVariableConstant.GOOGLE_CLIENT_SECRET]!!,
        )
        System.setProperty(
            EnvironmentVariableConstant.GOOGLE_MAPS_API_KEY,
            dotenv[EnvironmentVariableConstant.GOOGLE_MAPS_API_KEY]!!,
        )
        // Set JWT secret key and other related properties
        System.setProperty(
            EnvironmentVariableConstant.KOJA_JWT_SECRET,
            dotenv[EnvironmentVariableConstant.KOJA_JWT_SECRET]!!,
        )
        System.setProperty(
            EnvironmentVariableConstant.KOJA_ID_SECRET,
            dotenv[EnvironmentVariableConstant.KOJA_ID_SECRET]!!,
        )
        System.setProperty(
            EnvironmentVariableConstant.KOJA_PRIVATE_KEY_PASS,
            dotenv[EnvironmentVariableConstant.KOJA_PRIVATE_KEY_PASS]!!,
        )
        System.setProperty(
            EnvironmentVariableConstant.KOJA_PRIVATE_KEY_SALT,
            dotenv[EnvironmentVariableConstant.KOJA_PRIVATE_KEY_SALT]!!,
        )
    }

//    @BeforeEach
//    fun setup() {
//        val dotenv: Dotenv = Dotenv.load()
//        System.setProperty(
//            EnvironmentVariableConstant.KOJA_JWT_SECRET,
//            dotenv[EnvironmentVariableConstant.KOJA_JWT_SECRET]!!
//        )
//
//        userRepository = mockk()
//        userAccountRepository = mockk()
//        userCalendarService = UserCalendarService(userRepository)
//    }

    @Test
    fun getAllUserEvents_with_null_token_throws_exception() {
        // Arrange
        val mockUserID = 1
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
        val tokenT = "mockToken"
        MockitoAnnotations.openMocks(this)
        whenever(jwtFunctionality.getUserJWTTokenData(eq(jwtToken))).thenReturn(mockUserJWTData)
        whenever(userAccountRepository.findByUserID(mockUserID)).thenReturn(emptyList())

        // Assert
        assertThrows<Exception> { userCalendarService.getAllUserEvents(eq(jwtToken)) }
    }

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
}

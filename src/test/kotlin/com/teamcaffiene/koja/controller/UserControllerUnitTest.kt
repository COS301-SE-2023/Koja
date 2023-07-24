package com.teamcaffiene.koja.controller

import com.teamcaffeine.koja.constants.ResponseConstant
import com.teamcaffeine.koja.controller.TokenManagerController.Companion.createToken
import com.teamcaffeine.koja.controller.TokenRequest
import com.teamcaffeine.koja.controller.UserController
import com.teamcaffeine.koja.dto.JWTGoogleDTO
import com.teamcaffeine.koja.entity.UserAccount
import com.teamcaffeine.koja.enums.AuthProviderEnum
import com.teamcaffeine.koja.repository.UserAccountRepository
import io.github.cdimascio.dotenv.Dotenv
import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.Test
import org.mockito.Mock
import org.mockito.Mockito
import org.mockito.MockitoAnnotations
import org.mockito.kotlin.eq
import org.mockito.kotlin.whenever
import org.springframework.http.ResponseEntity

class UserControllerUnitTest {
    private lateinit var userController: UserController
    private lateinit var dotenv: Dotenv

    @Mock
    private lateinit var userAccountRepository: UserAccountRepository

    @BeforeEach
    fun setup() {
        MockitoAnnotations.openMocks(this)
        importEnvironmentVariables()
        userController = UserController()
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

    /**
     * Get User Email Scenario1: User has one linked email
     */
    @Test
    fun testGetUserEmailsScenario1() {
        val mockUserID = Int.MAX_VALUE
        val authDetails = JWTGoogleDTO("access", "refresh", 60 * 60)
        val mockToken = createToken(TokenRequest(arrayListOf(authDetails), AuthProviderEnum.GOOGLE, mockUserID))

        val userAccount = UserAccount(id = 1, email = "test@test.com", refreshToken = "refresh", authProvider = AuthProviderEnum.GOOGLE, userID = mockUserID)
        val userAccounts = listOf(userAccount)

        whenever(userAccountRepository.findByUserID(eq(mockUserID))).thenReturn(userAccounts)

        val result = userController.getUserEmails(mockToken)

        assertEquals(result, ResponseEntity.ok(userAccounts.map { it.email }))
    }

    /**
     * Get User Email Scenario2: User has more than one linked email
     */
    @Test
    fun testGetUserEmailsScenario2() {
        val mockUserID = Int.MAX_VALUE
        val authDetails = JWTGoogleDTO("access", "refresh", 60 * 60)
        val mockToken = createToken(TokenRequest(arrayListOf(authDetails), AuthProviderEnum.GOOGLE, mockUserID))

        val userAccount1 = UserAccount(id = 1, email = "test@test.com", refreshToken = "refresh", authProvider = AuthProviderEnum.GOOGLE, userID = mockUserID)
        val userAccount2 = UserAccount(id = 1, email = "test@test.com", refreshToken = "refresh", authProvider = AuthProviderEnum.GOOGLE, userID = mockUserID)
        val userAccount3 = UserAccount(id = 1, email = "test@test.com", refreshToken = "refresh", authProvider = AuthProviderEnum.GOOGLE, userID = mockUserID)
        val userAccount4 = UserAccount(id = 1, email = "test@test.com", refreshToken = "refresh", authProvider = AuthProviderEnum.GOOGLE, userID = mockUserID)
        val userAccounts = listOf(userAccount1, userAccount2, userAccount3, userAccount4)

        whenever(userAccountRepository.findByUserID(eq(mockUserID))).thenReturn(userAccounts)

        val result = userController.getUserEmails(mockToken)

        assertEquals(result, ResponseEntity.ok(userAccounts.map { it.email }))
    }

    /**
     * Get User Email Scenario3: Request made without token
     */
    @Test
    fun testGetUserEmailsScenario3() {
        val result = userController.getUserEmails(null)

        assertEquals(result, ResponseEntity.badRequest().body(listOf(ResponseConstant.REQUIRED_PARAMETERS_NOT_SET)))
    }

    /**
     * Delete User Account Scenario1: Request made to delete user account
     */
    @Test
    fun testDeleteUserAccountScenario1() {
        val mockUserID = Int.MAX_VALUE
        val authDetails = JWTGoogleDTO("access", "refresh", 60 * 60)
        val mockToken = createToken(TokenRequest(arrayListOf(authDetails), AuthProviderEnum.GOOGLE, mockUserID))

        val userAccount = UserAccount(id = 1, email = "test@test.com", refreshToken = "refresh", authProvider = AuthProviderEnum.GOOGLE, userID = mockUserID)
        val userAccounts = listOf(userAccount)

        whenever(userAccountRepository.findByUserID(eq(mockUserID))).thenReturn(userAccounts)

        val result = userController.deleteUserAccount(mockToken)

        assertEquals(result, ResponseEntity.ok(ResponseConstant.ACCOUNT_DELETED))
        Mockito.verify(userAccountRepository).delete(userAccount)
    }

    /**
     * Delete User Account Scenario2: Request made to delete user account without token
     */
    @Test
    fun testDeleteUserAccountScenario2() {
        val result = userController.deleteUserAccount(null)

        assertEquals(result, ResponseEntity.badRequest().body(ResponseConstant.REQUIRED_PARAMETERS_NOT_SET))
    }
}

/* package com.teamcaffiene.koja.service

import com.teamcaffeine.koja.controller.TokenManagerController
import com.teamcaffeine.koja.controller.TokenRequest
import com.teamcaffeine.koja.dto.JWTGoogleDTO
import com.teamcaffeine.koja.entity.UserAccount
import com.teamcaffeine.koja.enums.AuthProviderEnum
import com.teamcaffeine.koja.repository.UserAccountRepository
import com.teamcaffeine.koja.repository.UserRepository
import io.github.cdimascio.dotenv.Dotenv
import org.junit.jupiter.api.Assertions
import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.Test
import org.mockito.Mock
import org.mockito.Mockito
import org.mockito.MockitoAnnotations

class UserAccountManagerServiceTest {
    private lateinit var userAccountManagerService: UserAccountManagerService
    private lateinit var dotenv: Dotenv

    @Mock
    private lateinit var userAccountRepository: UserAccountRepository

    @Mock
    private lateinit var userRepository: UserRepository

    @BeforeEach
    fun setup() {
        MockitoAnnotations.openMocks(this)
        importEnvironmentVariables()
        userAccountManagerService = UserAccountManagerService(userAccountRepository, userRepository)
    }

    private fun importEnvironmentVariables() {
        dotenv = Dotenv.load()

        dotenv[EnvironmentVariableConstant.KOJA_AWS_RDS_DATABASE_URL]?.let {
            System.setProperty(EnvironmentVariableConstant.KOJA_AWS_RDS_DATABASE_URL, it)
        }
        dotenv[EnvironmentVariableConstant.KOJA_AWS_RDS_DATABASE_ADMIN_USERNAME]?.let {
            System.setProperty(EnvironmentVariableConstant.KOJA_AWS_RDS_DATABASE_ADMIN_USERNAME, it)
        }
        dotenv[EnvironmentVariableConstant.KOJA_AWS_RDS_DATABASE_ADMIN_PASSWORD]?.let {
            System.setProperty(EnvironmentVariableConstant.KOJA_AWS_RDS_DATABASE_ADMIN_PASSWORD, it)
        }

        dotenv[EnvironmentVariableConstant.GOOGLE_CLIENT_ID]?.let {
            System.setProperty(EnvironmentVariableConstant.GOOGLE_CLIENT_ID, it)
        }
        dotenv[EnvironmentVariableConstant.GOOGLE_CLIENT_SECRET]?.let {
            System.setProperty(EnvironmentVariableConstant.GOOGLE_CLIENT_SECRET, it)
        }
        dotenv[EnvironmentVariableConstant.GOOGLE_MAPS_API_KEY]?.let {
            System.setProperty(EnvironmentVariableConstant.GOOGLE_MAPS_API_KEY, it)
        }

        dotenv[EnvironmentVariableConstant.KOJA_JWT_SECRET]?.let {
            System.setProperty(EnvironmentVariableConstant.KOJA_JWT_SECRET, it)
        }
    }

    @Test
    fun `deleteGoogleAccount should delete the correct user account`() {

        val mockUserID = Int.MAX_VALUE
        val authDetails = JWTGoogleDTO("access", "refresh", 60 * 60)
        val mockToken = TokenManagerController.createToken(
            TokenRequest(
                arrayListOf(authDetails),
                AuthProviderEnum.GOOGLE,
                mockUserID
            )
        )
        val emailToDelete = "test2@test.com"

        val userAccount1 = UserAccount(id = 1, email = "test1@test.com", refreshToken = "refresh", authProvider = AuthProviderEnum.GOOGLE, userID = mockUserID)
        val userAccount2 = UserAccount(id = 2, email = "test2@test.com", refreshToken = "refresh", authProvider = AuthProviderEnum.GOOGLE, userID = mockUserID)
        val userAccounts = listOf(userAccount1, userAccount2)

        Mockito.`when`(userAccountRepository.findByUserID(mockUserID)).thenReturn(userAccounts)

        userAccountManagerService.deleteGoogleAccount(mockToken, emailToDelete)

        Assertions.assertEquals(null, userAccountRepository.findByEmail(emailToDelete))
        Mockito.verify(userAccountRepository).deleteById(userAccount2.userID)
    }

    @Test
    fun `deleteGoogleAccount should do nothing if the email is not found in user accounts`() {
        val mockUserID = Int.MAX_VALUE
        val authDetails = JWTGoogleDTO("access", "refresh", 60 * 60)
        val mockToken = TokenManagerController.createToken(
            TokenRequest(
                arrayListOf(authDetails),
                AuthProviderEnum.GOOGLE,
                mockUserID
            )
        )
        val emailToDelete = ""

        val userAccount1 = UserAccount(id = 1, email = "test1@test.com", refreshToken = "refresh", authProvider = AuthProviderEnum.GOOGLE, userID = mockUserID)
        val userAccount2 = UserAccount(id = 2, email = "test2@test.com", refreshToken = "refresh", authProvider = AuthProviderEnum.GOOGLE, userID = mockUserID)
        val userAccounts = listOf(userAccount1, userAccount2)

        Mockito.`when`(userAccountRepository.findByUserID(mockUserID)).thenReturn(userAccounts)
        // Mockito.`when`(userAccountManagerService.deleteGoogleAccount(mockToken, emailToDelete)).thenReturn(mockToken)


        val result = userAccountManagerService.deleteGoogleAccount(mockToken, emailToDelete)


        Mockito.verify(userAccountRepository, Mockito.never()).deleteById(Mockito.anyInt())
    }
}
*/

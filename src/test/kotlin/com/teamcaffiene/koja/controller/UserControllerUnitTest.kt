package com.teamcaffiene.koja.controller

import com.teamcaffeine.koja.constants.ResponseConstant
import com.teamcaffeine.koja.controller.UserController
import com.teamcaffeine.koja.dto.UserJWTTokenDataDTO
import com.teamcaffeine.koja.entity.UserAccount
import com.teamcaffeine.koja.enums.AuthProviderEnum
import com.teamcaffeine.koja.repository.UserAccountRepository
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

    @Mock
    private lateinit var userAccountRepository: UserAccountRepository

    @BeforeEach
    fun setup() {
        MockitoAnnotations.openMocks(this)
        userController = UserController(userAccountRepository)
    }

    @Test
    fun testDeleteUserAccount() {
        val mockUserID = 1
        val mockToken = "Bearer " + UserJWTTokenDataDTO(listOf(), mockUserID).toString() // Modify this line according to your token creation logic

        val userAccount = UserAccount(id = 1, email = "test@test.com", refreshToken = "refresh", authProvider = AuthProviderEnum.GOOGLE, userID = mockUserID)
        val userAccounts = listOf(userAccount)

        whenever(userAccountRepository.findByUserID(eq(mockUserID))).thenReturn(userAccounts)

        val result = userController.deleteUserAccount(mockToken)

        assertEquals(result, ResponseEntity.ok(ResponseConstant.ACCOUNT_DELETED))
        Mockito.verify(userAccountRepository, Mockito.times(1)).delete(userAccount)
    }

    @Test
    fun testDeleteUserAccountWithoutToken() {
        val result = userController.deleteUserAccount(null)

        assertEquals(result, ResponseEntity.badRequest().body(ResponseConstant.REQUIRED_PARAMETERS_NOT_SET))
    }
}

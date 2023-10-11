package com.teamcaffiene.koja.controller

import com.teamcaffeine.koja.constants.EnvironmentVariableConstant
import com.teamcaffeine.koja.controller.TokenManagerController

class TokenManagerControllerUnitTest {

    private lateinit var tokenManagerController: TokenManagerController

//    @BeforeEach
//    fun setUp() {
//        val dotenv: Dotenv = Dotenv.load()
//        System.setProperty(
//            EnvironmentVariableConstant.KOJA_JWT_SECRET,
//            dotenv[EnvironmentVariableConstant.KOJA_JWT_SECRET]!!
//        )
//        tokenManagerController = TokenManagerController()
//    }
//
//    @Test
//    fun testCreateToken() {
//        val tokens = listOf(
//            JWTGoogleDTO("accessToken", "refreshToken", 123L),
//        )
//        val tokenRequest = TokenRequest(tokens, AuthProviderEnum.GOOGLE, 123)
//
//        val token = tokenManagerController.createToken(tokenRequest)
//
//        // Assert token is not empty
//        assertEquals(true, token.isNotEmpty())
//    }
}

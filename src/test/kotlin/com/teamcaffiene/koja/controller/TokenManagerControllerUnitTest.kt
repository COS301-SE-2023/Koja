package com.teamcaffiene.koja.controller

import com.teamcaffeine.koja.controller.TokenManagerController
import com.teamcaffeine.koja.controller.TokenRequest
import com.teamcaffeine.koja.dto.*
import com.teamcaffeine.koja.enums.AuthProviderEnum
import io.github.cdimascio.dotenv.Dotenv
import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.Test

class TokenManagerControllerTest {

    private lateinit var tokenManagerController: TokenManagerController

    @BeforeEach
    fun setUp() {
        val dotenv: Dotenv = Dotenv.load()
        System.setProperty("KOJA_JWT_SECRET", dotenv["KOJA_JWT_SECRET"]!!)
        tokenManagerController = TokenManagerController()
    }

    @Test
    fun testCreateToken() {
        val tokens = listOf(
            JWTGoogleDTO("accessToken", "refreshToken",123L),
        )
        val tokenRequest = TokenRequest(tokens, AuthProviderEnum.GOOGLE, 123)

        val token = tokenManagerController.createToken(tokenRequest)

        // Assert token is not empty
        assertEquals(true, token.isNotEmpty())
    }
}

package com.teamcaffeine.koja.dto

import javax.crypto.SecretKey

interface JWTFunctionality {
    fun createJWTToken(accessTokens: List<JWTAuthDetailsDTO>, expiryTime: Long, userID: Int): String

    fun getUserJWTTokenData(jwtToken: String): UserJWTTokenDataDTO

    fun generateSecretKey(jwtSecret: String): SecretKey

    fun decrypt(text: String, key: SecretKey): String
}

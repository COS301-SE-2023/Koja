package com.teamcaffeine.koja.dto

import com.teamcaffeine.koja.enums.AuthProviderEnum

class JWTGoogleDTO(private val accessToken: String, private val refreshToken: String, public val expireTimeInSeconds: Long) : JWTAuthDetailsDTO() {
    override fun getJWTFormat(): String {
        return mapOf(
            "googleAccessToken" to accessToken,
            "googleRefreshToken" to refreshToken,
            "googleExpireDate" to expireTimeInSeconds,
            "provider" to AuthProviderEnum.GOOGLE.name
        ).toString()
    }

    override fun getExpireTime(): Long {
        return expireTimeInSeconds
    }

    override fun getRefreshToken(): String {
        return refreshToken
    }

    override fun getAccessToken(): String {
        return accessToken
    }
}
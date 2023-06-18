package com.teamcaffeine.koja.dto

class JWTGoogleDTO(public val accessToken: String, public val refreshToken: String, public val expireTimeInSeconds: Long) : JWTAuthDetailsDTO {
    override fun getJWTFormat(): String {
        return mapOf(
            "googleAccessToken" to accessToken,
            "googleRefreshToken" to refreshToken,
            "googleExpireDate" to expireTimeInSeconds
        ).toString()
    }

    override fun getExpireTime(): Long {
        return expireTimeInSeconds
    }
}
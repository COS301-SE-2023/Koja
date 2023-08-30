package com.teamcaffeine.koja.dto

import com.google.api.client.googleapis.auth.oauth2.GoogleCredential
import com.google.api.client.googleapis.auth.oauth2.GoogleTokenResponse
import com.teamcaffeine.koja.enums.AuthProviderEnum

class JWTGoogleDTO(private var accessToken: String, private val refreshToken: String, var expireTimeInSeconds: Long) :
    JWTAuthDetailsDTO(AuthProviderEnum.GOOGLE) {
    override fun getJWTFormat(): String {
        return mapOf(
            "googleAccessToken" to accessToken,
            "googleRefreshToken" to refreshToken,
            "googleExpireDate" to expireTimeInSeconds,
            "provider" to AuthProviderEnum.GOOGLE.name,
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

    override fun renewToken(): JWTAuthDetailsDTO? {
        val tokenResponse = GoogleTokenResponse().setRefreshToken(refreshToken)
        val jsonFactory = com.google.api.client.json.jackson2.JacksonFactory.getDefaultInstance()
        val httpTransport = com.google.api.client.http.javanet.NetHttpTransport.Builder().build()
        val clientId = System.getProperty("GOOGLE_CLIENT_ID")
        val clientSecret = System.getProperty("GOOGLE_CLIENT_SECRET")

        val credential = GoogleCredential.Builder()
            .setJsonFactory(jsonFactory)
            .setTransport(httpTransport)
            .setClientSecrets(clientId, clientSecret)
            .build()
            .setFromTokenResponse(tokenResponse)

        try {
            credential.refreshToken()
        } catch (exception: Exception) {
            return null
        }
        if (credential.accessToken != null) {
            return JWTGoogleDTO(
                accessToken = credential.accessToken,
                expireTimeInSeconds = credential.expiresInSeconds,
                refreshToken = credential.refreshToken,
            )
        }
        this.accessToken = credential.accessToken
        this.expireTimeInSeconds = credential.expiresInSeconds

        return JWTGoogleDTO(accessToken, credential.refreshToken, expireTimeInSeconds)
    }
}

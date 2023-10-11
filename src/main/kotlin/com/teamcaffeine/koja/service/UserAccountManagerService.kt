package com.teamcaffeine.koja.service

import com.google.api.client.googleapis.auth.oauth2.GoogleCredential
import com.google.api.client.googleapis.auth.oauth2.GoogleTokenResponse
import com.google.api.client.googleapis.javanet.GoogleNetHttpTransport
import com.google.api.client.json.JsonFactory
import com.google.api.client.json.jackson2.JacksonFactory
import com.teamcaffeine.koja.constants.EnvironmentVariableConstant
import com.teamcaffeine.koja.controller.TokenManagerController
import com.teamcaffeine.koja.controller.TokenManagerController.Companion.getUserJWTTokenData
import com.teamcaffeine.koja.controller.TokenRequest
import com.teamcaffeine.koja.dto.JWTAuthDetailsDTO
import com.teamcaffeine.koja.dto.JWTGoogleDTO
import com.teamcaffeine.koja.enums.AuthProviderEnum
import com.teamcaffeine.koja.repository.UserAccountRepository
import com.teamcaffeine.koja.repository.UserRepository
import jakarta.transaction.Transactional
import org.springframework.stereotype.Service

@Service
class UserAccountManagerService(private val userAccountRepository: UserAccountRepository, private val userRepository: UserRepository) {
    @Transactional
    fun deleteGoogleAccount(token: String, email: String): String {
        val jwtToken = getUserJWTTokenData(token)
        val userAccounts = userAccountRepository.findByUserID(jwtToken.userID).toMutableList()
        val storedUser = userRepository.findById(jwtToken.userID)
        for (userAccount in userAccounts) {
            if (userAccount.email == email) {
                userAccount.user?.userAccounts?.remove(userAccount) // remove from User side
                userAccountRepository.delete(userAccount) // remove from UserAccount side
                break
            }
        }

        val existingUserAccounts = storedUser.get().id?.let { userAccountRepository.findByUserID(it) }
        val userTokens = emptyArray<JWTAuthDetailsDTO>().toMutableList()
        if (existingUserAccounts != null) {
            for (userAccount in existingUserAccounts) {
                val updatedCredentials = refreshAccessToken(
                    System.getProperty(EnvironmentVariableConstant.GOOGLE_CLIENT_ID),
                    System.getProperty(EnvironmentVariableConstant.GOOGLE_CLIENT_SECRET),
                    userAccount.refreshToken
                )
                if (updatedCredentials != null) {
                    userTokens.add(
                        JWTGoogleDTO(
                            updatedCredentials.getAccessToken(),
                            userAccount.refreshToken,
                            updatedCredentials.expireTimeInSeconds,
                        ),
                    )
                }
            }
        }

        return TokenManagerController.createToken(
            TokenRequest(
                userTokens,
                AuthProviderEnum.GOOGLE,
                storedUser.get().id!!,
            ),
        )
    }

    private fun refreshAccessToken(clientId: String, clientSecret: String, refreshToken: String): JWTGoogleDTO? {
        val httpTransport = GoogleNetHttpTransport.newTrustedTransport()
        val jsonFactory: JsonFactory = JacksonFactory.getDefaultInstance()
        if (refreshToken.isNotEmpty()) {
            val tokenResponse = GoogleTokenResponse().setRefreshToken(refreshToken)

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
                    refreshToken = refreshToken,
                )
            }
        }
        return null
    }
}

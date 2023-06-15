package com.teamcaffeine.koja.controller

import com.auth0.jwt.JWT
import com.auth0.jwt.algorithms.Algorithm
import com.auth0.jwt.exceptions.JWTDecodeException
import com.auth0.jwt.exceptions.JWTVerificationException
import com.auth0.jwt.interfaces.DecodedJWT
import com.teamcaffeine.koja.enums.AuthProviderEnum
import com.teamcaffeine.koja.enums.getAuthProvider
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController
import java.util.*

data class TokenRequest(val accessToken: String, val refreshToken: String, val expireTime: Long, val authProvider: AuthProviderEnum, val userId: Long)

@RestController
@RequestMapping("/token")
class TokenManagerController {

    private val jwtSecret : String = System.getProperty("KOJA_JWT_SECRET")
    private val minuteInMilliseconds : Long = 60000L

    @PostMapping("/renew")
    fun renewToken(@RequestBody tokenRequest: TokenRequest): String {
        val refreshToken = tokenRequest.refreshToken

        try {
            val algorithm = Algorithm.HMAC512(jwtSecret)
            val verifier = JWT.require(algorithm).build()
            val decodedJWT: DecodedJWT = verifier.verify(refreshToken)

            // TODO: Use refresh token to get new access token from Auth Provider and update expiry time
            val newAccessToken = decodedJWT.getClaim("access_token").asString()
            val newExpiryTime = decodedJWT.getClaim("expiry_time").asLong()
            val newRefreshToken = decodedJWT.getClaim("refresh_token").asString()
            val authProvider = decodedJWT.getClaim("auth_provider").asString()
            val userID = decodedJWT.getClaim("user_id").asLong()

            return createJwtToken(newAccessToken, newExpiryTime, newRefreshToken, getAuthProvider(authProvider), userID)
        } catch (e: JWTDecodeException) {
            throw IllegalArgumentException("Invalid token format")
        } catch (e: JWTVerificationException) {
            throw IllegalArgumentException("Invalid token")
        }
    }

    fun createToken(@RequestBody tokenRequest: TokenRequest): String {
        val expiryTime = tokenRequest.expireTime - (minuteInMilliseconds * 5)
        val userID = tokenRequest.userId

        return createJwtToken(
            tokenRequest.accessToken,
            expiryTime,
            tokenRequest.refreshToken,
            tokenRequest.authProvider,
            tokenRequest.userId
        )
    }

    fun createJwtToken(accessToken: String, expiryTime: Long, refreshToken: String, authProvider: AuthProviderEnum, userID: Long): String {
        val algorithm = Algorithm.HMAC512(jwtSecret)

        return JWT.create()
            .withClaim("access_token", accessToken)
            .withClaim("expiry_time", expiryTime)
            .withClaim("refresh_token", refreshToken)
            .withClaim("auth_provider", authProvider.toString())
            .withClaim("user_id", userID)
            .withExpiresAt(Date(System.currentTimeMillis() + expiryTime))
            .sign(algorithm)
    }

    companion object{
        fun decodeJwtToken(jwtToken: String): DecodedJWT {
            val jwtSecret : String = System.getProperty("KOJA_JWT_SECRET")
            val algorithm = Algorithm.HMAC512(jwtSecret)
            val verifier = JWT.require(algorithm).build()
            return verifier.verify(jwtToken)
        }
    }
    fun decodeJwtToken(jwtToken: String): DecodedJWT {
        val algorithm = Algorithm.HMAC512(jwtSecret)
        val verifier = JWT.require(algorithm).build()
        return verifier.verify(jwtToken)
    }
}

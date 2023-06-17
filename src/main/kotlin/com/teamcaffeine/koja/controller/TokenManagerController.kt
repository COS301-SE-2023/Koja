package com.teamcaffeine.koja.controller

import com.auth0.jwt.JWT
import com.auth0.jwt.algorithms.Algorithm
import com.auth0.jwt.exceptions.JWTDecodeException
import com.auth0.jwt.exceptions.JWTVerificationException
import com.auth0.jwt.interfaces.DecodedJWT
import com.teamcaffeine.koja.enums.AuthProviderEnum
import com.teamcaffeine.koja.enums.JWTTokenStructureEnum
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController
import java.util.*

data class TokenRequest(val accessToken: String, val refreshToken: String, val expireTime: Long, val authProvider: AuthProviderEnum, val userId: Int)

@RestController
@RequestMapping("/api/v1/token")
class TokenManagerController {

    private val jwtSecret : String = System.getProperty("KOJA_JWT_SECRET")
    private val oneMinuteInSeconds : Long = 60L

    @PostMapping("/renew")
    fun renewToken(@RequestBody tokenRequest: TokenRequest): String {
        val refreshToken = tokenRequest.refreshToken

        try {
            val algorithm = Algorithm.HMAC512(jwtSecret)
            val verifier = JWT.require(algorithm).build()
            val decodedJWT: DecodedJWT = verifier.verify(refreshToken)

            // TODO: Use refresh token to get new access token from Auth Provider and update expiry time
            val newAccessToken = decodedJWT.getClaim(JWTTokenStructureEnum.GOOGLE_ACCESS_TOKEN.claimName).asString()
            val newExpiryTime = 0L
            val userID = decodedJWT.getClaim(JWTTokenStructureEnum.USER_ID.claimName).asInt()

            return createJwtToken(
                accessToken = newAccessToken,
                expiryTime = newExpiryTime,
                userID = userID
            )
        } catch (e: JWTDecodeException) {
            throw IllegalArgumentException("Invalid token format")
        } catch (e: JWTVerificationException) {
            throw IllegalArgumentException("Invalid token")
        }
    }

    fun createToken( tokenRequest: TokenRequest): String {
        val expiryTime = tokenRequest.expireTime - (oneMinuteInSeconds * 5)
        val userID = tokenRequest.userId

        return createJwtToken(
            accessToken = tokenRequest.accessToken,
            expiryTime = expiryTime,
            userID = tokenRequest.userId
        )
    }

    fun createJwtToken(accessToken: String, expiryTime: Long, userID: Int): String {
        val algorithm = Algorithm.HMAC512(jwtSecret)

        val tokenExpireDate : Date = Date(System.currentTimeMillis() + getTokenValidTime(expiryTime))

        return JWT.create()
            .withClaim(JWTTokenStructureEnum.GOOGLE_ACCESS_TOKEN.claimName, accessToken)
            .withClaim(JWTTokenStructureEnum.USER_ID.claimName, userID)
            .withExpiresAt(tokenExpireDate)
            .sign(algorithm)
    }

    private fun getTokenValidTime(expireTime: Long): Long {
        return ( expireTime - (oneMinuteInSeconds * 5) ) * 1000
    }

    companion object{
        fun decodeJwtToken(jwtToken: String): DecodedJWT {
            val jwtSecret : String = System.getProperty("KOJA_JWT_SECRET")
            val algorithm = Algorithm.HMAC512(jwtSecret)
            val verifier = JWT.require(algorithm).build()
            return verifier.verify(jwtToken)
        }
    }
}

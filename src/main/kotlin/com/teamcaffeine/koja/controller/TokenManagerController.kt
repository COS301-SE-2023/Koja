package com.teamcaffeine.koja.controller

import com.auth0.jwt.JWT
import com.auth0.jwt.algorithms.Algorithm
import com.google.gson.Gson
import com.teamcaffeine.koja.dto.JWTAuthDetailsDTO
import com.teamcaffeine.koja.dto.JWTAuthDetailsDTO.Companion.parseJWTFormatString
import com.teamcaffeine.koja.dto.JWTGoogleDTO
import com.teamcaffeine.koja.dto.UserJWTTokenDataDTO
import com.teamcaffeine.koja.enums.AuthProviderEnum
import com.teamcaffeine.koja.enums.JWTTokenStructureEnum
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController
import java.security.MessageDigest
import java.util.*
import javax.crypto.Cipher
import javax.crypto.SecretKey
import javax.crypto.spec.SecretKeySpec

data class TokenRequest(val tokens : List<JWTAuthDetailsDTO>, val authProvider: AuthProviderEnum, val userId: Int)

@RestController
@RequestMapping("/api/v1/token")
class TokenManagerController {

    private val jwtSecret : String = System.getProperty("KOJA_JWT_SECRET")
    private val oneMinuteInSeconds : Long = 60L

    @PostMapping("/renew")
    fun renewToken(@RequestBody tokenRequest: TokenRequest): String {
//        val refreshToken = tokenRequest.jwtGoogleDTO.refreshToken
//
//        try {
//            val algorithm = Algorithm.HMAC512(jwtSecret)
//            val verifier = JWT.require(algorithm).build()
//            val decodedJWT: DecodedJWT = verifier.verify(refreshToken)
//
//            // TODO: Use refresh token to get new access token from Auth Provider and update expiry time
//            val newAccessToken = decodedJWT.getClaim(JWTTokenStructureEnum.GOOGLE_ACCESS_TOKEN.claimName).asString()
//            val newExpiryTime = 0L
//            val userID = decodedJWT.getClaim(JWTTokenStructureEnum.USER_ID.claimName).asInt()
//
//            return createJwtToken(
//                accessToken = newAccessToken,
//                expiryTime = newExpiryTime,
//                userID = userID
//            )
//        } catch (e: JWTDecodeException) {
//            throw IllegalArgumentException("Invalid token format")
//        } catch (e: JWTVerificationException) {
//            throw IllegalArgumentException("Invalid token")
//        }
        return ""
    }

    fun createToken(tokenRequest: TokenRequest): String {
        val soonestExpireTime = getSoonestExpiryTime(tokenRequest)
        val expiryTime = soonestExpireTime - (oneMinuteInSeconds * 5)
        return createJwtToken(
            accessTokens = tokenRequest.tokens,
            expiryTime = expiryTime,
            userID = tokenRequest.userId
        )
    }

    private fun getSoonestExpiryTime(tokenRequest: TokenRequest): Long {
        var soonestExpireTime = Long.MAX_VALUE
        for (token in tokenRequest.tokens) {
            val tokenExpireTime = token.getExpireTime()
            if (tokenExpireTime < soonestExpireTime) {
                soonestExpireTime = tokenExpireTime
            }
        }
        return soonestExpireTime
    }

    fun createJwtToken(accessTokens: List<JWTAuthDetailsDTO>, expiryTime: Long, userID: Int): String {
        val algorithm = Algorithm.HMAC512(jwtSecret)
        val tokenExpireDate: Date = Date(System.currentTimeMillis() + getTokenValidTime(expiryTime))

        val gson = Gson()
        val claims = mutableMapOf<String, Any>()
        claims[JWTTokenStructureEnum.USER_ACCOUNT_TOKENS.claimName] = gson.toJson(accessTokens)
        claims[JWTTokenStructureEnum.USER_ID.claimName] = userID

        val encryptedClaims = encrypt(claims.toString(), generateSecretKey(jwtSecret))

        return JWT.create()
            .withClaim("encrypted", encryptedClaims)
            .withExpiresAt(tokenExpireDate)
            .sign(algorithm)
    }
    private fun encrypt(text: String, key: SecretKey): String {
        val cipher = Cipher.getInstance("AES")
        cipher.init(Cipher.ENCRYPT_MODE, key)
        val encrypted = cipher.doFinal(text.toByteArray(Charsets.UTF_8))
        return Base64.getEncoder().encodeToString(encrypted)
    }

    private fun decrypt(text: String, key: SecretKey): String {
        val cipher = Cipher.getInstance("AES")
        cipher.init(Cipher.DECRYPT_MODE, key)
        val decoded = Base64.getDecoder().decode(text)
        val decrypted = cipher.doFinal(decoded)
        return String(decrypted, Charsets.UTF_8)
    }


    private fun getTokenValidTime(expireTime: Long): Long {
        return ( expireTime - (oneMinuteInSeconds * 5) ) * 1000
    }

    companion object{
        private fun decrypt(text: String, key: SecretKey): String {
            val cipher = Cipher.getInstance("AES")
            cipher.init(Cipher.DECRYPT_MODE, key)
            val decoded = Base64.getDecoder().decode(text)
            val decrypted = cipher.doFinal(decoded)
            return String(decrypted, Charsets.UTF_8)
        }
        fun getUserJWTTokenData(jwtToken: String): UserJWTTokenDataDTO {
            val jwtSecret: String = System.getProperty("KOJA_JWT_SECRET")
            val algorithm = Algorithm.HMAC512(jwtSecret)
            val verifier = JWT.require(algorithm).build()
            val decodedJWT = verifier.verify(jwtToken)

            val encryptedClaims = decodedJWT.getClaim("encrypted").asString()
            val decryptedClaims = decrypt(encryptedClaims, generateSecretKey(jwtSecret))
            val gson = Gson()

            val userTokens = gson.fromJson(decryptedClaims.substringAfter("userAccountTokens=")
                .substringBefore(", userID"), List::class.java)


            val userAccountTokens = mutableListOf<JWTAuthDetailsDTO>()

            for (token in userTokens) {
                val currentToken = parseJWTFormatString(token.toString())
                if(currentToken?.authProvider == AuthProviderEnum.GOOGLE)
                    userAccountTokens.add(currentToken as JWTGoogleDTO)
            }

            return UserJWTTokenDataDTO(
                 userAccountTokens,
                    decryptedClaims.substringAfter("userID=").substringBefore("}").toInt()
            )
        }

        fun generateSecretKey(jwtSecret: String): SecretKey {
            val messageDigest = MessageDigest.getInstance("SHA-256")
            val keyBytes = messageDigest.digest(jwtSecret.toByteArray(Charsets.UTF_8))
            return SecretKeySpec(keyBytes, "AES")
        }
    }
}

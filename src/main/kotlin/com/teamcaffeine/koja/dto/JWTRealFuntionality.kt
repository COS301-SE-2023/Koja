package com.teamcaffeine.koja.dto

import com.auth0.jwt.JWT
import com.auth0.jwt.algorithms.Algorithm
import com.google.gson.Gson
import com.teamcaffeine.koja.controller.TokenManagerController
import com.teamcaffeine.koja.enums.AuthProviderEnum
import org.springframework.stereotype.Service
import java.security.MessageDigest
import java.util.Base64
import javax.crypto.Cipher
import javax.crypto.SecretKey
import javax.crypto.spec.SecretKeySpec

@Service
class JWTRealFuntionality : JWTFunctionality {
    override fun createJWTToken(accessTokens: List<JWTAuthDetailsDTO>, expiryTime: Long, userID: Int): String {
        return ""
    }

    override fun getUserJWTTokenData(jwtToken: String): UserJWTTokenDataDTO {
        val jwtSecret: String = System.getProperty("KOJA_JWT_SECRET")
        val algorithm = Algorithm.HMAC512(jwtSecret)
        val verifier = JWT.require(algorithm).build()
        val decodedJWT = verifier.verify(jwtToken)

        val encryptedClaims = decodedJWT.getClaim("encrypted").asString()
        val decryptedClaims =
            decrypt(encryptedClaims, generateSecretKey(jwtSecret))
        val gson = Gson()

        val userTokens = gson.fromJson(
            decryptedClaims.substringAfter("userAccountTokens=")
                .substringBefore(", userID"),
            List::class.java,
        )

        val userAccountTokens = mutableListOf<JWTAuthDetailsDTO>()

        for (token in userTokens) {
            val currentToken = JWTAuthDetailsDTO.parseJWTFormatString(token.toString())
            if (currentToken?.authProvider == AuthProviderEnum.GOOGLE) {
                userAccountTokens.add(currentToken as JWTGoogleDTO)
            }
        }

        return UserJWTTokenDataDTO(
            userAccountTokens,
            decryptedClaims.substringAfter("userID=").substringBefore("}").toInt(),
        )
    }

    override fun decrypt(text: String, key: SecretKey): String {
        val cipher = Cipher.getInstance("AES")
        cipher.init(Cipher.DECRYPT_MODE, key)
        val decoded = Base64.getDecoder().decode(text)
        val decrypted = cipher.doFinal(decoded)
        return String(decrypted, Charsets.UTF_8)
    }

    override fun generateSecretKey(jwtSecret: String): SecretKey {
        val messageDigest = MessageDigest.getInstance("SHA-256")
        val keyBytes = messageDigest.digest(jwtSecret.toByteArray(Charsets.UTF_8))
        return SecretKeySpec(keyBytes, "AES")
    }
}

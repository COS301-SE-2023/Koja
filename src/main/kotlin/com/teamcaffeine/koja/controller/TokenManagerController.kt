import com.auth0.jwt.JWT
import com.auth0.jwt.algorithms.Algorithm
import com.auth0.jwt.exceptions.JWTDecodeException
import com.auth0.jwt.exceptions.JWTVerificationException
import com.auth0.jwt.interfaces.DecodedJWT
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController

data class TokenRequest(val accessToken: String, val refreshToken: String)

@RestController
@RequestMapping("/token")
class TokenManagerController {

    fun createToken(@RequestBody tokenRequest: TokenRequest): String {
        val accessToken = tokenRequest.accessToken
        val expiryTime = 3600000L // 1 hour in milliseconds
        val refreshToken = tokenRequest.refreshToken

        return createJwtToken(accessToken, expiryTime, refreshToken)
    }

    @PostMapping("/renew")
    fun renewToken(@RequestBody tokenRequest: TokenRequest): String {
        val refreshToken = tokenRequest.refreshToken

        try {
            val algorithm = Algorithm.HMAC256(secretKey)
            val verifier = JWT.require(algorithm).build()
            val decodedJWT: DecodedJWT = verifier.verify(refreshToken)

            val newAccessToken = decodedJWT.getClaim("access_token").asString()
            val newExpiryTime = decodedJWT.getClaim("expiry_time").asLong()
            val newRefreshToken = decodedJWT.getClaim("refresh_token").asString()

            return createJwtToken(newAccessToken, newExpiryTime, newRefreshToken)
        } catch (e: JWTDecodeException) {
            throw IllegalArgumentException("Invalid token format")
        } catch (e: JWTVerificationException) {
            throw IllegalArgumentException("Invalid token")
        }
    }

    fun createJwtToken(accessToken: String, expiryTime: Long, refreshToken: String): String {
        // Define the signing algorithm
        val algorithm = Algorithm.HMAC256("your-secret-key")

        // Create the JWT token
        val jwtToken = JWT.create()
            .withClaim("access_token", accessToken)
            .withClaim("expiry_time", expiryTime)
            .withClaim("refresh_token", refreshToken)
            .withExpiresAt(Date(System.currentTimeMillis() + expiryTime))
            .sign(algorithm)

        return jwtToken
    }
}

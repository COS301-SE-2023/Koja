package com.teamcaffeine.koja.dto

import com.teamcaffeine.koja.enums.AuthProviderEnum

abstract class JWTAuthDetailsDTO(public val authProvider: AuthProviderEnum) {
    abstract fun getJWTFormat(): String
    abstract fun getExpireTime(): Long

    abstract fun getRefreshToken(): String

    abstract fun getAccessToken(): String

    companion object
    {
        fun parseJWTFormatString(jwtFormatString: String): JWTAuthDetailsDTO? {
            val map = mutableMapOf<String, Any>()
            val keyValuePairs = jwtFormatString.trim().removeSurrounding("{", "}").split(", ")
            for (keyValuePair in keyValuePairs) {
                val (key, value) = keyValuePair.split("=")
                map[key] = value
            }

            if(map["authProvider"] == AuthProviderEnum.GOOGLE.name){
                return JWTGoogleDTO(
                    map["accessToken"] as String,
                    map["refreshToken"] as String,
                    (map["expireTimeInSeconds"] as String).toDouble().toLong()
                )
            }
            return null
        }
    }

}
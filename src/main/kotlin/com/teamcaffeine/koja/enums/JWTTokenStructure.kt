package com.teamcaffeine.koja.enums

enum class JWTTokenStructure(val claimName: String){
    ACCESS_TOKEN("accessToken"),
    EXPIRES_TIME("expireDateTime"),
    REFRESH_TOKEN("refreshToken"),
    AUTH_PROVIDER("authProvider"),
    USER_ID("userID")
}
package com.teamcaffeine.koja.enums

enum class JWTTokenStructure(val claimName: String){
    ACCESS_TOKEN("access_token"),
    EXPIRES_TIME("expire_time"),
    REFRESH_TOKEN("refresh_token"),
    AUTH_PROVIDER("auth_provider"),
    USER_ID("user_id")
}
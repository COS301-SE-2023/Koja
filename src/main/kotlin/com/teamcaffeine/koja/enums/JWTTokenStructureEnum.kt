package com.teamcaffeine.koja.enums

enum class JWTTokenStructureEnum(val claimName: String){
    GOOGLE_ACCESS_TOKEN("googleAccessToken"),
    USER_ID("userID")
}
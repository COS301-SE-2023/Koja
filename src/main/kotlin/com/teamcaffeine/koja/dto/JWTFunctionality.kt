package com.teamcaffeine.koja.dto

interface JWTFunctionality {
    fun createJWTToken(accessTokens: List<JWTAuthDetailsDTO>, expiryTime: Long, userID: Int) :String
}
package com.teamcaffeine.koja.dto

interface JWTAuthDetailsDTO {
    fun getJWTFormat(): String
    fun getExpireTime(): Long
}
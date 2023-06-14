package com.teamcaffeine.koja.enums

enum class AuthProviderEnum {
    GOOGLE,
    OUTLOOK,
}

fun getAuthProvider(authProvider: String): AuthProviderEnum {
    return when (authProvider) {
        "GOOGLE" -> AuthProviderEnum.GOOGLE
        "OUTLOOK" -> AuthProviderEnum.OUTLOOK
        else -> throw IllegalArgumentException("Invalid AuthProviderEnum value: $authProvider")
    }
}
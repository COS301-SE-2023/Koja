package com.teamcaffeine.koja.dto

import com.teamcaffeine.koja.controller.AuthenticationController
import com.teamcaffeine.koja.controller.TokenManagerController

class JWTRealFuntionality: JWTFunctionality {
    override fun createJWTToken(accessTokens: List<JWTAuthDetailsDTO>, expiryTime: Long, userID: Int): String {
        return TokenManagerController.createJwtToken(accessTokens,expiryTime,userID)
    }

}
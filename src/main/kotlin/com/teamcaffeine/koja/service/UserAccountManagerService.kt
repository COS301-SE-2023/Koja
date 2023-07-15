package com.teamcaffeine.koja.service

import com.teamcaffeine.koja.controller.TokenManagerController.Companion.getUserJWTTokenData
import com.teamcaffeine.koja.repository.UserAccountRepository
import org.springframework.stereotype.Service

@Service
class UserAccountManagerService(private val userAccountRepository: UserAccountRepository) {
    
    fun deleteGoogleAccount(token: String, email: String) {
        val jwtToken = getUserJWTTokenData(token)
        val userAccounts = userAccountRepository.findByUserID(jwtToken.userID)

        for (userAccount in userAccounts) {
            if (userAccount.email == email) {
                userAccountRepository.deleteById(userAccount.userID)
            }
        }
    }
}

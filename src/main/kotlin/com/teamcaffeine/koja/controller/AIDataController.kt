package com.teamcaffeine.koja.controller

import com.teamcaffeine.koja.dto.AIUserEventDataDTO
import com.teamcaffeine.koja.dto.UserEventDTO
import com.teamcaffeine.koja.dto.UserJWTTokenDataDTO
import com.teamcaffeine.koja.repository.UserAccountRepository
import com.teamcaffeine.koja.service.AIUserDataService
import com.teamcaffeine.koja.service.UserCalendarService
import org.springframework.http.ResponseEntity

class AIDataController(private val userAccountRepository: UserAccountRepository, private val aiUserDataService : AIUserDataService)  {
    fun getUserEventData(): ResponseEntity<Unit> {
        return ResponseEntity.ok(aiUserDataService.getUserEventData(""))
    }

}
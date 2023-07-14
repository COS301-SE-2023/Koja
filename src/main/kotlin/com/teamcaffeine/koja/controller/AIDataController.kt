package com.teamcaffeine.koja.controller

import com.teamcaffeine.koja.constants.HeaderConstant
import com.teamcaffeine.koja.constants.ResponseConstant
import com.teamcaffeine.koja.repository.UserAccountRepository
import com.teamcaffeine.koja.service.AIUserDataService
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RequestHeader
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController

@RestController
@RequestMapping("/api/v1/ai")
class AIDataController(private val userAccountRepository: UserAccountRepository, private val aiUserDataService: AIUserDataService) {
    @GetMapping("/all-users-events")
    fun getUserEventData(@RequestHeader(HeaderConstant.AUTHORISATION) token: String?): ResponseEntity<out Any> {
        return if (token == null) {
            ResponseEntity.badRequest().body(ResponseConstant.REQUIRED_PARAMETERS_NOT_SET)
        } else if (token != System.getProperty("KOJA_JWT_SECRET")) {
            ResponseEntity<String>("Unauthorized", HttpStatus.UNAUTHORIZED)
        } else {
            ResponseEntity.ok(aiUserDataService.getUserEventData(token))
        }
    }
}

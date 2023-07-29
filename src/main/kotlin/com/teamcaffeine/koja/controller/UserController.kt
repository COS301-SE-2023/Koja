package com.teamcaffeine.koja.controller

import com.google.gson.Gson
import com.google.gson.GsonBuilder
import com.teamcaffeine.koja.constants.HeaderConstant
import com.teamcaffeine.koja.constants.ResponseConstant
import com.teamcaffeine.koja.controller.TokenManagerController.Companion.getUserJWTTokenData
import com.teamcaffeine.koja.entity.TimeBoundary
import com.teamcaffeine.koja.entity.User
import com.teamcaffeine.koja.enums.TimeBoundaryType
import com.teamcaffeine.koja.repository.UserAccountRepository
import com.teamcaffeine.koja.repository.UserRepository
import com.teamcaffeine.koja.service.UserCalendarService
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RequestHeader
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RequestParam
import org.springframework.web.bind.annotation.RestController

@RestController
@RequestMapping("/api/v1/user")
class UserController(
    private val userAccountRepository: UserAccountRepository,
    private val userRepository: UserRepository,
    private val userCalendarService: UserCalendarService,
) {
    @GetMapping("linked-emails")
    fun getUserEmails(@RequestHeader(HeaderConstant.AUTHORISATION) token: String?): ResponseEntity<List<String>> {
        return if (token == null) {
            ResponseEntity.badRequest().body(listOf(ResponseConstant.REQUIRED_PARAMETERS_NOT_SET))
        } else {
            val jwtTokenData = getUserJWTTokenData(token)
            val userAccounts = userAccountRepository.findByUserID(jwtTokenData.userID)

            ResponseEntity.ok(userAccounts.map { it.email })
        }
    }

    @PostMapping("delete-account")
    fun deleteUserAccount(@RequestHeader(HeaderConstant.AUTHORISATION) token: String?): ResponseEntity<String> {
        return if (token == null) {
            ResponseEntity.badRequest().body(ResponseConstant.REQUIRED_PARAMETERS_NOT_SET)
        } else {
            val jwtTokenData = getUserJWTTokenData(token)
            val userAccounts = userAccountRepository.findByUserID(jwtTokenData.userID)
            val users = mutableListOf<User>()
            userAccounts.forEach {
                it.user?.let { it1 -> users.add(it1) }
                userAccountRepository.delete(it)
            }
            users.forEach {
                userRepository.delete(it)
            }
            ResponseEntity.ok(ResponseConstant.ACCOUNT_DELETED)
        }
    }

    @PostMapping("/addTimeBoundary")
    fun addTimeBoundary(
        @RequestHeader(HeaderConstant.AUTHORISATION) token: String,
        @RequestParam("name") name: String?,
        @RequestParam("startTime")startTime: String?,
        @RequestParam("endTime")endTime: String?,
        @RequestParam("type")type: String = "allowed",
    ): ResponseEntity<out Any> {
        return if (token == null) {
            ResponseEntity.badRequest().body(listOf(ResponseConstant.REQUIRED_PARAMETERS_NOT_SET))
        } else {
            val boundaryType = getTimeBoundaryType(type)
            val boundary = TimeBoundary(name, startTime, endTime, boundaryType)
            try {
                return ResponseEntity.ok(userCalendarService.addTimeBoundary(token, boundary))
            } catch (e: Exception) {
                return ResponseEntity.badRequest().body(e.message)
            }
        }
    }

    @PostMapping("/removeTimeBoundary")
    fun removeTimeBoundary(@RequestHeader(HeaderConstant.AUTHORISATION) token: String, @RequestParam("name") name: String?): ResponseEntity<String> {
        return if (token == null) {
            ResponseEntity.badRequest().body(ResponseConstant.REQUIRED_PARAMETERS_NOT_SET)
        } else {
            if (userCalendarService.removeTimeBoundary(token, name)) {
                return ResponseEntity.ok("Time boundary successfully removed")
            } else {
                return ResponseEntity.badRequest().body("Something went wrong")
            }
        }
    }

    @GetMapping("/getAllTimeBoundary")
    fun getTimeBoundaries(@RequestHeader(HeaderConstant.AUTHORISATION) token: String): ResponseEntity<out Any> {
        return if (token == null) {
            ResponseEntity.badRequest().body(ResponseConstant.REQUIRED_PARAMETERS_NOT_SET)
        } else {
            try {
                val gson = GsonBuilder().setLenient().excludeFieldsWithoutExposeAnnotation().create()
                return ResponseEntity.ok(gson.toJson(userCalendarService.getUserTimeBoundaries(token)))
            } catch (e: Exception) {
                return ResponseEntity.badRequest().body(e.message)
            }
        }
    }

    @GetMapping("/getTimeBoundaryAndLocation")
    fun getTimeBoundaryAndLocation(@RequestHeader(HeaderConstant.AUTHORISATION) token: String, @RequestParam("location") location: String): ResponseEntity<out Any> {
        return if (token == null) {
            ResponseEntity.badRequest().body(ResponseConstant.REQUIRED_PARAMETERS_NOT_SET)
        } else {
            val gson = Gson()
            return ResponseEntity.ok(gson.toJson(userCalendarService.getUserTimeBoundaryAndLocation(token, location)))
        }
    }

    private fun getTimeBoundaryType(timeBoundaryType: String): TimeBoundaryType {
        return when (timeBoundaryType) {
            "allowed" -> TimeBoundaryType.ALLOWED
            "blocked" -> TimeBoundaryType.BLOCKED
            else -> throw IllegalArgumentException("Invalid TimeBoundaryType value: $timeBoundaryType")
        }
    }
}

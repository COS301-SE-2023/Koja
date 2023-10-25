package com.teamcaffeine.koja.controller

import com.teamcaffeine.koja.constants.HeaderConstant
import com.teamcaffeine.koja.constants.ResponseConstant
import com.teamcaffeine.koja.enums.CallbackConfigEnum
import com.teamcaffeine.koja.service.GoogleCalendarAdapterService
import com.teamcaffeine.koja.service.UserAccountManagerService
import jakarta.servlet.http.HttpServletRequest
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RequestHeader
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RequestParam
import org.springframework.web.bind.annotation.RestController
import org.springframework.web.servlet.view.RedirectView

@RestController
@RequestMapping("/api/v1/user/")
class UserAccountManagerController(
    private val googleCalendarAdapter: GoogleCalendarAdapterService,
    private val userAccountManagerService: UserAccountManagerService,
) {

    @GetMapping("auth/add-email/google")
    fun authenticateAnotherGoogleEmail(request: HttpServletRequest, @RequestParam token: String?): Any {
        return when {
            token.isNullOrEmpty() -> {
                ResponseEntity.badRequest().body(ResponseConstant.REQUIRED_PARAMETERS_NOT_SET)
            }
            !TokenManagerController.isTokenValid(token) -> {
                ResponseEntity.badRequest().body(ResponseConstant.INVALID_TOKEN)
            }
            else -> {
                googleCalendarAdapter.setupConnection(
                    request,
                    CallbackConfigEnum.ADD_EMAIL,
                    addAdditionalAccount = true,
                    token = token,
                )
            }
        }
    }

    @GetMapping("auth/add-email/callback")
    fun handleGoogleOAuth2Callback(
        @RequestParam("code") authCode: String?,
        @RequestParam state: String?,
    ): Any {
        return when {
            authCode.isNullOrEmpty() || state.isNullOrEmpty() -> {
                ResponseEntity.badRequest().body(ResponseConstant.REQUIRED_PARAMETERS_NOT_SET)
            }
            else -> {
                try {
                    val jwt = googleCalendarAdapter.addAnotherEmailOauth2Callback(authCode, state, true)
                    RedirectView("koja-login-callback://callback?token=$jwt")
                } catch (e: Exception) {
                    if(e.message.equals(ResponseConstant.USER_ALREADY_EXISTS))
                        ResponseEntity.status(HttpStatus.CONFLICT).body(ResponseConstant.USER_ALREADY_EXISTS)
                    else ResponseEntity.internalServerError().body(ResponseConstant.GENERIC_INTERNAL_ERROR)
                }

            }
        }
    }

    @PostMapping("remove-email")
    fun removeEmail(
        @RequestHeader(HeaderConstant.AUTHORISATION) token: String?,
        @RequestBody email: String?,
    ): Any {
        return when {
            token.isNullOrEmpty() || email.isNullOrEmpty() -> {
                ResponseEntity.badRequest().body(ResponseConstant.REQUIRED_PARAMETERS_NOT_SET)
            }
            !TokenManagerController.isTokenValid(token) -> {
                ResponseEntity.badRequest().body(ResponseConstant.INVALID_TOKEN)
            }
            else -> {
                userAccountManagerService.deleteGoogleAccount(token, email)
            }
        }
    }
}

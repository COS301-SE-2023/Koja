package com.teamcaffeine.koja.controller

import com.teamcaffeine.koja.constants.HeaderConstant
import com.teamcaffeine.koja.constants.ResponseConstant
import com.teamcaffeine.koja.service.GoogleCalendarAdapterService
import com.teamcaffeine.koja.service.UserAccountManagerService
import jakarta.servlet.http.HttpServletRequest
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
        return if (token == null) {
            ResponseEntity.badRequest().body(ResponseConstant.REQUIRED_PARAMETERS_NOT_SET)
        } else {
            return googleCalendarAdapter.setupConnection(request, false, addAdditionalAccount = true, token = token)
        }
    }

    @GetMapping("auth/add-email/callback")
    fun handleGoogleOAuth2Callback(
        @RequestParam("code") authCode: String?,
        @RequestParam state: String?,
    ): Any {
        return if (state == null) {
            ResponseEntity.badRequest().body(ResponseConstant.REQUIRED_PARAMETERS_NOT_SET)
        } else {
            val jwt = googleCalendarAdapter.addAnotherEmailOauth2Callback(authCode, state, false)
            return RedirectView("koja-login-callback://callback?token=$jwt")
        }
    }

    @PostMapping("remove-email")
    fun removeEmail(
        @RequestHeader(HeaderConstant.AUTHORISATION) token: String?,
        @RequestBody email: String?,
    ): Any {
        return if (token == null || email == null) {
            ResponseEntity.badRequest().body(ResponseConstant.REQUIRED_PARAMETERS_NOT_SET)
        } else {
            val jwt = userAccountManagerService.deleteGoogleAccount(token, email)
            return jwt
        }
    }
}

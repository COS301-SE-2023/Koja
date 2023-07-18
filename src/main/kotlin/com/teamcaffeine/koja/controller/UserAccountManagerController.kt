package com.teamcaffeine.koja.controller

import com.teamcaffeine.koja.constants.HeaderConstant
import com.teamcaffeine.koja.constants.ResponseConstant
import com.teamcaffeine.koja.service.GoogleCalendarAdapterService
import com.teamcaffeine.koja.service.UserAccountManagerService
import jakarta.servlet.http.HttpServletRequest
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RequestHeader
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RequestParam
import org.springframework.web.bind.annotation.RestController
import org.springframework.web.servlet.view.RedirectView

@RestController
@RequestMapping("/api/v1/user/")

class UserAccountManagerController(
    private val googleCalendarAdapter: GoogleCalendarAdapterService,
    private val userAccountManagerService: UserAccountManagerService
) {

    @GetMapping("add-email/google")
    fun authenticateAnotherGoogleEmail(request: HttpServletRequest, @RequestHeader(HeaderConstant.AUTHORISATION) token: String?): RedirectView {
        return if (token == null) {
            RedirectView("http://localhost:8080/api/v1/user/auth/google/callback")
        } else {
            return googleCalendarAdapter.setupConnection(request, false)
        }
    }

    @GetMapping("auth/google/callback")
    fun handleGoogleOAuth2Callback(
        @RequestParam("code") authCode: String?,
        @RequestHeader(HeaderConstant.AUTHORISATION) token: String?
    ): ResponseEntity<String> {
        return if (token == null) {
            ResponseEntity.badRequest().body(ResponseConstant.REQUIRED_PARAMETERS_NOT_SET)
        } else {
            val jwt = googleCalendarAdapter.addAnotherEmailOauth2Callback(authCode, token, false)
            return ResponseEntity.ok()
                .header("Authorization", "Bearer $jwt")
                .body("Authentication successful")
        }
    }

    @PostMapping("remove-email")
    fun removeEmail(
        @RequestHeader(HeaderConstant.AUTHORISATION) token: String?,
        @RequestParam("email") email: String?
    ): ResponseEntity<String> {
        return if (token == null || email == null) {
            ResponseEntity.badRequest().body(ResponseConstant.REQUIRED_PARAMETERS_NOT_SET)
        } else {
            userAccountManagerService.deleteGoogleAccount(token, email)
            ResponseEntity.ok(ResponseConstant.EMAIL_REMOVED)
        }
    }
}

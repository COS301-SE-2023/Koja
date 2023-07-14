package com.teamcaffeine.koja.controller

import com.teamcaffeine.koja.constants.HeaderConstant
import com.teamcaffeine.koja.constants.ResponseConstant
import com.teamcaffeine.koja.service.GoogleCalendarAdapterService
import com.teamcaffeine.koja.service.UserAccountManagerService
import jakarta.servlet.http.HttpServletRequest
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*
import org.springframework.web.servlet.view.RedirectView

@RestController
@RequestMapping("/api/v1/user")

class UserAccountManagerController(private val googleCalendarAdapter: GoogleCalendarAdapterService,
                                   private val userAccountManagerService: UserAccountManagerService) {

    @GetMapping("auth/add-email/google")
    fun authenticateAnotherGoogleEmail(request: HttpServletRequest): RedirectView {
        return googleCalendarAdapter.setupConnection(request, false)
    }

    @GetMapping("/google/callback")
    fun handleGoogleOAuth2Callback(@RequestParam("code") authCode: String?): ResponseEntity<String> {
        val jwt = googleCalendarAdapter.oauth2Callback(authCode, false)
        return ResponseEntity.ok()
            .header("Authorization", "Bearer $jwt")
            .body("Authentication successful")
    }

    @PutMapping("remove-email")
    fun removeEmail(@RequestHeader(HeaderConstant.AUTHORISATION) token: String?,
                    @RequestParam("email") email: String?): ResponseEntity<String> {
        return if (token == null || email == null) {
            ResponseEntity.badRequest().body(ResponseConstant.REQUIRED_PARAMETERS_NOT_SET)
        }
        else {
            userAccountManagerService.deleteGoogleAccount(token,email)
            ResponseEntity.ok(ResponseConstant.EMAIL_REMOVED)
        }
    }
}

package com.teamcaffeine.koja.controller

import com.teamcaffeine.koja.service.GoogleCalendarAdapterService
import com.teamcaffeine.koja.service.UserAccountManagerService
import jakarta.servlet.http.HttpServletRequest
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*
import org.springframework.web.servlet.view.RedirectView

@RestController
@RequestMapping("/api/v1/auth/profile")

class UserAccountManagerController(private val googleCalendarAdapter: GoogleCalendarAdapterService,
                                   private val userAccountManagerService: UserAccountManagerService) {

    @GetMapping("addEmail/google")
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

    @DeleteMapping("/users/{userId}/emails/{email}")
    fun removeEmail(
        @PathVariable userId: String,
        @PathVariable email: String
    ) {
        userAccountManagerService.removeEmailAddress(userId, email)
    }
}

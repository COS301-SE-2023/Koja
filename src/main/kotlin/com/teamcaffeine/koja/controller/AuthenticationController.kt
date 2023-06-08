package com.teamcaffeine.koja.controller

import com.teamcaffeine.koja.entity.GoogleCalendarAdapter
import jakarta.servlet.http.HttpServletRequest
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RequestParam
import org.springframework.web.bind.annotation.RestController
import org.springframework.web.servlet.view.RedirectView

@RestController
class AuthenticationController(private val googleCalendarAdapter: GoogleCalendarAdapter) {

	@GetMapping("/auth/google")
	fun authenticateWithGoogle(request: HttpServletRequest): RedirectView {
		return googleCalendarAdapter.setupConnection(request)
	}

	@GetMapping("/auth/google/callback")
	fun handleGoogleOAuth2Callback(@RequestParam("code") authCode: String?): ResponseEntity<String> {
		return googleCalendarAdapter.oauth2Callback(authCode)
	}
}
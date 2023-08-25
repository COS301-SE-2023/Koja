package com.teamcaffeine.koja.controller

import com.teamcaffeine.koja.enums.CallbackConfigEnum
import com.teamcaffeine.koja.service.GoogleCalendarAdapterService
import jakarta.servlet.http.HttpServletRequest
import jakarta.transaction.Transactional
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RequestParam
import org.springframework.web.bind.annotation.RestController
import org.springframework.web.servlet.view.RedirectView

@RestController
@RequestMapping("/api/v1/auth")
class AuthenticationController(private val googleCalendarAdapter: GoogleCalendarAdapterService) {

    @GetMapping("/google")
    fun authenticateWithGoogle(request: HttpServletRequest): RedirectView {
        return googleCalendarAdapter.setupConnection(request, CallbackConfigEnum.WEB)
    }

    @Transactional
    @GetMapping("/google/callback")
    fun handleGoogleOAuth2Callback(@RequestParam("code") authCode: String?): ResponseEntity<String> {
        val jwt = googleCalendarAdapter.oauth2Callback(authCode, CallbackConfigEnum.WEB)
        return ResponseEntity.ok()
            .header("Authorization", "Bearer $jwt")
            .body("Authentication successful")
    }

    @GetMapping("/app/google")
    fun authenticateWithGoogleApp(request: HttpServletRequest): RedirectView {
        return googleCalendarAdapter.setupConnection(request, CallbackConfigEnum.MOBILE)
    }

    @Transactional
    @GetMapping("/app/google/callback")
    fun handleGoogleOAuth2CallbackApp(@RequestParam("code") authCode: String?): RedirectView {
        val jwt = googleCalendarAdapter.oauth2Callback(authCode, CallbackConfigEnum.MOBILE)
        return RedirectView("koja-login-callback://callback?token=$jwt")
    }

    @GetMapping("/desktop/google")
    fun authenticateWithGoogleDesktop(request: HttpServletRequest): RedirectView {
        return googleCalendarAdapter.setupConnection(request, CallbackConfigEnum.DESKTOP)
    }

    @Transactional
    @GetMapping("/desktop/google/callback")
    fun handleGoogleOAuth2CallbackDesktop(@RequestParam("code") authCode: String?): ResponseEntity<String> {
        val jwt = googleCalendarAdapter.oauth2Callback(authCode, CallbackConfigEnum.DESKTOP)
        return ResponseEntity.ok()
            .header("Authorization", "Bearer $jwt")
            .body("Authentication successful")
    }

}

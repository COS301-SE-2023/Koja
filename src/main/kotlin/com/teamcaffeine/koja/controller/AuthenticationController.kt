package com.teamcaffeine.koja.controller

import com.google.gson.Gson
import com.teamcaffeine.koja.service.GoogleCalendarAdapterService
import jakarta.servlet.http.HttpServletRequest
import jakarta.transaction.Transactional
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RequestParam
import org.springframework.web.bind.annotation.RestController
import org.springframework.web.servlet.view.RedirectView
import java.nio.charset.StandardCharsets
import java.nio.file.Files
import java.nio.file.Paths
import org.springframework.core.io.Resource
import org.springframework.core.io.ClassPathResource



@RestController
@RequestMapping("/api/v1/auth")
class AuthenticationController(private val googleCalendarAdapter: GoogleCalendarAdapterService) {

    private val publicKeyResource: Resource = ClassPathResource("public_key.pem")

    @GetMapping("/google")
    fun authenticateWithGoogle(request: HttpServletRequest): RedirectView {
        return googleCalendarAdapter.setupConnection(request, false)
    }

    @Transactional
    @GetMapping("/google/callback")
    fun handleGoogleOAuth2Callback(@RequestParam("code") authCode: String?): ResponseEntity<String> {
        val jwt = googleCalendarAdapter.oauth2Callback(authCode, false)
        return ResponseEntity.ok()
            .header("Authorization", "Bearer $jwt")
            .body("Authentication successful")
    }

    @GetMapping("/app/google")
    fun authenticateWithGoogleApp(request: HttpServletRequest): RedirectView {
        return googleCalendarAdapter.setupConnection(request, true)
    }

    @Transactional
    @GetMapping("/app/google/callback")
    fun handleGoogleOAuth2CallbackApp(@RequestParam("code") authCode: String?): RedirectView {
        val jwt = googleCalendarAdapter.oauth2Callback(authCode, true)
        return RedirectView("koja-login-callback://callback?token=$jwt")
    }

    @GetMapping("/koja/public-key")
    fun getPublicKey(): ResponseEntity<String> {
        val publicKeyBytes = publicKeyResource.inputStream.readAllBytes()
        val publicKeyBase64 = String(publicKeyBytes, StandardCharsets.UTF_8)
        val gson = Gson()
        return ResponseEntity.ok(gson.toJson(publicKeyBase64))
    }
}

package com.teamcaffeine.koja.service

import com.teamcaffeine.koja.enums.AuthProviderEnum
import jakarta.servlet.http.HttpServletRequest
import org.springframework.http.ResponseEntity
import org.springframework.stereotype.Service
import org.springframework.web.servlet.view.RedirectView

@Service
abstract class CalendarAdapterService(authProvider : AuthProviderEnum) {
    private val authProviderEnum: AuthProviderEnum = authProvider

    abstract fun setupConnection(request: HttpServletRequest?) : RedirectView
    abstract fun authorize(): String?
    abstract fun oauth2Callback(authCode: String?): ResponseEntity<String>
    abstract fun getEvents(): Set<UserEventService?>?
    abstract fun getUserEvents(jwtToken: String): List<UserEventService>

    fun getAuthProvider(): AuthProviderEnum {
        return authProviderEnum
    }
}
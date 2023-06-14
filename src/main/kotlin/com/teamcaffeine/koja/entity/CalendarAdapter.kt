package com.teamcaffeine.koja.entity

import com.teamcaffeine.koja.enums.AuthProviderEnum
import jakarta.servlet.http.HttpServletRequest
import org.springframework.http.ResponseEntity
import org.springframework.web.servlet.view.RedirectView


abstract class CalendarAdapter(authProvider : AuthProviderEnum) {
    private val authProviderEnum: AuthProviderEnum = authProvider

    abstract fun setupConnection(request: HttpServletRequest?) : RedirectView
    abstract fun authorize(): String?
    abstract fun oauth2Callback(authCode: String?): ResponseEntity<String>
    abstract fun getEvents(): Set<UserEvent?>?
    abstract fun getUserEvents(userId: String?): List<UserEvent>

    fun getAuthProvider(): AuthProviderEnum {
        return authProviderEnum
    }
}
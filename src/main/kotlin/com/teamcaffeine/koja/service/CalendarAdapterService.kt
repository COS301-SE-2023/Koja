package com.teamcaffeine.koja.service

import com.teamcaffeine.koja.dto.UserEventDTO
import com.teamcaffeine.koja.enums.AuthProviderEnum
import jakarta.servlet.http.HttpServletRequest
import org.springframework.stereotype.Service
import org.springframework.web.servlet.view.RedirectView

@Service
abstract class CalendarAdapterService(authProvider: AuthProviderEnum) {
    private val authProviderEnum: AuthProviderEnum = authProvider

    abstract fun setupConnection(request: HttpServletRequest?): RedirectView
    abstract fun authorize(): String?
    abstract fun oauth2Callback(authCode: String?): String
    abstract fun getUserEvents(accessToken: String): List<UserEventDTO>

    abstract fun getUserEmail(accessToken: String): String?

    fun getAuthProvider(): AuthProviderEnum {
        return authProviderEnum
    }
}

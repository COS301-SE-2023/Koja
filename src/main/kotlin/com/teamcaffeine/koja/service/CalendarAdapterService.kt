package com.teamcaffeine.koja.service

import com.google.api.services.calendar.model.Event
import com.teamcaffeine.koja.dto.UserEventDTO
import com.teamcaffeine.koja.enums.AuthProviderEnum
import jakarta.servlet.http.HttpServletRequest
import org.springframework.stereotype.Service
import org.springframework.web.servlet.view.RedirectView
import java.util.Date

@Service
abstract class CalendarAdapterService(authProvider: AuthProviderEnum) {
    private val authProviderEnum: AuthProviderEnum = authProvider

    abstract fun setupConnection(request: HttpServletRequest?, appCallBack: Boolean): RedirectView
    abstract fun authorize(): String?
    abstract fun oauth2Callback(authCode: String?): String
    abstract fun getUserEvents(accessToken: String): List<UserEventDTO>

    abstract fun getUserEventsInRange(accessToken: String, startDate: Date, endDate: Date): List<UserEventDTO>

    abstract fun getUserEmail(accessToken: String): String?

    abstract fun createEvent(accessToken: String, eventDTO: UserEventDTO): Event

    fun getAuthProvider(): AuthProviderEnum {
        return authProviderEnum
    }
}

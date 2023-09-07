package com.teamcaffeine.koja.service

import com.google.api.services.calendar.model.Event
import com.teamcaffeine.koja.dto.JWTAuthDetailsDTO
import com.teamcaffeine.koja.dto.UserEventDTO
import com.teamcaffeine.koja.enums.AuthProviderEnum
import com.teamcaffeine.koja.enums.CallbackConfigEnum
import jakarta.servlet.http.HttpServletRequest
import org.springframework.stereotype.Service
import org.springframework.web.servlet.view.RedirectView
import java.time.OffsetDateTime

@Service
abstract class CalendarAdapterService(authProvider: AuthProviderEnum) {
    private val authProviderEnum: AuthProviderEnum = authProvider
    abstract fun setupConnection(
        request: HttpServletRequest?,
        deviceType: CallbackConfigEnum,
        addAdditionalAccount: Boolean = false,
        token: String = "",
    ): RedirectView
    abstract fun authorize(): String?
    abstract fun oauth2Callback(authCode: String?, deviceType: CallbackConfigEnum): String
    abstract fun getUserEvents(accessToken: String): Map<String, UserEventDTO>

    abstract fun getUserEventsInRange(accessToken: String?, startDate: OffsetDateTime?, endDate: OffsetDateTime?): List<UserEventDTO>

    abstract fun getUserEmail(accessToken: String): String?

    abstract fun createEvent(accessToken: String, eventDTO: UserEventDTO, jwtToken: String): Event

    abstract fun updateEvent(accessToken: String, eventDTO: UserEventDTO): Event

    abstract fun deleteEvent(accessToken: String, eventID: String): Boolean

    abstract fun refreshAccessToken(clientId: String, clientSecret: String, refreshToken: String): JWTAuthDetailsDTO?

    abstract fun getFutureEventsLocations(accessToken: String?): List<String>

    fun getAuthProvider(): AuthProviderEnum {
        return authProviderEnum
    }
}

package com.teamcaffeine.koja.entity

import jakarta.servlet.http.HttpServletRequest
import org.springframework.http.ResponseEntity
import org.springframework.web.servlet.view.RedirectView


interface CalendarAdapter {
    fun setupConnection(request: HttpServletRequest?) : RedirectView
    fun authorize(): String?
    fun oauth2Callback(authCode: String?): ResponseEntity<String>
    fun getEvents(): Set<UserEvent?>?
    fun getUserEvents(userId: String?): List<UserEvent>
}
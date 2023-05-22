package com.teamcaffeine.koja

import com.google.api.client.googleapis.auth.oauth2.GoogleAuthorizationCodeFlow
import com.google.api.client.util.DateTime
import com.google.auth.oauth2.GoogleCredentials
import com.teamcaffeine.koja.controller.GoogleCalendarController
import com.teamcaffeine.koja.entity.Event
import com.teamcaffeine.koja.service.GoogleCalendarService
import org.junit.jupiter.api.Test
import org.springframework.boot.test.context.SpringBootTest
import org.junit.jupiter.api.Assertions.*
import org.mockito.Mockito.*
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import java.util.*


@SpringBootTest
class KojaApplicationTests {

	@Test
	fun contextLoads() {
	}
}


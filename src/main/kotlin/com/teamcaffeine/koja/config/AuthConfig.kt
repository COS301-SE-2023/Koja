package com.teamcaffeine.koja.config

import com.teamcaffeine.koja.entity.GoogleCalendarAdapter
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration

@Configuration
class AuthConfig {
	@Bean
	fun googleCalendarAdapter(): GoogleCalendarAdapter {
		return GoogleCalendarAdapter()
	}
}
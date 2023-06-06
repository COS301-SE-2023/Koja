package com.teamcaffeine.koja

import io.github.cdimascio.dotenv.Dotenv
import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.runApplication
import java.lang.System.setProperty

@SpringBootApplication
class KojaApplication

fun main(args: Array<String>) {
	val dotenv: Dotenv = Dotenv.load()

	setProperty("KOJA_AWS_RDS_DATABASE_URL", dotenv["KOJA_AWS_RDS_DATABASE_URL"]!!)
	setProperty("KOJA_AWS_RDS_DATABASE_ADMIN_USERNAME", dotenv["KOJA_AWS_RDS_DATABASE_ADMIN_USERNAME"]!!)
	setProperty("KOJA_AWS_RDS_DATABASE_ADMIN_PASSWORD", dotenv["KOJA_AWS_RDS_DATABASE_ADMIN_PASSWORD"]!!)

	// Set Google Sign In client ID and client secret properties
	setProperty("spring.security.oauth2.client.registration.google.client-id", dotenv["GOOGLE_CLIENT_ID"]!!)
	setProperty("spring.security.oauth2.client.registration.google.client-secret", dotenv["GOOGLE_CLIENT_SECRET"]!!)

	runApplication<KojaApplication>(*args)
}
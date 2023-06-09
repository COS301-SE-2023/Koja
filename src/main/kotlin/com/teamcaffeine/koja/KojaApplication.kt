package com.teamcaffeine.koja

import io.github.cdimascio.dotenv.Dotenv
import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.autoconfigure.security.servlet.SecurityAutoConfiguration
import org.springframework.boot.runApplication
import java.lang.System.setProperty

@SpringBootApplication(exclude = [SecurityAutoConfiguration::class])
class KojaApplication

fun main(args: Array<String>) {
    val dotenv: Dotenv = Dotenv.load()

    setProperty("KOJA_AWS_RDS_DATABASE_URL", dotenv["KOJA_AWS_RDS_DATABASE_URL"]!!)
    setProperty("KOJA_AWS_RDS_DATABASE_ADMIN_USERNAME", dotenv["KOJA_AWS_RDS_DATABASE_ADMIN_USERNAME"]!!)
    setProperty("KOJA_AWS_RDS_DATABASE_ADMIN_PASSWORD", dotenv["KOJA_AWS_RDS_DATABASE_ADMIN_PASSWORD"]!!)

    // Set Google Sign In client ID and client secret properties
    setProperty("GOOGLE_CLIENT_ID", dotenv["GOOGLE_CLIENT_ID"]!!)
    setProperty("GOOGLE_CLIENT_SECRET", dotenv["GOOGLE_CLIENT_SECRET"]!!)
    setProperty("API_KEY", dotenv["API_KEY"]!!)

    // Set JWT secret key property
    setProperty("KOJA_JWT_SECRET", dotenv["KOJA_JWT_SECRET"]!!)

    runApplication<KojaApplication>(*args)
}

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
    setProperty("KOJA_AWS_DYNAMODB_ACCESS_KEY_ID", dotenv["KOJA_AWS_DYNAMODB_ACCESS_KEY_ID"]!!)
    setProperty("KOJA_AWS_DYNAMODB_ACCESS_KEY_SECRET", dotenv["KOJA_AWS_DYNAMODB_ACCESS_KEY_SECRET"]!!)
    setProperty("OPENAI_API_KEY", dotenv["OPENAI_API_KEY"]!!)
    setProperty("SERVER_ADDRESS", dotenv["SERVER_ADDRESS"]!!)
    setProperty("SERVER_PORT", dotenv["SERVER_PORT"]!!)

    // Set Google Sign In client ID and client secret properties
    setProperty("GOOGLE_CLIENT_ID", dotenv["GOOGLE_CLIENT_ID"]!!)
    setProperty("GOOGLE_CLIENT_SECRET", dotenv["GOOGLE_CLIENT_SECRET"]!!)
    setProperty("API_KEY", dotenv["API_KEY"]!!)

    // Set JWT secret key property
    setProperty("KOJA_JWT_SECRET", dotenv["KOJA_JWT_SECRET"]!!)
    setProperty("KOJA_ID_SECRET", dotenv["KOJA_ID_SECRET"]!!)

    runApplication<KojaApplication>(*args)
}

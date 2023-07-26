package com.teamcaffiene.koja.service

import io.github.cdimascio.dotenv.Dotenv
import org.junit.jupiter.api.extension.BeforeEachCallback
import org.junit.jupiter.api.extension.ExtensionContext

class CustomExtension : BeforeEachCallback {
    @Throws(Exception::class)
    override fun beforeEach(context: ExtensionContext) {
        val dotenv: Dotenv = Dotenv.load()

        System.setProperty("KOJA_AWS_RDS_DATABASE_URL", dotenv["KOJA_AWS_RDS_DATABASE_URL"]!!)
        System.setProperty("KOJA_AWS_RDS_DATABASE_ADMIN_USERNAME", dotenv["KOJA_AWS_RDS_DATABASE_ADMIN_USERNAME"]!!)
        System.setProperty("KOJA_AWS_RDS_DATABASE_ADMIN_PASSWORD", dotenv["KOJA_AWS_RDS_DATABASE_ADMIN_PASSWORD"]!!)

        // Set Google Sign In client ID and client secret properties
        System.setProperty("GOOGLE_CLIENT_ID", dotenv["GOOGLE_CLIENT_ID"]!!)
        System.setProperty("GOOGLE_CLIENT_SECRET", dotenv["GOOGLE_CLIENT_SECRET"]!!)
        System.setProperty("API_KEY", dotenv["API_KEY"]!!)

        // Set JWT secret key property
        System.setProperty("KOJA_JWT_SECRET", dotenv["KOJA_JWT_SECRET"]!!)
    }
}

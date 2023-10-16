package com.teamcaffiene.koja.service

import com.teamcaffeine.koja.constants.EnvironmentVariableConstant
import io.github.cdimascio.dotenv.Dotenv
import org.junit.jupiter.api.extension.BeforeEachCallback
import org.junit.jupiter.api.extension.ExtensionContext

class CustomExtension : BeforeEachCallback {
    @Throws(Exception::class)
    override fun beforeEach(context: ExtensionContext) {
        val dotenv: Dotenv = Dotenv.load()

        System.setProperty(
            EnvironmentVariableConstant.KOJA_AWS_RDS_DATABASE_URL,
            dotenv[EnvironmentVariableConstant.KOJA_AWS_RDS_DATABASE_URL]!!,
        )
        System.setProperty(
            EnvironmentVariableConstant.KOJA_AWS_RDS_DATABASE_ADMIN_USERNAME,
            dotenv[EnvironmentVariableConstant.KOJA_AWS_RDS_DATABASE_ADMIN_USERNAME]!!,
        )
        System.setProperty(
            EnvironmentVariableConstant.KOJA_AWS_RDS_DATABASE_ADMIN_PASSWORD,
            dotenv[EnvironmentVariableConstant.KOJA_AWS_RDS_DATABASE_ADMIN_PASSWORD]!!,
        )

        // Set Google Sign In client ID and client secret properties
        System.setProperty(
            EnvironmentVariableConstant.GOOGLE_CLIENT_ID,
            dotenv[EnvironmentVariableConstant.GOOGLE_CLIENT_ID]!!,
        )
        System.setProperty(
            EnvironmentVariableConstant.GOOGLE_CLIENT_SECRET,
            dotenv[EnvironmentVariableConstant.GOOGLE_CLIENT_SECRET]!!,
        )
        System.setProperty(
            EnvironmentVariableConstant.GOOGLE_MAPS_API_KEY,
            dotenv[EnvironmentVariableConstant.GOOGLE_MAPS_API_KEY]!!,
        )

        // Set JWT secret key property
        System.setProperty(
            EnvironmentVariableConstant.KOJA_JWT_SECRET,
            dotenv[EnvironmentVariableConstant.KOJA_JWT_SECRET]!!,
        )
    }
}

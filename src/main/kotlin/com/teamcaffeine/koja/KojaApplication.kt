package com.teamcaffeine.koja

import com.teamcaffeine.koja.constants.EnvironmentVariableConstant
import io.github.cdimascio.dotenv.Dotenv
import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.autoconfigure.security.servlet.SecurityAutoConfiguration
import org.springframework.boot.runApplication
import java.lang.System.setProperty

@SpringBootApplication(exclude = [SecurityAutoConfiguration::class])
class KojaApplication

fun main(args: Array<String>) {
    val dotenv: Dotenv = Dotenv.load()

    setProperty(
        EnvironmentVariableConstant.KOJA_AWS_RDS_DATABASE_URL,
        dotenv[EnvironmentVariableConstant.KOJA_AWS_RDS_DATABASE_URL]!!,
    )
    setProperty(
        EnvironmentVariableConstant.KOJA_AWS_RDS_DATABASE_ADMIN_USERNAME,
        dotenv[EnvironmentVariableConstant.KOJA_AWS_RDS_DATABASE_ADMIN_USERNAME]!!,
    )
    setProperty(
        EnvironmentVariableConstant.KOJA_AWS_RDS_DATABASE_ADMIN_PASSWORD,
        dotenv[EnvironmentVariableConstant.KOJA_AWS_RDS_DATABASE_ADMIN_PASSWORD]!!,
    )
    setProperty(
        EnvironmentVariableConstant.KOJA_AWS_DYNAMODB_ACCESS_KEY_ID,
        dotenv[EnvironmentVariableConstant.KOJA_AWS_DYNAMODB_ACCESS_KEY_ID]!!,
    )
    setProperty(
        EnvironmentVariableConstant.KOJA_AWS_DYNAMODB_ACCESS_KEY_SECRET,
        dotenv[EnvironmentVariableConstant.KOJA_AWS_DYNAMODB_ACCESS_KEY_SECRET]!!,
    )
    setProperty(
        EnvironmentVariableConstant.OPENAI_API_KEY,
        dotenv[EnvironmentVariableConstant.OPENAI_API_KEY]!!,
    )
    setProperty(
        EnvironmentVariableConstant.SERVER_ADDRESS,
        dotenv[EnvironmentVariableConstant.SERVER_ADDRESS]!!,
    )
    setProperty(
        EnvironmentVariableConstant.SERVER_PORT,
        dotenv[EnvironmentVariableConstant.SERVER_PORT] ?: "",
    )
    // Set Google Sign In client ID and client secret properties
    setProperty(
        EnvironmentVariableConstant.GOOGLE_CLIENT_ID,
        dotenv[EnvironmentVariableConstant.GOOGLE_CLIENT_ID]!!,
    )
    setProperty(
        EnvironmentVariableConstant.GOOGLE_CLIENT_SECRET,
        dotenv[EnvironmentVariableConstant.GOOGLE_CLIENT_SECRET]!!,
    )
    setProperty(
        EnvironmentVariableConstant.GOOGLE_MAPS_API_KEY,
        dotenv[EnvironmentVariableConstant.GOOGLE_MAPS_API_KEY]!!,
    )

    // Set JWT secret key property
    setProperty(
        EnvironmentVariableConstant.KOJA_JWT_SECRET,
        dotenv[EnvironmentVariableConstant.KOJA_JWT_SECRET]!!,
    )
    setProperty(
        EnvironmentVariableConstant.KOJA_ID_SECRET,
        dotenv[EnvironmentVariableConstant.KOJA_ID_SECRET]!!,
    )
    setProperty(
        EnvironmentVariableConstant.KOJA_PRIVATE_KEY_PASS,
        dotenv[EnvironmentVariableConstant.KOJA_PRIVATE_KEY_PASS]!!,
    )
    setProperty(
        EnvironmentVariableConstant.KOJA_PRIVATE_KEY_SALT,
        dotenv[EnvironmentVariableConstant.KOJA_PRIVATE_KEY_SALT]!!,
    )

    runApplication<KojaApplication>(*args)
}

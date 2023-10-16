package com.teamcaffeine.koja

import com.google.cloud.secretmanager.v1.SecretManagerServiceClient
import com.google.cloud.secretmanager.v1.SecretVersionName
import com.teamcaffeine.koja.constants.EnvironmentVariableConstant
import io.github.cdimascio.dotenv.Dotenv
import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.autoconfigure.security.servlet.SecurityAutoConfiguration
import org.springframework.boot.runApplication
import java.lang.System.setProperty

@SpringBootApplication(exclude = [SecurityAutoConfiguration::class])
class KojaApplication

const val envSecretVersion = "latest"
const val projectId = "koja-401505"

fun getSecret(projectId: String, secretId: String, versionId: String): String {
    SecretManagerServiceClient.create().use { client ->
        val secretVersionName = SecretVersionName.of(projectId, secretId, versionId)
        val response = client.accessSecretVersion(secretVersionName)
        return response.payload.data.toStringUtf8()
    }
}

fun main(args: Array<String>) {
    val dotenv: Dotenv = Dotenv.load()

    EnvironmentVariableConstant.asMap.forEach { (key, secretName) ->
        val valueFromEnv = dotenv[key]
        val finalValue = valueFromEnv ?: getSecret(projectId, secretName, envSecretVersion)
        setProperty(key, finalValue)
    }

    runApplication<KojaApplication>(*args)
}

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

	runApplication<KojaApplication>(*args)
}

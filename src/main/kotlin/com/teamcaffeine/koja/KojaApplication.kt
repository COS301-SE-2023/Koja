package com.teamcaffeine.koja

import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.runApplication

@SpringBootApplication
class KojaApplication

fun main(args: Array<String>) {
	runApplication<KojaApplication>(*args)
}

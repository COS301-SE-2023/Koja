import org.jetbrains.kotlin.gradle.tasks.KotlinCompile

		plugins {
			id("org.springframework.boot") version "3.0.6"
			id("io.spring.dependency-management") version "1.1.0"
			kotlin("jvm") version "1.7.22"
			kotlin("plugin.spring") version "1.7.22"
			kotlin("plugin.jpa") version "1.7.22"
		}

group = "com.team-caffeine"
version = "0.0.1-SNAPSHOT"
java.sourceCompatibility = JavaVersion.VERSION_17

repositories {
	mavenCentral()
}

dependencies {
	implementation("org.springframework.boot:spring-boot-starter-data-jpa")
	implementation("org.springframework.boot:spring-boot-starter-web")
	implementation("com.fasterxml.jackson.module:jackson-module-kotlin")
	implementation("org.jetbrains.kotlin:kotlin-reflect")
	developmentOnly("org.springframework.boot:spring-boot-devtools")
	runtimeOnly("com.mysql:mysql-connector-j")
	testImplementation("org.springframework.boot:spring-boot-starter-test")
	testImplementation("org.springframework.security:spring-security-test")
	implementation ("com.google.auth:google-auth-library-oauth2-http:1.3.0")
	implementation("com.google.apis:google-api-services-calendar:v3-rev411-1.25.0")
	implementation("com.google.api-client:google-api-client-java6:1.31.0")
	implementation ("org.springframework.boot:spring-boot-starter")
	implementation ("io.github.cdimascio:java-dotenv:5.2.2")
	implementation ("com.google.apis:google-api-services-sqladmin:v1beta4-rev35-1.22.0")
	implementation ("com.google.api-client:google-api-client:1.31.1")
	implementation("org.springframework.boot:spring-boot-starter-security")



	testImplementation("com.h2database:h2")
}


tasks.withType<KotlinCompile> {
	kotlinOptions {
		freeCompilerArgs = listOf("-Xjsr305=strict")
		jvmTarget = "17"
	}
}

tasks.withType<Test> {
	useJUnitPlatform()
}
import org.jetbrains.kotlin.gradle.tasks.KotlinCompile

plugins {
    id("org.springframework.boot") version "3.0.6"
    id("io.spring.dependency-management") version "1.1.0"
    kotlin("jvm") version "1.7.22"
    kotlin("plugin.spring") version "1.7.22"
    kotlin("plugin.jpa") version "1.7.22"
    id("org.jlleitschuh.gradle.ktlint") version "10.3.0"
    id("jacoco")
    id("com.adarshr.test-logger") version "3.2.0"
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
    implementation("org.springframework.boot:spring-boot-starter-web")
    implementation("com.fasterxml.jackson.module:jackson-module-kotlin")
    implementation("org.jetbrains.kotlin:kotlin-reflect")
    developmentOnly("org.springframework.boot:spring-boot-devtools")
    runtimeOnly("com.mysql:mysql-connector-j")
    implementation("org.springframework.boot:spring-boot-starter-oauth2-client")
    implementation("com.auth0:java-jwt:3.18.2")
    testImplementation("org.springframework.boot:spring-boot-starter-test")
    testImplementation("org.springframework.security:spring-security-test")
    implementation("com.google.auth:google-auth-library-oauth2-http:1.3.0")
    implementation("com.google.apis:google-api-services-calendar:v3-rev411-1.25.0")
    implementation("org.springframework.boot:spring-boot-starter-security")
    implementation("com.google.apis:google-api-services-sqladmin:v1beta4-rev35-1.22.0")
    implementation("com.google.api-client:google-api-client-java6:1.31.0")
    implementation("org.springframework.boot:spring-boot-starter")
    implementation("io.github.cdimascio:java-dotenv:5.2.2")
    implementation("com.google.apis:google-api-services-sqladmin:v1beta4-rev35-1.22.0")
    implementation("com.google.api-client:google-api-client:1.31.1")
    implementation("com.google.maps:google-maps-services:0.15.0")
    implementation("com.google.auth:google-auth-library-oauth2-http:1.17.0")
    implementation("com.google.oauth-client:google-oauth-client-jetty:1.34.1")
    implementation("io.jsonwebtoken:jjwt:0.9.1")
    implementation("com.google.apis:google-api-services-people:v1-rev537-1.25.0")
    testImplementation("com.h2database:h2")
    testImplementation("io.mockk:mockk:1.9.3")
    testImplementation("org.mockito:mockito-core:3.12.4")
    testImplementation("org.junit.jupiter:junit-jupiter-api:5.7.0")
    testRuntimeOnly("org.junit.jupiter:junit-jupiter-engine:5.7.0")
    testImplementation("org.mockito.kotlin:mockito-kotlin:5.0.0")
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

allprojects {
    apply(plugin = "org.jetbrains.kotlin.jvm")
}

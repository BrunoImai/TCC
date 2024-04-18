plugins {
    id("org.springframework.boot") version "3.0.5"
    id("io.spring.dependency-management") version "1.1.0"
    kotlin("jvm") version "1.9.21"
    kotlin("plugin.spring") version "1.7.22"
    kotlin("plugin.jpa") version "1.7.22"
}

tasks.withType<org.jetbrains.kotlin.gradle.tasks.KotlinCompile> {
    kotlinOptions {
        jvmTarget = "18"
    }
}


group = "age.server"
version = "0.0.4-SNAPSHOT"

repositories {
    mavenCentral()
}

dependencies {
    testImplementation("org.jetbrains.kotlin:kotlin-test")
    implementation("org.springframework.boot:spring-boot-starter-validation")
    implementation("mysql:mysql-connector-java:8.0.33")
    implementation("org.springframework.boot:spring-boot-starter-web")
    implementation("org.springframework.boot:spring-boot-starter-data-jpa")
    implementation("org.springframework.boot:spring-boot-starter-security")
    annotationProcessor("org.springframework.boot:spring-boot-configuration-processor")

    implementation("com.fasterxml.jackson.module:jackson-module-kotlin")
    implementation("org.jetbrains.kotlin:kotlin-reflect")

    implementation("org.springdoc:springdoc-openapi-starter-webmvc-ui:2.1.0")

    implementation("io.jsonwebtoken:jjwt-api:0.11.5")
    implementation("io.jsonwebtoken:jjwt-jackson:0.11.5")
    runtimeOnly("io.jsonwebtoken:jjwt-impl:0.11.5")

    runtimeOnly("com.h2database:h2")

    testImplementation("org.springframework.boot:spring-boot-starter-test")
    testImplementation("io.mockk:mockk:1.13.5")
    testImplementation("io.kotest:kotest-runner-junit5-jvm:5.6.2")

    implementation ("software.amazon.awssdk:ses:2.25.22")

    implementation("com.amazonaws:aws-java-sdk-ses:1.12.701")

    runtimeOnly("io.kotest:kotest-assertions-core:5.6.2")

    implementation ("software.amazon.awssdk:ses:2.25.26")

    implementation("de.mkammerer:argon2-jvm:2.11")
}

tasks.test {
    useJUnitPlatform()
}
kotlin {
    jvmToolchain(18)
}
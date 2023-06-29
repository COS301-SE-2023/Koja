package com.teamcaffeine.koja.controller

import org.springframework.beans.factory.annotation.Autowired
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.jdbc.core.JdbcTemplate
import org.springframework.web.bind.annotation.GetMapping
<<<<<<< HEAD:src/main/kotlin/com/teamcaffeine/koja/controller/TransferController.kt
=======
import org.springframework.web.bind.annotation.RequestMapping
>>>>>>> d075a8edfcf0503bd2778e6b3d7b1d8fba6186f9:src/main/kotlin/com/teamcaffeine/koja/controller/HealthCheckController.kt
import org.springframework.web.bind.annotation.RestController
import javax.sql.DataSource

@RestController
@RequestMapping("/api/v1/health")
class HealthCheckController(@Autowired val dataSource: DataSource) {

    @GetMapping()
    fun healthCheck(): ResponseEntity<Any> {
        val healthStatus = checkHealthStatus()

        return if (healthStatus) {
            ResponseEntity.ok().body(
                mapOf(
                    "status" to Status.RUNNING,
                )
            )
        } else {
            ResponseEntity.status(HttpStatus.SERVICE_UNAVAILABLE).body(
                mapOf(
                    "status" to Status.DOWN,
                )
            )
        }
    }

    @GetMapping("/detail")
    fun detailedHealthCheck(): ResponseEntity<Any> {
        val healthStatus = checkDetailedHealthStatus()
        for (hs in healthStatus) {
            if (!hs.working) {
                return ResponseEntity.status(HttpStatus.SERVICE_UNAVAILABLE).body(
                    mapOf(
                        "status" to Status.DOWN,
                        "breakdown" to healthStatus.map { it.message },
                    )
                )
            }
        }
        return ResponseEntity.ok().body(
            mapOf(
                "status" to Status.RUNNING,
                "breakdown" to healthStatus.map { it.message },
            )
        )
    }

    private fun checkHealthStatus(): Boolean {
        return try {
            val jdbcTemplate = JdbcTemplate(dataSource)
            jdbcTemplate.execute("SELECT 1")
            true
        } catch (exception: Exception) {
            false
        }
    }

    private fun checkDetailedHealthStatus(): List<HealthStatus> {
        val result = mutableListOf<HealthStatus>()
        try {
            val jdbcTemplate = JdbcTemplate(dataSource)
            jdbcTemplate.execute("SELECT 1")
            result.add(HealthStatus(true, "Database Connection ✅"))
        } catch (exception: Exception) {
            result.add(HealthStatus(true, "Database Connection ❎"))
        }
        return result
    }
}

class HealthStatus(val working: Boolean, val message: String)

enum class Status {
    RUNNING,
    DOWN,
}

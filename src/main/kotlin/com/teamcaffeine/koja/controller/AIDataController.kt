package com.teamcaffeine.koja.controller

import com.google.gson.*
import com.teamcaffeine.koja.constants.HeaderConstant
import com.teamcaffeine.koja.constants.ResponseConstant
import com.teamcaffeine.koja.repository.UserAccountRepository
import com.teamcaffeine.koja.service.AIUserDataService
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RequestHeader
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController
import java.lang.reflect.Type
import java.time.OffsetDateTime
import java.time.format.DateTimeFormatter

@RestController
@RequestMapping("/api/v1/ai")
class AIDataController(private val userAccountRepository: UserAccountRepository, private val aiUserDataService: AIUserDataService) {
    @GetMapping("/all-users-events")
    fun getUserEventData(@RequestHeader(HeaderConstant.AUTHORISATION) token: String?): ResponseEntity<out Any> {
        return if (token == null) {
            ResponseEntity.badRequest().body(ResponseConstant.REQUIRED_PARAMETERS_NOT_SET)
//        } else if (token != System.getProperty("KOJA_JWT_SECRET")) {
//            ResponseEntity<String>("Unauthorized", HttpStatus.UNAUTHORIZED)
        } else {
            val gsonBuilder = GsonBuilder()
            gsonBuilder.registerTypeAdapter(
                OffsetDateTime::class.java,
                OffsetDateTimeSerializer(),
            )
            gsonBuilder.registerTypeAdapter(OffsetDateTime::class.java, OffsetDateTimeDeserializer())
            val gson: Gson = gsonBuilder.setPrettyPrinting().create()
            ResponseEntity.ok(gson.toJson(aiUserDataService.getUserEventData(token)))
        }
    }

    internal class OffsetDateTimeSerializer : JsonSerializer<OffsetDateTime?> {
        override fun serialize(
            offsetDateTime: OffsetDateTime?,
            srcType: Type?,
            context: JsonSerializationContext?,
        ): JsonElement {
            return JsonPrimitive(formatter.format(offsetDateTime))
        }

        companion object {
            private val formatter = DateTimeFormatter.ofPattern("d-MMM-yyyy HH:mm:ss XXX")
        }
    }

    internal class OffsetDateTimeDeserializer : JsonDeserializer<OffsetDateTime?> {
        @Throws(JsonParseException::class)
        override fun deserialize(json: JsonElement, typeOfT: Type?, context: JsonDeserializationContext?): OffsetDateTime {
            return OffsetDateTime.parse(json.asString, formatter)
        }

        companion object {
            private val formatter = DateTimeFormatter.ofPattern("d-MMM-yyyy HH:mm:ss XXX")
        }
    }
}

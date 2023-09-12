package com.teamcaffeine.koja.controller

import com.google.gson.Gson
import com.google.gson.GsonBuilder
import com.google.gson.JsonElement
import com.google.gson.JsonPrimitive
import com.google.gson.JsonSerializationContext
import com.google.gson.JsonSerializer
import com.teamcaffeine.koja.constants.HeaderConstant
import com.teamcaffeine.koja.constants.ResponseConstant
import com.teamcaffeine.koja.dto.AIRequestBodyDTO
import com.teamcaffeine.koja.service.AIUserDataService
import com.teamcaffeine.koja.service.CryptoService
import com.teamcaffeine.koja.service.UserCalendarService
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RequestHeader
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RequestParam
import org.springframework.web.bind.annotation.RestController
import java.lang.reflect.Type
import java.security.PublicKey
import java.time.OffsetDateTime

@RestController
@RequestMapping("/api/v1/ai")
class AIDataController(private val aiUserDataService: AIUserDataService, private val userCalendarService: UserCalendarService, private val cryptoService: CryptoService) {

    @GetMapping("/get-emails")
    fun getUserEmail(@RequestHeader(HeaderConstant.AUTHORISATION) token: String?): ResponseEntity<String> {
        return if (token == null) {
            ResponseEntity.badRequest().body(ResponseConstant.REQUIRED_PARAMETERS_NOT_SET)
        } else {
            val returnableMap = mapOf(
                "502" to "u19012366@tuks.co.za",
                "552" to "u21566382@tuks.co.za",
                "553" to "lesibasetsiba02@gmail.com",
                "602" to "u20505656@tuks.co.za",
                "603" to "uunarineleo@gmail.com",
                "652" to "u21609633@tuks.co.za",
            )
            val gson = Gson()
            val jsonObject = gson.toJson(returnableMap)
            ResponseEntity.ok(jsonObject)
        }
    }

    @GetMapping("/get-user-events")
    fun getUsersSuggestions(@RequestHeader(HeaderConstant.AUTHORISATION) token: String?, @RequestParam("userID") userID: String?): ResponseEntity<String> {
        return if (token == null || userID == null) {
            ResponseEntity.badRequest().body(ResponseConstant.REQUIRED_PARAMETERS_NOT_SET)
        } else {
            val gsonBuilder = GsonBuilder()
            gsonBuilder.registerTypeAdapter(
                OffsetDateTime::class.java,
                OffsetDateTimeAdapter(),
            )
            gsonBuilder.registerTypeAdapter(OffsetDateTime::class.java, OffsetDateTimeAdapter())
            val gson: Gson = gsonBuilder.setPrettyPrinting().create()
            val userEvents = userCalendarService.getUserSuggestions(userID)
            val jsonObject = gson.toJson(userEvents)
            ResponseEntity.ok(jsonObject)
        }
    }

    @GetMapping("/get-new-user-emails")
    fun getNewUserEmails(@RequestParam("request") request: String?): ResponseEntity<String> {
        return if (request == null) {
            ResponseEntity.badRequest().body(ResponseConstant.REQUIRED_PARAMETERS_NOT_SET)
        } else {
            try {
                val req = AIRequestBodyDTO(request).encryptedData
                if (aiUserDataService.validateKojaSecretID(req.kojaIDSecret)) {
                    ResponseEntity.ok(Gson().toJson(aiUserDataService.getNewUserEmails(req)))
                } else {
                    ResponseEntity(ResponseConstant.UNAUTHORIZED, org.springframework.http.HttpStatus.UNAUTHORIZED)
                }
            } catch (e: IllegalArgumentException) {
                ResponseEntity.badRequest().body(ResponseConstant.UNAUTHORIZED)
            } catch (e: Exception) {
                ResponseEntity.badRequest().body(ResponseConstant.GENERIC_INTERNAL_ERROR)
            }
        }
    }

    @GetMapping("/get-all-user-emails")
    fun getAllUserEmails(@RequestParam("request") request: String?): ResponseEntity<String> {
        return if (request == null) {
            ResponseEntity.badRequest().body(ResponseConstant.REQUIRED_PARAMETERS_NOT_SET)
        } else {
            try {
                val req = AIRequestBodyDTO(request).encryptedData
                if (aiUserDataService.validateKojaSecretID(req.kojaIDSecret)) {
                    ResponseEntity.ok(Gson().toJson(aiUserDataService.getAllUserEmails(req)))
                } else {
                    ResponseEntity(ResponseConstant.UNAUTHORIZED, org.springframework.http.HttpStatus.UNAUTHORIZED)
                }
            } catch (e: IllegalArgumentException) {
                ResponseEntity.badRequest().body(ResponseConstant.UNAUTHORIZED)
            } catch (e: Exception) {
                ResponseEntity.badRequest().body(ResponseConstant.GENERIC_INTERNAL_ERROR)
            }
        }
    }

    @GetMapping("/get-account-events")
    fun getUserEvents(@RequestParam("request") request: String?, @RequestParam("userEmail") userEmail: String?): ResponseEntity<String> {
        return if (request == null || userEmail == null) {
            ResponseEntity.badRequest().body(ResponseConstant.REQUIRED_PARAMETERS_NOT_SET)
        } else {
            try {
                val req = AIRequestBodyDTO(request).encryptedData
                if (aiUserDataService.validateKojaSecretID(req.kojaIDSecret)) {
                    val decryptedEmail = cryptoService.decryptData(userEmail).decodeToString()
                    ResponseEntity.ok(Gson().toJson(aiUserDataService.getUserEvents(decryptedEmail, req)))
                } else {
                    ResponseEntity(ResponseConstant.UNAUTHORIZED, org.springframework.http.HttpStatus.UNAUTHORIZED)
                }
            } catch (e: IllegalArgumentException) {
                ResponseEntity.badRequest().body(ResponseConstant.UNAUTHORIZED)
            } catch (e: Exception) {
                ResponseEntity.badRequest().body(ResponseConstant.GENERIC_INTERNAL_ERROR)
            }
        }
    }

    @GetMapping("/get-public-key")
    fun getPublicKey(): ResponseEntity<String> {
        return ResponseEntity.ok(Gson().toJson(cryptoService.getPublicKey()))
    }


    class OffsetDateTimeAdapter : JsonSerializer<OffsetDateTime> {
        override fun serialize(src: OffsetDateTime, typeOfSrc: Type, context: JsonSerializationContext): JsonElement {
            return JsonPrimitive(src.toString())
        }
    }
}

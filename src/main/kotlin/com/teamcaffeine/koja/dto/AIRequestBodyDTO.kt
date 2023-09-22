package com.teamcaffeine.koja.dto

import com.google.gson.Gson

data class EncryptedData(val publicKey: String, val kojaIDSecret: String)

class AIRequestBodyDTO(jsonString: String) {

    val encryptedData: EncryptedData

    init {
        try {
            encryptedData = Gson().fromJson(jsonString, EncryptedData::class.java)
        } catch (e: Exception) {
            throw e
        }
    }
}

package com.teamcaffeine.koja.dto

import com.google.gson.Gson
import com.teamcaffeine.koja.constants.ExceptionMessageConstant
import org.bouncycastle.jce.provider.BouncyCastleProvider
import java.nio.file.Files
import java.nio.file.Paths
import java.security.KeyFactory
import java.security.PrivateKey
import java.security.Security
import java.security.spec.PKCS8EncodedKeySpec
import java.util.Base64
import javax.crypto.Cipher

data class EncryptedData(val publicKey: String, val kojaIDSecret: String)

class AIRequestBodyDTO(encryptedBody: String) {

    public var parsedData: EncryptedData?

    init {
        Security.addProvider(BouncyCastleProvider())
        val privateKey: PrivateKey = getSystemPrivateKey()
        val decryptedJson = decrypt(encryptedBody, privateKey)
        parsedData = Gson().fromJson(decryptedJson, EncryptedData::class.java)

        if (parsedData != null && parsedData!!.kojaIDSecret != System.getProperty("KOJA_ID_SECRET")) {
            throw IllegalArgumentException(ExceptionMessageConstant.INVALID_STRUCTURE)
        }
    }

    private fun decrypt(encryptedText: String, privateKey: PrivateKey): String {
        val cipher = Cipher.getInstance("RSA/ECB/PKCS1Padding", "BC")
        cipher.init(Cipher.DECRYPT_MODE, privateKey)
        return String(cipher.doFinal(Base64.getDecoder().decode(encryptedText)))
    }

    private fun loadPrivateKeyFromFile(filePath: String): PrivateKey {
        val pemContent = Files.readString(Paths.get(filePath))
        val content = pemContent.replace("-----BEGIN RSA PRIVATE KEY-----", "")
            .replace("-----END RSA PRIVATE KEY-----", "")
            .trim()

        val keyBytes = Base64.getDecoder().decode(content)
        val keyFactory = KeyFactory.getInstance("RSA")
        val keySpec = PKCS8EncodedKeySpec(keyBytes)
        return keyFactory.generatePrivate(keySpec)
    }

    private fun getSystemPrivateKey(): PrivateKey {
        return loadPrivateKeyFromFile("./private_key.pem")
    }
}

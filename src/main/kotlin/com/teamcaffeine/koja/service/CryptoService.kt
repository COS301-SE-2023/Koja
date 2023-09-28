package com.teamcaffeine.koja.service

import org.bouncycastle.asn1.pkcs.RSAPrivateKey
import org.springframework.core.io.ClassPathResource
import org.springframework.stereotype.Service
import org.springframework.util.FileCopyUtils
import java.io.File
import java.math.BigInteger
import java.security.KeyFactory
import java.security.KeyPair
import java.security.KeyPairGenerator
import java.security.PrivateKey
import java.security.PublicKey
import java.security.spec.MGF1ParameterSpec
import java.security.spec.PKCS8EncodedKeySpec
import java.security.spec.RSAPublicKeySpec
import java.security.spec.X509EncodedKeySpec
import java.util.Base64
import javax.crypto.Cipher
import javax.crypto.SecretKeyFactory
import javax.crypto.spec.IvParameterSpec
import javax.crypto.spec.OAEPParameterSpec
import javax.crypto.spec.PBEKeySpec
import javax.crypto.spec.PSource
import javax.crypto.spec.SecretKeySpec

@Service
class CryptoService {

    private val privateKeyDir = "keys"
    private val privateKeyPath = "$privateKeyDir/private_key.pem"
    private val passphrase = System.getProperty("KOJA_PRIVATE_KEY_PASS")
    private val salt = System.getProperty("KOJA_PRIVATE_KEY_SALT")
    private val keyPair: KeyPair

    init {
        keyPair = getKeyPair()
    }

    private fun getKeyPair(): KeyPair {
        val classPathResource = ClassPathResource(privateKeyPath)
        val keyPairGenerator = KeyPairGenerator.getInstance("RSA")
        keyPairGenerator.initialize(4096)

        return if (classPathResource.exists()) {
            val keyBytes = FileCopyUtils.copyToByteArray(classPathResource.inputStream)
            val iv = keyBytes.take(16).toByteArray()
            val actualEncryptedKeyBytes = keyBytes.drop(16).toByteArray()
            val decryptedKeyBytes = decryptPrivateKey(actualEncryptedKeyBytes, passphrase, iv)
            val keySpec = PKCS8EncodedKeySpec(decryptedKeyBytes)
            val keyFactory = KeyFactory.getInstance("RSA")
            val privateKey = keyFactory.generatePrivate(keySpec)
            val publicKey = keyFactory.generatePublicFromPrivateKey(privateKey)

            KeyPair(publicKey, privateKey)
        } else {
            val keyPair = keyPairGenerator.genKeyPair()
            val privateKeyBytes = keyPair.private.encoded
            val cipher = Cipher.getInstance("AES/CBC/PKCS5PADDING")
            val secretKey = getSecretKey(passphrase)
            cipher.init(Cipher.ENCRYPT_MODE, secretKey)
            val ivParams = cipher.parameters.getParameterSpec(IvParameterSpec::class.java)
            val encryptedPrivateKeyBytes = cipher.doFinal(privateKeyBytes)
            val privateKeyPEM = "-----BEGIN PRIVATE KEY-----\n" +
                Base64.getEncoder().encodeToString(ivParams.iv + encryptedPrivateKeyBytes) +
                "\n-----END PRIVATE KEY-----"

            val dir = File(privateKeyDir)
            if (!dir.exists()) {
                dir.mkdirs()
            }
            File(privateKeyPath).bufferedWriter().use { out -> out.write(privateKeyPEM) }

            keyPair
        }
    }

    private fun getSecretKey(passphrase: String): SecretKeySpec {
        val factory = SecretKeyFactory.getInstance("PBKDF2WithHmacSHA256")
        val spec = PBEKeySpec(passphrase.toCharArray(), salt.toByteArray(), 65536, 256)
        val tmp = factory.generateSecret(spec)
        return SecretKeySpec(tmp.encoded, "AES")
    }

    private fun decryptPrivateKey(encryptedPrivateKeyBytes: ByteArray, passphrase: String, iv: ByteArray): ByteArray {
        val cipher = Cipher.getInstance("AES/CBC/PKCS5PADDING")
        val secretKey = getSecretKey(passphrase)
        cipher.init(Cipher.DECRYPT_MODE, secretKey, IvParameterSpec(iv))
        return cipher.doFinal(encryptedPrivateKeyBytes)
    }

    private fun KeyFactory.generatePublicFromPrivateKey(privateKey: PrivateKey): PublicKey {
        val rsaPrivateKey = privateKey as RSAPrivateKey
        val rsaPublicKeySpec = RSAPublicKeySpec(rsaPrivateKey.modulus, BigInteger.valueOf(65537))
        return generatePublic(rsaPublicKeySpec)
    }

    fun encryptData(data: ByteArray, publicKeyStr: String): ByteArray {
        val publicKeyBytes = Base64.getDecoder().decode(publicKeyStr)
        val keySpec = X509EncodedKeySpec(publicKeyBytes)
        val keyFactory = KeyFactory.getInstance("RSA")
        val publicKey = keyFactory.generatePublic(keySpec)
        val cipher = Cipher.getInstance("RSA/ECB/OAEPWithSHA-512AndMGF1Padding")
        cipher.init(Cipher.ENCRYPT_MODE, publicKey)
        return cipher.doFinal(data)
    }

    fun encryptPlainText(plainText: String, publicKeyStr: String): String {
        val encryptedBytes = encryptData(plainText.toByteArray(), publicKeyStr)
        return Base64.getEncoder().encodeToString(encryptedBytes)
    }

    fun decryptData(encodedString: String): ByteArray {
        val encryptedData = Base64.getDecoder().decode(encodedString)
        val spec = OAEPParameterSpec(
            "SHA-512",
            "MGF1",
            MGF1ParameterSpec.SHA512,
            PSource.PSpecified.DEFAULT,
        )
        val cipher = Cipher.getInstance("RSA/ECB/OAEPWithSHA-512AndMGF1Padding")
        cipher.init(Cipher.DECRYPT_MODE, keyPair.private, spec)
        return cipher.doFinal(encryptedData)
    }

    fun getPublicKey(): String {
        val publicKey = keyPair.public
        val publicKeyBytes = publicKey.encoded
        return Base64.getEncoder().encodeToString(publicKeyBytes)
    }
}

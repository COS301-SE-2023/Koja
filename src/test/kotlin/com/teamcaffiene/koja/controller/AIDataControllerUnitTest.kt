package com.teamcaffiene.koja.controller

import com.teamcaffeine.koja.constants.ResponseConstant
import com.teamcaffeine.koja.controller.AIDataController
import com.teamcaffeine.koja.service.AIUserDataService
import com.teamcaffeine.koja.service.CryptoService
import com.teamcaffeine.koja.service.UserCalendarService
import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.Test
import org.mockito.Mockito
import org.springframework.http.HttpStatus

class AIDataControllerUnitTest {

    private lateinit var controller: AIDataController

    private val cryptoService: CryptoService = Mockito.mock(CryptoService::class.java)
    private val aiUserDataService: AIUserDataService = Mockito.mock(AIUserDataService::class.java)
    private val userCalendarService: UserCalendarService = Mockito.mock(UserCalendarService::class.java)

    @BeforeEach
    fun setUp() {
        controller = AIDataController(aiUserDataService, userCalendarService, cryptoService)
    }

    @Test
    fun `test getNewUserEmails with null encryptedBody`() {
        val response = controller.getNewUserEmails(null)
        assertEquals(HttpStatus.BAD_REQUEST, response.statusCode)
        assertEquals(ResponseConstant.REQUIRED_PARAMETERS_NOT_SET, response.body)
    }

//    @Test
//    fun `test getNewUserEmails with valid encryptedBody`() {
//        val mockPublicKey = "mockPublicKey"
//        val mockKojaIDSecret = "mockKojaIDSecret"
//
//        val validEncryptedBody = "mockValidEncryptedBody"
//        val decryptedJson = Gson().toJson(EncryptedData(mockPublicKey, mockKojaIDSecret))
//
//        Mockito.`when`(aiUserDataService.getDecryptedAIServerRequest(validEncryptedBody)).thenReturn(AIRequestBodyDTO(decryptedJson))
//
//        val response = controller.getNewUserEmails(decryptedJson)
//
//        assertEquals(HttpStatus.OK, response.statusCode)
//        assertTrue(response.body?.contains(mockPublicKey) == true)
//    }
//
//    @Test
//    fun `test getNewUserEmails with encryptedBody causing generic Exception`() {
//        val errorEncryptedBody = "mockErrorEncryptedBody"
//
//        // Mock the behavior of aiUserDataService to throw an exception when called with errorEncryptedBody
//        Mockito.`when`(aiUserDataService.(errorEncryptedBody))
//            .thenThrow(RuntimeException("Mock generic exception"))
//
//        val response = controller.getNewUserEmails(errorEncryptedBody)
//        assertEquals(HttpStatus.BAD_REQUEST, response.statusCode)
//        assertEquals(ResponseConstant.GENERIC_INTERNAL_ERROR, response.body)
//    }
}

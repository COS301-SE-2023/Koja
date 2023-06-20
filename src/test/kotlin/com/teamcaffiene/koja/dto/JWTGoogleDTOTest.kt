package com.teamcaffiene.koja.dto

import com.teamcaffeine.koja.dto.JWTGoogleDTO
import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.api.Test

class JWTGoogleDTOTest {

    private val jwtGoogleDTO: JWTGoogleDTO = JWTGoogleDTO("12345accessToken","1234refResHtOken",1L)

    @Test
    fun `CreateJWTGoogleDTO_SUCCESS`(){
        assertEquals("12345accessToken",jwtGoogleDTO.getAccessToken())
        assertEquals("1234refResHtOken",jwtGoogleDTO.getRefreshToken())
        assertEquals(1L,jwtGoogleDTO.getExpireTime())
    }
}
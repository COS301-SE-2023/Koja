package com.teamcaffeine.koja.controller

import org.junit.jupiter.api.Assertions.*
import org.junit.jupiter.api.Test
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc
import org.springframework.boot.test.context.SpringBootTest
import org.springframework.http.MediaType
import org.springframework.test.web.servlet.MockMvc
import org.springframework.test.web.servlet.get

@SpringBootTest
@AutoConfigureMockMvc
class UserControllerTest {
    @Autowired
    lateinit var mocMvc : MockMvc

    @Test
    fun `should return all users`(){
        //GIVEN an end point /users
        //then do
        mocMvc.get("/users")
                .andDo { print() }
                .andExpect { status { isOk() }
                content { MediaType.APPLICATION_JSON }}
    }

}
package com.teamcaffiene.koja.controller

import io.github.cdimascio.dotenv.Dotenv
import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.extension.ExtendWith
import org.mockito.Mockito
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc
import org.springframework.boot.test.context.SpringBootTest
import org.springframework.boot.test.mock.mockito.MockBean
import org.springframework.test.context.ActiveProfiles
import org.springframework.test.context.junit.jupiter.SpringExtension
import org.springframework.test.web.servlet.MockMvc

@ExtendWith(SpringExtension::class)
@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
class GoogleCalendarControllerTests {

    @Autowired
    private lateinit var mockMvc: MockMvc

    @MockBean
    private lateinit var dotenv: Dotenv

    @BeforeEach
    fun setup() {
        Mockito.`when`(dotenv["KOJA_AWS_RDS_DATABASE_URL"]).thenReturn("your_test_database_url")
        Mockito.`when`(dotenv["KOJA_AWS_RDS_DATABASE_ADMIN_USERNAME"]).thenReturn("your_test_username")
        Mockito.`when`(dotenv["KOJA_AWS_RDS_DATABASE_ADMIN_PASSWORD"]).thenReturn("your_test_password")
    }

//    @Test
//    fun `oauth2Callback should return HttpStatus OK`() {
//        mockMvc.perform(get("/").param("code", "testCode").contentType(MediaType.APPLICATION_JSON))
//            .andExpect(status().isOk)
//    }
}

package com.teamcaffiene.koja.controller

import com.teamcaffeine.koja.KojaApplication
import com.teamcaffeine.koja.dto.UserEventDTO
import com.teamcaffeine.koja.service.UserCalendarService
import org.junit.jupiter.api.Test
import org.mockito.Mockito.`when`
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc
import org.springframework.boot.test.context.SpringBootTest
import org.springframework.boot.test.mock.mockito.MockBean
import org.springframework.http.MediaType
import org.springframework.test.context.ActiveProfiles
import org.springframework.test.context.TestPropertySource
import org.springframework.test.context.junit.jupiter.SpringJUnitConfig
import org.springframework.test.web.servlet.MockMvc
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get
import org.springframework.test.web.servlet.result.MockMvcResultMatchers.status

@SpringJUnitConfig
@SpringBootTest(classes = [KojaApplication::class], webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
@AutoConfigureMockMvc
@ActiveProfiles("test")
@TestPropertySource(locations = ["classpath:application-test.properties"])
class CalendarControllerIntegrationTest {

    @Autowired
    private lateinit var mockMvc: MockMvc

    @MockBean
    private lateinit var userCalendarService: UserCalendarService

    @Test
    fun testGetAllUserEvents() {
        // Prepare test data
        val token = "your_auth_token"
        val userEvents = emptyArray<UserEventDTO>()

        // Mock the service method
        `when`(userCalendarService.getAllUserEvents(token)).thenReturn(userEvents.toList())

        // Perform the GET request
        mockMvc.perform(
            get("/api/v1/user/calendar/userEvents")
                .contentType(MediaType.APPLICATION_JSON)
                .content(token)
        )
            .andExpect(status().isOk)
    }
}

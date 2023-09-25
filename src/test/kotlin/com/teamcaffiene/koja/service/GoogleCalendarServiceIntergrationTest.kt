package com.teamcaffiene.koja.service

import com.teamcaffeine.koja.entity.User
import com.teamcaffeine.koja.entity.UserAccount
import com.teamcaffeine.koja.enums.AuthProviderEnum
import com.teamcaffeine.koja.repository.UserAccountRepository
import com.teamcaffeine.koja.repository.UserRepository
import com.teamcaffeine.koja.service.GoogleCalendarAdapterService
import io.github.cdimascio.dotenv.Dotenv
import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.Test
import org.mockito.Mock
import org.mockito.MockitoAnnotations
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.autoconfigure.orm.jpa.TestEntityManager
import org.springframework.test.web.servlet.MockMvc
import org.springframework.test.web.servlet.setup.MockMvcBuilders

class GoogleCalendarServiceIntergrationTest {

    private lateinit var dotenv: Dotenv

    @Mock
    private lateinit var userRepository: UserRepository

    @Mock
    private lateinit var userAccountRepository: UserAccountRepository

    @Autowired
    private lateinit var entityManager: TestEntityManager

    @Autowired
    private lateinit var userService: GoogleCalendarAdapterService

    var mockMvc: MockMvc? = null

    @BeforeEach
    fun setup() {
        MockitoAnnotations.openMocks(this)
        importEnvironmentVariables()
        userService = GoogleCalendarAdapterService(userRepository, userAccountRepository)
        mockMvc = MockMvcBuilders.standaloneSetup(userService).build()
    }

    private fun importEnvironmentVariables() {
        dotenv = Dotenv.load()

        dotenv["KOJA_AWS_RDS_DATABASE_URL"]?.let { System.setProperty("KOJA_AWS_RDS_DATABASE_URL", it) }
        dotenv["KOJA_AWS_RDS_DATABASE_ADMIN_USERNAME"]?.let {
            System.setProperty(
                "KOJA_AWS_RDS_DATABASE_ADMIN_USERNAME",
                it,
            )
        }
        dotenv["KOJA_AWS_RDS_DATABASE_ADMIN_PASSWORD"]?.let {
            System.setProperty(
                "KOJA_AWS_RDS_DATABASE_ADMIN_PASSWORD",
                it,
            )
        }

        dotenv["GOOGLE_CLIENT_ID"]?.let { System.setProperty("GOOGLE_CLIENT_ID", it) }
        dotenv["GOOGLE_CLIENT_SECRET"]?.let { System.setProperty("GOOGLE_CLIENT_SECRET", it) }
        dotenv["API_KEY"]?.let { System.setProperty("API_KEY", it) }

        dotenv["KOJA_JWT_SECRET"]?.let { System.setProperty("KOJA_JWT_SECRET", it) }
    }

    @Test
    fun testCreateNewUser() {
        // Mock input data
        val userEmail = "test@example.com"
        val refreshToken = "testRefreshToken"

        // Call the function
        val createdUser = userService.createNewUser(userEmail, refreshToken)

        // Fetch the user and user account from the database
        val userFromDatabase = entityManager.find(User::class.java, createdUser.id)
        val userAccountFromDatabase = entityManager.find(UserAccount::class.java, createdUser.userAccounts[0].userID)

        // Verify that the user and user account were saved correctly
        userFromDatabase.getCurrentLocation()?.let { assertEquals(it.first, .0) }
        userFromDatabase.getCurrentLocation()?.let { assertEquals(it.second, .0) }
        assertEquals(userFromDatabase.getHomeLocation(), "Uninitialised")
        assertEquals(userFromDatabase.getWorkLocation(), "Uninitialised")

        assertEquals(userAccountFromDatabase.email, userEmail)
        assertEquals(userAccountFromDatabase.refreshToken, refreshToken)
        assertEquals(userAccountFromDatabase.authProvider, AuthProviderEnum.GOOGLE)
        assertEquals(userAccountFromDatabase.userID, userFromDatabase.id)
        assertEquals(userAccountFromDatabase.user, userFromDatabase)
    }

    @Test
    fun testAddUserEmail() {
        // Create a user and save it to the database
        val storedUser = User()
        entityManager.persist(storedUser)
        entityManager.flush()

        // Mock input data
        val newUserEmail = "test@example.com"
        val refreshToken = "testRefreshToken"

        // Call the function
        userService.addUserEmail(newUserEmail, refreshToken, storedUser)

        // Fetch the user account from the database
        val userAccountFromDatabase = entityManager.find(UserAccount::class.java, storedUser.userAccounts[0].userID)

        // Verify that the user account was saved correctly
        assertEquals(userAccountFromDatabase.email, newUserEmail)
        assertEquals(userAccountFromDatabase.refreshToken, refreshToken)
        assertEquals(userAccountFromDatabase.authProvider, AuthProviderEnum.GOOGLE)
        assertEquals(userAccountFromDatabase.userID, storedUser.id)
        assertEquals(userAccountFromDatabase.user, storedUser)
    }
}

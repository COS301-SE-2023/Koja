package com.teamcaffiene.koja.service

import com.teamcaffeine.koja.entity.User
import com.teamcaffeine.koja.entity.UserAccount
import com.teamcaffeine.koja.enums.AuthProviderEnum
import com.teamcaffeine.koja.repository.UserAccountRepository
import com.teamcaffeine.koja.repository.UserRepository
import com.teamcaffeine.koja.service.GoogleCalendarAdapterService
import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.Test
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest
import org.springframework.boot.test.autoconfigure.orm.jpa.TestEntityManager
import org.springframework.test.context.junit.jupiter.SpringJUnitConfig

@SpringJUnitConfig
@DataJpaTest
class GoogleCalendarServiceIntergrationTest {

    @Autowired
    private lateinit var userRepository: UserRepository

    @Autowired
    private lateinit var userAccountRepository: UserAccountRepository

    @Autowired
    private lateinit var entityManager: TestEntityManager

    private lateinit var userService: GoogleCalendarAdapterService

    @BeforeEach
    fun setUp() {
        userService = GoogleCalendarAdapterService(userRepository, userAccountRepository)
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

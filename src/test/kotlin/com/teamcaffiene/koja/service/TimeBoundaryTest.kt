import com.teamcaffeine.koja.controller.TokenManagerController
import com.teamcaffeine.koja.entity.TimeBoundary
import com.teamcaffeine.koja.entity.User
import com.teamcaffeine.koja.repository.UserAccountRepository
import com.teamcaffeine.koja.repository.UserRepository
import com.teamcaffeine.koja.service.UserCalendarService
import org.junit.jupiter.api.Assertions.*
import org.junit.jupiter.api.Test
import org.mockito.Mockito.*
import java.util.*

class TimeBoundaryServiceTest {

    private lateinit var userAccountRepository: UserAccountRepository
    private lateinit var userRepository: UserRepository
    private lateinit var userCalendarService: UserCalendarService

    @Test
    fun `addTimeBoundary should return true when the timeBoundary is valid and user exists`() {
        // Arrange
        val token = "validToken"
        val timeBoundary = TimeBoundary("Partying", "12:00", "05:00")
        val userJWTTokenData = TokenManagerController.getUserJWTTokenData(token)
        `when`(userRepository.findById(userJWTTokenData.userID)).thenReturn(Optional.of(User()))
        `when`(TokenManagerController.getUserJWTTokenData(token)).thenReturn(userJWTTokenData)

        // Act
        val result = userCalendarService.addTimeBoundary(token, timeBoundary)

        // Assert
        assertTrue(result)
        verify(userRepository).save(any(User::class.java))
    }

    @Test
    fun `addTimeBoundary should return false when the timeBoundary is null`() {
        // Arrange
        val token = "validToken"
        val timeBoundary: TimeBoundary = TimeBoundary("Play", "01:00", "03:00")
        val userJWTTokenData = TokenManagerController.getUserJWTTokenData(token)
        val user = userRepository.findById(userJWTTokenData.userID)
        // Act
        val retrievedUser = user.get()
        // Act
        val result = userCalendarService.addTimeBoundary(token, timeBoundary)

        // Assert
        assertFalse(result)
        verify(userRepository, never()).save(any(User::class.java))
    }

    @Test
    fun `addTimeBoundary should return false when the user does not exist`() {
        // Arrange
        val token = "validToken"
        val timeBoundary = TimeBoundary()

        val userJWTTokenData = TokenManagerController.getUserJWTTokenData(token)
        `when`(userRepository.findById(userJWTTokenData.userID)).thenReturn(Optional.empty())
        `when`(TokenManagerController.getUserJWTTokenData(token)).thenReturn(userJWTTokenData)

        // Act
        val result = userCalendarService.addTimeBoundary(token, timeBoundary)

        // Assert
        assertFalse(result)
        verify(userRepository, never()).save(any(User::class.java))
    }

    @Test
    fun `removeTimeBoundary should return true when the name is valid and user exists`() {
        // Arrange
        val token = "validToken"
        val name = "TimeBoundary1"

        val userJWTTokenData = TokenManagerController.getUserJWTTokenData(token)
        `when`(userRepository.findById(userJWTTokenData.userID)).thenReturn(Optional.empty())
        `when`(TokenManagerController.getUserJWTTokenData(token)).thenReturn(userJWTTokenData)

        val retrievedUser = User()
        val timeBoundary1 = TimeBoundary()
        timeBoundary1.setName("TimeBoundary1")
        val timeBoundary2 = TimeBoundary()
        timeBoundary2.setName("TimeBoundary2")
        retrievedUser.addTimeBoundary(timeBoundary1)
        retrievedUser.addTimeBoundary(timeBoundary2)
        `when`(userRepository.save(retrievedUser)).thenReturn(retrievedUser)

        // Act
        val result = userCalendarService.removeTimeBoundary(token, name)

        // Assert
        assertTrue(result)
        assertNull(timeBoundary1.user)
        assertEquals(1, retrievedUser.getUserTimeBoundaries()?.size)
        verify(userRepository).save(retrievedUser)
    }

    @Test
    fun `removeTimeBoundary should return false when the name is null`() {
        // Arrange
        val token = "validToken"
        val name: String? = null

        // Act
        val result = userCalendarService.removeTimeBoundary(token, name)

        // Assert
        assertFalse(result)
        verify(userRepository, never()).save(any(User::class.java))
    }

    @Test
    fun `removeTimeBoundary should return false when the user does not exist`() {
        // Arrange
        val token = "validToken"
        val name = "TimeBoundary1"

        val userJWTTokenData = TokenManagerController.getUserJWTTokenData(token)
        `when`(userRepository.findById(userJWTTokenData.userID)).thenReturn(Optional.empty())
        `when`(TokenManagerController.getUserJWTTokenData(token)).thenReturn(userJWTTokenData)

        // Act
        val result = userCalendarService.removeTimeBoundary(token, name)

        // Assert
        assertFalse(result)
        verify(userRepository, never()).save(any(User::class.java))
    }

    @Test
    fun `getUserTimeBoundaries should return user's time boundaries when user exists`() {
        // Arrange
        val token = "validToken"

        val userJWTTokenData = TokenManagerController.getUserJWTTokenData(token)
        `when`(userRepository.findById(userJWTTokenData.userID)).thenReturn(Optional.empty())
        `when`(TokenManagerController.getUserJWTTokenData(token)).thenReturn(userJWTTokenData)

        val retrievedUser = User()
        val timeBoundary1 = TimeBoundary("Family")
        val timeBoundary2 = TimeBoundary("Friends")
        retrievedUser.addTimeBoundary(timeBoundary1)
        retrievedUser.addTimeBoundary(timeBoundary2)
        val timeBoundaries = mutableListOf(
            TimeBoundary(name = "TimeBoundary1"),
            TimeBoundary(name = "TimeBoundary2"),
        )
        // Act
        val result = userCalendarService.getUserTimeBoundaries(token)

        // Assert
        assertEquals(timeBoundaries, result)
    }

    @Test
    fun `getUserTimeBoundaries should return an empty list when user does not exist`() {
        // Arrange
        val token = "validToken"

        val userJWTTokenData = TokenManagerController.getUserJWTTokenData(token)
        `when`(userRepository.findById(userJWTTokenData.userID)).thenReturn(Optional.empty())
        `when`(TokenManagerController.getUserJWTTokenData(token)).thenReturn(userJWTTokenData)

        // Act
        val result = userCalendarService.getUserTimeBoundaries(token)

        // Assert
        assertTrue(result.isEmpty())
    }
}

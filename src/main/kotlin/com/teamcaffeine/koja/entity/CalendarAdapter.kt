import com.teamcaffeine.koja.entity.Event
import jakarta.servlet.http.HttpServletRequest
import org.springframework.http.ResponseEntity

interface CalendarAdapter {
    fun setupConnection(request: HttpServletRequest?)
    fun authorize(): String?
    fun oauth2Callback(code: String?): ResponseEntity<String?>?
    fun getEvents(): Set<Event?>?
    fun getUserEvents(userId: String?): List<Event?>?
}
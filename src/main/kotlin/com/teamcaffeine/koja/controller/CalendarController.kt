import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.RestController


@RestController
class CalendarController(private val userCalendar: UserCalendar) {
    @GetMapping("/events")
    fun getAllUserEvents(@PathVariable userId: String?): ResponseEntity<List<Event>> {
        return ResponseEntity.ok(userCalendar.getAllEvents(userId))
    }
}

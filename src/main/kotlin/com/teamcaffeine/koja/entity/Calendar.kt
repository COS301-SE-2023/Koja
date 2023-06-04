import com.teamcaffeine.koja.entity.Event
import org.springframework.stereotype.Component

@Component
class UserCalendar() {
    public val events: ArrayList<Event> = arrayListOf();
    public val calendarAdapters: ArrayList<CalendarAdapter> = arrayListOf();
    public val issues: ArrayList<Issues> = arrayListOf();

    fun addCalendarAdapter(adapter: CalendarAdapter){
        this.calendarAdapters.add(adapter);
        for( event in adapter.getEvents()!!)
        {
            consolidateEvents(event);
        }
    }

}

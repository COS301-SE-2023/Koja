package com.teamcaffeine.koja.entity

import com.google.api.client.util.DateTime
import com.teamcaffeine.koja.enums.Months
import jakarta.persistence.*
import org.springframework.stereotype.Component

@Component
class UserCalendar() {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    val id: Int? = null;
    var month: Months? = null;

    @OneToMany(cascade = [CascadeType.ALL], fetch = FetchType.EAGER)
    @JoinColumn(name = "event_id")
    public val events: ArrayList<Event> = ArrayList();
    public val calendarAdapters: ArrayList<CalendarAdapter> = ArrayList();
    public val issues: ArrayList<Issue> = ArrayList();


    public fun createEvent(title: String, start: DateTime, end: DateTime): Event{

        return Event(title,start,end);

    }

    fun addCalendarAdapter(adapter: CalendarAdapter){
        this.calendarAdapters.add(adapter);
        for( event in adapter.getEvents()!!)
        {
            if (event != null) {
                consolidateEvents(event)
            };
        }
    }

    private fun consolidateEvents(event: Event) {
        TODO("Not yet implemented");
    }
}

package com.teamcaffeine.koja.entity

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
    public val userEvents: ArrayList<UserEvent> = ArrayList();
    public val calendarAdapters: ArrayList<CalendarAdapter> = ArrayList();
    public val issues: ArrayList<Issue> = ArrayList();


    fun addCalendarAdapter(adapter: CalendarAdapter){
        this.calendarAdapters.add(adapter);
        for( event in adapter.getEvents()!!)
        {
            if (event != null) {
                consolidateEvents(event)
            };
        }
    }

    private fun consolidateEvents(userEvent: UserEvent) {
        TODO("Not yet implemented");
    }
}

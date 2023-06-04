package com.teamcaffeine.koja.entity

import org.springframework.stereotype.Component

@Component
class UserCalendar() {
    public val events: ArrayList<Event> = arrayListOf();
    public val calendarAdapters: ArrayList<CalendarAdapter> = arrayListOf();
    public val issues: ArrayList<Issue> = arrayListOf();

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

    }

}

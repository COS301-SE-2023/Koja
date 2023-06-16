package com.teamcaffeine.koja.service

import org.springframework.stereotype.Service

@Service
class UserCalendarService() {

    private var id: Int? = null
    private val calendarAdapters: ArrayList<CalendarAdapterService> = ArrayList()

    public val userEvents: ArrayList<UserEventService> = ArrayList()

    fun addCalendarAdapter(adapter: CalendarAdapterService){
        this.calendarAdapters.add(adapter);
        for( event in adapter.getEvents()!!)
        {
            if (event != null) {
                consolidateEvents(event)
            };
        }
    }

    private fun consolidateEvents(userEvent: UserEventService?) {
        TODO("Not yet implemented");
    }
}

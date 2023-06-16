package com.teamcaffeine.koja.service

import com.teamcaffeine.koja.dto.UserEventDTO
import org.springframework.stereotype.Service

@Service
class UserCalendarService() {

    private val calendarAdapters: ArrayList<CalendarAdapterService> = ArrayList()

    public val userEvents: ArrayList<UserEventDTO> = ArrayList()

    public fun addCalendarAdapter(adapter: CalendarAdapterService){
        this.calendarAdapters.add(adapter);
        for( event in adapter.getEvents()!!)
        {
            if (event != null) {
                consolidateEvents(event)
            };
        }
    }

//    public fun getAllUserEvents(token: String): ArrayList<UserEventDTO> {
//
//    }

    private fun consolidateEvents(userEvent: UserEventDTO?) {
        TODO("Not yet implemented");
    }


}

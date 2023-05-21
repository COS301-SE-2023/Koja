package com.teamcaffeine.koja.entity

import com.google.api.client.util.DateTime

class GoogleCalendarAdapter (override val calendarID :String) : CalendarAdapter(calendarID) {
    override fun createEvent(title: String, start: DateTime, end: DateTime): Event{

        return Event(title,start,end);

    }
    override fun getCalendar(id: Int){

    }
    override fun updateEvent(id: String){}
    override fun deleteEvent(id: String){}
}
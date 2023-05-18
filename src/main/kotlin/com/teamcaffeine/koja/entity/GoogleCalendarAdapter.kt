package com.teamcaffeine.koja.entity

class GoogleCalendarAdapter (override val calendarID :String) : CalendarAdapter(calendarID) {
    override fun createEvent(e: Event){}
    override fun getCalendar(){}
    override fun updateEvent(id: String){}
    override fun deleteEvent(id: String){}
}
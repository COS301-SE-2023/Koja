package com.teamcaffeine.koja.entity

 open class CalendarAdapter (open val calendarID :String) {

     open fun createEvent(e: Event){}
     open fun getCalendar(){}
     open fun updateEvent(id: String){}
     open fun deleteEvent(id: String){}


}
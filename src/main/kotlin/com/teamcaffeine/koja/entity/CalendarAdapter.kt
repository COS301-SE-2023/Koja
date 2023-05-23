package com.teamcaffeine.koja.entity

import com.google.api.client.util.DateTime
import com.google.auth.Credentials;
import com.google.auth.oauth2.GoogleCredentials;
import java.io.FileInputStream;
import java.io.IOException;
import java.util.*
import com.google.api.services.sqladmin.SQLAdminScopes;
// ...


open class CalendarAdapter (open val calendarID :String) {

     open fun loadCredentials(): Credentials?{
    return null;
     }

     open fun createEvent(title: String, start: DateTime, end: DateTime): Event{
         return TODO("Provide the return value")
     }
     open fun getCalendar(id: Int){}
     open fun updateEvent(id: String){}
     open fun deleteEvent(id: String){}


}
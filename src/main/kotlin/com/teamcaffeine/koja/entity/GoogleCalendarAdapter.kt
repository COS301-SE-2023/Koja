package com.teamcaffeine.koja.entity

import com.google.api.client.googleapis.javanet.GoogleNetHttpTransport
import com.google.api.client.googleapis.util.Utils
import com.google.api.client.http.HttpTransport
import com.google.api.client.util.DateTime
import com.google.api.services.sqladmin.SQLAdmin
import com.google.api.services.sqladmin.SQLAdminScopes
import com.google.auth.Credentials
import com.google.auth.oauth2.GoogleCredentials
import java.io.FileInputStream
import java.io.IOException
import java.util.*

class GoogleCalendarAdapter (override val calendarID :String) : CalendarAdapter(calendarID) {

    override fun loadCredentials(): Credentials?{
        try {
            val credential: Credentials = GoogleCredentials.fromStream(FileInputStream("C://Users/JOHANES MATSEBA/Documents/3rd year/Semester 1/COS 301/koja-cos301-971f41945cca"))
                .createScoped(Collections.singleton(SQLAdminScopes.SQLSERVICE_ADMIN))
                .createDelegated("koja-service-account@koja-cos301.iam.gserviceaccount.com")
            return credential;
            // use the credentials
        } catch ( e: IOException) {
            e.printStackTrace();
        }

        return null;
    }

    private val credential = loadCredentials();
    private val JSON_FACTORY = Utils.getDefaultJsonFactory()
    private val HTTP_TRANSPORT = GoogleNetHttpTransport.newTrustedTransport()
    var sqladmin: SQLAdmin = SQLAdmin.Builder(HTTP_TRANSPORT, JSON_FACTORY, GoogleNetHttpTransport.newTrustedTransport()).build()

    override fun createEvent(title: String, start: DateTime, end: DateTime): Event{

        return Event(title,start,end);

    }
    override fun getCalendar(id: Int){

    }
    override fun updateEvent(id: String){}
    override fun deleteEvent(id: String){}
}
package com.teamcaffeine.koja.entity

class User  {
    private var id: Int? = null
    private var authToken: String = "";
    private var email: String? = null
    private var locations: List<String>? = null

    private var calendarList: List<UserCalendar> = ArrayList<UserCalendar>()

    fun getAuthToken(): String{
        return authToken;
    }
}

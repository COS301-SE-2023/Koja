package com.teamcaffeine.koja.entity

import com.google.api.client.util.DateTime
import jakarta.persistence.*


@Entity
@Table(name = "users")
class User  {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private var id: Int? = null
    private var authToken: String = "";
    //private var slotGroups: List<TimeSlot>? = null
    private var email: String? = null
    private var locations: List<String>? = null

    @OneToMany(cascade = [CascadeType.ALL], fetch = FetchType.EAGER)
    @JoinColumn(name = "calendar_id")
    private var calendarList: List<Calendar> = ArrayList<Calendar>()

    private var homeLocation: String ?= null;

fun getAuthToken(): String{
    return authToken;
}

}

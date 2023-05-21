package com.teamcaffeine.koja.entity

import com.google.api.client.util.DateTime
import com.teamcaffeine.koja.enums.Months
import jakarta.persistence.*

@Entity
@Table(name= "calendars")
class Calendar() {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    val id: Int? = null;
    var month: Months? = null;

    @OneToMany(cascade = [CascadeType.ALL], fetch = FetchType.EAGER)
    @JoinColumn(name = "event_id")
    private var eventList: List<Event> = ArrayList<Event>()

    public fun createEvent(title: String, start: DateTime, end: DateTime): Event{

        return Event(title,start,end);

    }
}
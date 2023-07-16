package com.teamcaffeine.koja.entity

import jakarta.persistence.CascadeType
import jakarta.persistence.Entity
import jakarta.persistence.FetchType
import jakarta.persistence.GeneratedValue
import jakarta.persistence.GenerationType
import jakarta.persistence.Id
import jakarta.persistence.OneToMany
import jakarta.persistence.Table

@Entity
@Table(name = "user")
class User {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    public var id: Int? = null

    @OneToMany(mappedBy = "user", cascade = [CascadeType.ALL], orphanRemoval = true, fetch = FetchType.EAGER)
    public val userAccounts: MutableList<UserAccount> = mutableListOf()

    private var currentLocation : Pair<Double,Double> = Pair(0.0,0.0)
    private var homeLocation: String ? = null
    private var workLocation: String ? = null

    fun setCurrentLocation(latitude: Double, longitude: Double) {
        this.currentLocation = Pair(latitude,longitude)
    }
    fun getCurrentLocation(): Pair<Double,Double>? {
        return currentLocation
    }

    fun setHomeLocation(homeLocation: String) {
        this.homeLocation = homeLocation
    }

    fun setWorkLocation(workLocation: String) {
        this.workLocation = workLocation
    }
    fun getHomeLocation(): String? {
        return homeLocation
    }

    fun getWorkLocation(): String? {
        return workLocation
    }
}

package com.teamcaffeine.koja.entity

<<<<<<< HEAD
import com.google.api.client.util.DateTime
import jakarta.persistence.*

=======
import jakarta.persistence.CascadeType
import jakarta.persistence.Entity
import jakarta.persistence.FetchType
import jakarta.persistence.GeneratedValue
import jakarta.persistence.GenerationType
import jakarta.persistence.Id
import jakarta.persistence.OneToMany
import jakarta.persistence.Table
>>>>>>> d075a8edfcf0503bd2778e6b3d7b1d8fba6186f9

@Entity
@Table(name = "user")
class User {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    public var id: Int? = null

    @OneToMany(mappedBy = "user", cascade = [CascadeType.ALL], orphanRemoval = true, fetch = FetchType.EAGER)
    public val userAccounts: MutableList<UserAccount> = mutableListOf()

    private var homeLocation: String ? = null
    private var workLocation: String ? = null

<<<<<<< HEAD

fun getAuthToken(): String{
    return authToken;
}

=======
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
>>>>>>> d075a8edfcf0503bd2778e6b3d7b1d8fba6186f9
}

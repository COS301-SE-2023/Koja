package com.teamcaffeine.koja.service

import com.google.api.client.googleapis.auth.oauth2.GoogleCredential
import com.google.api.client.http.*
import com.google.api.client.http.javanet.NetHttpTransport
import com.google.api.client.json.JsonFactory
import com.google.api.client.json.jackson2.JacksonFactory
import org.springframework.stereotype.Service
import java.io.IOException

@Service
class UserAccountManagerService {

    val HTTP_TRANSPORT: HttpTransport = NetHttpTransport()
    val JSON_FACTORY: JsonFactory = JacksonFactory()
    val APPLICATION_NAME = "Koja"
    val ACCOUNTS_DELETE_ENDPOINT = "https://accounts.google.com/o/oauth2/revoke"

    fun deleteGoogleAccount(accessToken: String) {
        val credential = GoogleCredential().setAccessToken(accessToken)
        val requestFactory = HTTP_TRANSPORT.createRequestFactory(object : HttpRequestInitializer {
            @Throws(IOException::class)
            override fun initialize(request: HttpRequest) {
                credential.initialize(request)
                request.isLoggingEnabled = true
            }
        })

        val url = "$ACCOUNTS_DELETE_ENDPOINT?token=$accessToken"
        val request = requestFactory.buildDeleteRequest(GenericUrl(url))
        val response: HttpResponse = request.execute()
        // Handle the response as per your requirements
    }

}

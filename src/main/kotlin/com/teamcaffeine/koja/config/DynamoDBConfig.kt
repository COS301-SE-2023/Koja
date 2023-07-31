package com.teamcaffeine.koja.config

import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration
import software.amazon.awssdk.auth.credentials.AwsBasicCredentials
import software.amazon.awssdk.regions.Region
import software.amazon.awssdk.services.dynamodb.DynamoDbClient

@Configuration
class DynamoDBConfig {

//    @Bean
//    fun dynamoDbClient(): DynamoDbClient {
//        val awsCreds = AwsBasicCredentials.create(
//            System.getProperty("KOJA_AWS_DYNAMODB_ACCESS_KEY_ID"),
//            System.getProperty("KOJA_AWS_DYNAMODB_ACCESS_KEY_SECRET"),
//        )
//
//        return DynamoDbClient.builder()
//            .region(Region.EU_NORTH_1)
//            .credentialsProvider { awsCreds }
//            .build()
//    }
}

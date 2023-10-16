package com.teamcaffeine.koja.constants

object EnvironmentVariableConstant {
    const val KOJA_AWS_RDS_DATABASE_URL = "koja_aws_rds_database_url"
    const val KOJA_AWS_RDS_DATABASE_ADMIN_USERNAME = "koja_aws_rds_database_admin_username"
    const val KOJA_AWS_RDS_DATABASE_ADMIN_PASSWORD = "koja_aws_rds_database_admin_password"
    const val KOJA_AWS_DYNAMODB_ACCESS_KEY_ID = "koja_aws_dynamodb_access_key_id"
    const val KOJA_AWS_DYNAMODB_ACCESS_KEY_SECRET = "koja_aws_dynamodb_access_key_secret"
    const val GOOGLE_CLIENT_ID = "koja_google_client_id"
    const val GOOGLE_CLIENT_SECRET = "koja_google_client_secret"
    const val GOOGLE_MAPS_API_KEY = "koja_google_maps_api_key"
    const val KOJA_JWT_SECRET = "koja_jwt_secret"
    const val OPENAI_API_KEY = "koja_openai_api_key"
    const val KOJA_ID_SECRET = "koja_id_secret"
    const val COVERALLS_REPO_TOKEN = "koja_coveralls_repo_token"
    const val KOJA_PRIVATE_KEY_PASS = "koja_private_key_password"
    const val KOJA_PRIVATE_KEY_SALT = "koja_private_key_salt"
    const val AI_PRIVATE_KEY_PASS = "koja_ai_private_key_password"
    const val AI_PRIVATE_KEY_SALT = "koja_ai_private_key_salt"
    const val SERVER_ADDRESS = "koja_server_address"
    const val SERVER_PORT = "koja_server_port"

    val asMap: Map<String, String> = mapOf(
        "KOJA_AWS_RDS_DATABASE_URL" to KOJA_AWS_RDS_DATABASE_URL,
        "KOJA_AWS_RDS_DATABASE_ADMIN_USERNAME" to KOJA_AWS_RDS_DATABASE_ADMIN_USERNAME,
        "KOJA_AWS_RDS_DATABASE_ADMIN_PASSWORD" to KOJA_AWS_RDS_DATABASE_ADMIN_PASSWORD,
        "KOJA_AWS_DYNAMODB_ACCESS_KEY_ID" to KOJA_AWS_DYNAMODB_ACCESS_KEY_ID,
        "KOJA_AWS_DYNAMODB_ACCESS_KEY_SECRET" to KOJA_AWS_DYNAMODB_ACCESS_KEY_SECRET,
        "GOOGLE_CLIENT_ID" to GOOGLE_CLIENT_ID,
        "GOOGLE_CLIENT_SECRET" to GOOGLE_CLIENT_SECRET,
        "GOOGLE_MAPS_API_KEY" to GOOGLE_MAPS_API_KEY,
        "KOJA_JWT_SECRET" to KOJA_JWT_SECRET,
        "OPENAI_API_KEY" to OPENAI_API_KEY,
        "KOJA_ID_SECRET" to KOJA_ID_SECRET,
        "COVERALLS_REPO_TOKEN" to COVERALLS_REPO_TOKEN,
        "KOJA_PRIVATE_KEY_PASS" to KOJA_PRIVATE_KEY_PASS,
        "KOJA_PRIVATE_KEY_SALT" to KOJA_PRIVATE_KEY_SALT,
        "AI_PRIVATE_KEY_PASS" to AI_PRIVATE_KEY_PASS,
        "AI_PRIVATE_KEY_SALT" to AI_PRIVATE_KEY_SALT,
        "SERVER_ADDRESS" to SERVER_ADDRESS,
        "SERVER_PORT" to SERVER_PORT,
    )
}

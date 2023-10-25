package com.teamcaffeine.koja.constants

object ResponseConstant {

    // Response messages where the system could not do what was requested
    const val REQUIRED_PARAMETERS_NOT_SET = "The required parameters were not set."
    const val EVENT_CREATION_FAILED_COULD_NOT_FIT = "Event not added, could not find a time slot where the event can fit."
    const val EVENT_CREATION_FAILED_INTERNAL_ERROR = "Internal Server Error - Event could no be created."
    const val EVENT_UPDATE_FAILED_INTERNAL_ERROR = "Internal Server Error - Event could not be updated."
    const val EVENT_DELETION_FAILED_INTERNAL_ERROR = "Internal Server Error - Event could not be deleted."
    const val SET_USER_CALENDAR_FAILED_INTERNAL_ERROR = "Internal Server Error - User calendar could not be set."
    const val INVALID_PARAMETERS = "Provided parameters invalid."
    const val GENERIC_INTERNAL_ERROR = "Internal Server Error - Something went wrong."
    const val UNAUTHORIZED = "Unauthorized request."
    const val INVALID_TOKEN = "Invalid token."
    const val NO_FUTURE_LOCATIONS_FOUND = "No future locations found."
    const val SET_TIME_BOUNDARY_FAILED_INTERNAL_ERROR = "Internal Server Error - Time boundary could not be set."

    // Response messages where system succeeded
    const val EVENT_CREATED = "Event successfully created."
    const val EVENT_UPDATED = "Event successfully updated."
    const val EVENT_DELETED = "Event successfully deleted."
    const val EMAIL_REMOVED = "Email successfully removed."
    const val ACCOUNT_DELETED = "Account successfully deleted."
    const val HOME_LOCATION_SET = "Home location successfully set."
    const val WORK_LOCATION_SET = "Work location successfully set."
    const val USER_CALENDAR_SET = "User calendar successfully set."
    const val SUCCESSFULLY_ADDED_TIME_BOUNDARY = "Successfully added time boundary."
    const val SUCCESSFULLY_REMOVED_TIME_BOUNDARY = "Successfully removed time boundary."
}

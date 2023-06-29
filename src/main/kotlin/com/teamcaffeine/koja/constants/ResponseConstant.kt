package com.teamcaffeine.koja.constants

object ResponseConstant {

    // Response messages where the system could not do what was requested
    const val REQUIRED_PARAMETERS_NOT_SET = "The required parameters were not set."
    const val EVENT_CREATION_FAILED_COULD_NOT_FIT = "Event not added, could not find a time slot where the event can fit."
    const val EVENT_CREATION_FAILED_INTERNAL_ERROR = "Internal Server Error - Event could no be created."
    const val EVENT_UPDATE_FAILED_INTERNAL_ERROR = "Internal Server Error - Event could not be updated."
    const val EVENT_DELETION_FAILED_INTERNAL_ERROR = "Internal Server Error - Event could not be deleted."
    const val INVALID_PARAMETERS = "Provided parameters invalid."

    // Response messages where system succeeded
    const val EVENT_CREATED = "Event successfully created."
    const val EVENT_UPDATED = "Event successfully updated."
    const val EVENT_DELETED = "Event successfully deleted."
}

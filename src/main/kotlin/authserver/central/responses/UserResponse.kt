package authserver.central.responses

import java.util.*

data class UserResponse(
    val id: Long,
    val name: String,
    val email: String,
    val creation_date: Date,
    val description: String
)
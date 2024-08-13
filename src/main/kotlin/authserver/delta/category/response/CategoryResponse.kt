package authserver.delta.category.response

import java.util.*

data class CategoryResponse(
    val id: Long,
    val name: String,
    val creationDate: Date,
)

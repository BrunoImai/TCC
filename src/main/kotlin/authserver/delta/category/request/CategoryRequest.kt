package authserver.delta.category.request

import jakarta.validation.constraints.NotBlank

class CategoryRequest (
    @field:NotBlank(message = "Name is mandatory")
    val name: String,
)
package authserver.delta.assistance.request

import authserver.delta.category.Category
import jakarta.validation.constraints.NotBlank

data class AssistanceRequest(
    @field:NotBlank(message = "Description is mandatory")
    val description: String,

    @field:NotBlank(message = "Name is mandatory")
    val name: String,

    @field:NotBlank(message = "Address is mandatory")
    val address: String,

    val complement: String? = null,

    @field:NotBlank(message = "CPF is mandatory")
    val cpf: String,

    @field:NotBlank(message = "Period is mandatory")
    val period: String,

    val categoriesId: List<Long>,

    val workersIds: List<Long>
)

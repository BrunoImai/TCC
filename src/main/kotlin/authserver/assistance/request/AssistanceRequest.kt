package authserver.assistance.request

import jakarta.validation.constraints.NotBlank

data class AssistanceRequest(
    @field:NotBlank(message = "Description is mandatory")
    val description: String,

    @field:NotBlank(message = "Email is mandatory")
    val name: String,

    @field:NotBlank(message = "Address is mandatory")
    val address: String,

    @field:NotBlank(message = "CPF is mandatory")
    val cpf: String,

    @field:NotBlank(message = "Period is mandatory")
    val period: String,

    val workersIds: List<Long>
)

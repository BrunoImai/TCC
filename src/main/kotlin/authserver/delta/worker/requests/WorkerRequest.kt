package authserver.delta.worker.requests

import jakarta.validation.constraints.NotBlank
import jakarta.validation.constraints.Size

data class WorkerRequest (
    @field:NotBlank(message = "Name is mandatory")
    val name: String,

    @field:NotBlank(message = "Email is mandatory")
    val email: String,

    @field:Size(min = 8, max = 500)
    val password: String,

    @field:NotBlank(message = "CPF is mandatory")
    val cpf: String,

    @field:NotBlank(message = "Cellphone is mandatory")
    val cellphone: String,
)
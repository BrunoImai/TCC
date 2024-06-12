package authserver.client.requests

import jakarta.validation.constraints.NotBlank
import jakarta.validation.constraints.Size

data class ClientRequest(
    @field:NotBlank(message = "Name is mandatory")
    val name: String,

    @field:NotBlank(message = "CPF is mandatory")
    val cpf: String,

    @field:NotBlank(message = "Address is mandatory")
    val address: String,

    val complement: String? = null,

    @field:NotBlank(message = "Cellphone is mandatory")
    val cellphone: String,

    @field:NotBlank(message = "Email is mandatory")
    val email: String,

)

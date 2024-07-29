package authserver.delta.client.response

import jakarta.validation.constraints.NotBlank
import java.util.*

data class ClientResponse(
    val id: Long,

    @field:NotBlank(message = "Name is mandatory")
    val name: String,

    @field:NotBlank(message = "CPF is mandatory")
    val cpf: String,

    @field:NotBlank(message = "Address is mandatory")
    val address: String,

    val complement: String?,

    @field:NotBlank(message = "Cellphone is mandatory")
    val cellphone: String,

    @field:NotBlank(message = "Email is mandatory")
    val email: String,

    val assistances: Set<Long?> = HashSet(),

    val entryDate: Date
)

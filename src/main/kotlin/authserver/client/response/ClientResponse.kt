package authserver.client.response

import authserver.assistance.Assistance
import jakarta.validation.constraints.NotBlank
import jakarta.validation.constraints.Size
import java.util.*

data class ClientResponse(
    val id: Long,

    @field:NotBlank(message = "Name is mandatory")
    val name: String,

    @field:NotBlank(message = "CPF is mandatory")
    @field:Size(min = 11, max = 11, message = "CPF must be 11 characters long")
    val cpf: String,

    @field:NotBlank(message = "Address is mandatory")
    val address: String,

    @field:NotBlank(message = "Cellphone is mandatory")
    val cellphone: String,

    @field:NotBlank(message = "Email is mandatory")
    val email: String,

    val assistances: MutableSet<Assistance> = HashSet(),

    val entryDate: Date
)

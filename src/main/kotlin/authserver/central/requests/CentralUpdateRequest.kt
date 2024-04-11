package authserver.central.requests

import jakarta.validation.constraints.Email
import jakarta.validation.constraints.NotBlank
import jakarta.validation.constraints.Size

data class CentralUpdateRequest(
    @field:NotBlank
    val name: String?,

    @field:Email
    val email: String?,

    @field:NotBlank
    val cnpj: String?,

    @field:NotBlank
    val cellphone: String?,

    @field:Size(min = 8, max = 50)
    val oldPassword: String?,

    @field:Size(min = 8, max = 50)
    val newPassword: String?,
)

package authserver.central.responses

import java.util.*

data class CentralResponse(
    val id: Long,
    val name: String,
    val email: String,
    val creationDate: Date,
    val cnpj: String,
    val cellphone: String,
)
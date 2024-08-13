package authserver.j_audi.client_business.response

import java.util.*

data class ClientBusinessResponse(
    val id: Long,
    val name: String,
    val cnpj: String,
    val cellphone: String,
    val creationDate: Date,
    val responsibleCentral: Long
)

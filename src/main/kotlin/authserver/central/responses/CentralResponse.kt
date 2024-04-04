package authserver.central.responses

import authserver.client.response.ClientResponse
import org.apache.logging.log4j.util.StringMap
import java.util.*

data class CentralResponse(
    val id: Long,
    val name: String,
    val email: String,
    val creationDate: Date,
    val cnpj: String,
    val cellphone: String,
   // val mutableList: List<ClientResponse>
)
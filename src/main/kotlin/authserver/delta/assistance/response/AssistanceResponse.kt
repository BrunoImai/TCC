package authserver.delta.assistance.response

import java.util.*

data class AssistanceResponse(
    val id: Long,
    val description: String,
    val startDate: Date,
    val name: String,
    val address: String,
    val complement: String?,
    val cpf: String,
    val period: String,
    val workersIds: Set<Long?>
)

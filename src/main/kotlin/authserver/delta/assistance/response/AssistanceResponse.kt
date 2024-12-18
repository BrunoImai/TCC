package authserver.delta.assistance.response

import authserver.delta.assistance.AssistanceStatus
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
    val workersIds: Set<Long?>,
    val categoryIds: Set<Long?>,
    val assistanceStatus: AssistanceStatus,
)

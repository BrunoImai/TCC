package authserver.assistance.response

data class AssistanceResponse(
    val id: Long,
    val description: String,
    val name: String,
    val address: String,
    val cpf: String,
    val period: String,
    val workersIds: Set<Long?>
)

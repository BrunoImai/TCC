package authserver.assistance.response

data class AssistanceResponse(
    val description: String,
    val name: String,
    val address: String,
    val cpf: String,
    val hoursToFinish: Float,
    val workersIds: List<Long>
)

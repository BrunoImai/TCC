package authserver.assistance.request

data class AssistanceRequest(
    val description: String,
    val name: String,
    val address: String,
    val cpf: String,
    val hoursToFinish: Float,
    val workersIds: List<Long>
)

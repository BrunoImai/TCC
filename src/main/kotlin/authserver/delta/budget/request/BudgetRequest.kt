package authserver.delta.budget.request

data class BudgetRequest(
    val name: String,
    val description: String,
    val clientId: Long,
    val responsibleWorkersIds: List<Long>,
    val assistanceId: Long,
    val totalPrice: Float,
)

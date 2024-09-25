package authserver.delta.budget.request

import authserver.delta.budget.BudgetStatus

data class BudgetRequest(
    val name: String,
    val description: String,
    val clientId: Long,
    val responsibleWorkersIds: List<Long>,
    val assistanceId: Long,
    val totalPrice: Float,
    val status: BudgetStatus
)

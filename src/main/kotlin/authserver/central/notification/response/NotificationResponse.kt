package authserver.central.notification.response

import authserver.delta.budget.response.BudgetResponse

data class NotificationResponse (
    val id: Long,
    val title: String,
    val message: String,
    val creationDate: String,
    val readed: Boolean,
    val workerId: Long,
    val budget: BudgetResponse?
)
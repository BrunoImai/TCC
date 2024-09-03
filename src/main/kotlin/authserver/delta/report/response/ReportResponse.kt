package authserver.delta.report.response

import authserver.delta.report.PaymentType

data class ReportResponse (
    val id: Long,
    val name: String,
    val description: String,
    val creationDate: String,
    val status: String,
    val assistanceId: Long?,
    val responsibleWorkersIds: List<Long>,
    val totalPrice: Float,
    val paymentType: PaymentType,
    val machinePartExchange: Boolean,
    val delayed: Boolean,

    )

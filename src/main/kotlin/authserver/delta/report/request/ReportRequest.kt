package authserver.delta.report.request

import authserver.delta.report.PaymentType

data class ReportRequest(
    val name: String,
    val description: String,
    val responsibleWorkersIds: List<Long>,
    val assistanceId: Long,
    val totalPrice: Float,
    val paymentType: PaymentType,
    val machinePartExchange: Boolean,
    val delayed: Boolean,

    )

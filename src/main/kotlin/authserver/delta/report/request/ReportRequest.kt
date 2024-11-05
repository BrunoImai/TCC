package authserver.delta.report.request
import authserver.utils.PaymentType

data class ReportRequest(
    val name: String,
    val description: String,
    val responsibleWorkersIds: List<Long>,
    val assistanceId: Long,
    val paymentType: PaymentType,
    val machinePartExchange: Boolean,
    val delayed: Boolean,

    )

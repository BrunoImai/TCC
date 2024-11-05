package authserver.delta.report.response
import authserver.utils.PaymentType

data class ReportResponse (
    val id: Long,
    val name: String,
    val description: String,
    val creationDate: String,
    val status: String,
    val assistanceId: Long?,
    val responsibleWorkersIds: List<Long>,
    val paymentType: PaymentType,
    val machinePartExchange: Boolean,
    val delayed: Boolean,

    )

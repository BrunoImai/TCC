package authserver.delta.report.request

data class ReportRequest(
    val name: String,
    val description: String,
    val clientId: Long,
    val responsibleWorkersIds: List<Long>,
    val assistanceId: Long,
    val totalPrice: Float,
)

package authserver.delta.report.response

data class ReportResponse (
    val id: Long,
    val name: String,
    val description: String,
    val creationDate: String,
    val status: String,
    val assistanceId: Long?,
    val clientId: Long,
    val responsibleWorkersIds: List<Long>
)

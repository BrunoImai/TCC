package authserver.delta.worker.response

import java.util.*

data class WorkerResponse (
    val id: Long,
    val name: String,
    val email: String,
    val cpf: String,
    val cellphone: String,
    val entryDate: Date
)
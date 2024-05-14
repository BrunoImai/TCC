package authserver.worker.requests

data class WorkerRequest (
    val name: String,
    val email: String,
    val password: String,
    val cpf: String,
    val cellphone: String
)
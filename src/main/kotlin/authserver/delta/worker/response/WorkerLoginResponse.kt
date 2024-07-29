package authserver.delta.worker.response

data class WorkerLoginResponse(
    val token: String,
    val worker: WorkerResponse
)

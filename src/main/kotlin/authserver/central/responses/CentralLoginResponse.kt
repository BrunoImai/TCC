package authserver.central.responses


data class CentralLoginResponse(
    val token: String,
    val central: CentralResponse
)

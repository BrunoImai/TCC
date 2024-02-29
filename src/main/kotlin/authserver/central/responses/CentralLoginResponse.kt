package br.pucpr.authserver.users.responses

import authserver.central.responses.CentralResponse

data class CentralLoginResponse(
    val token: String,
    val central: CentralResponse
)

package br.pucpr.authserver.users.responses

import authserver.central.responses.UserResponse

data class LoginResponse(
    val token: String,
    val user: UserResponse
)

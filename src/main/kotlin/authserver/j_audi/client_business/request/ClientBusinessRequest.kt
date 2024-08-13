package authserver.j_audi.client_business.request

data class ClientBusinessRequest(
    val name: String,
    val cnpj: String,
    val cellphone: String
)

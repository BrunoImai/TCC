package authserver.j_audi.products.requests

data class ProductRequest(
    val name: String,
    val price: Float,
    val supplierCnpj: String,
)

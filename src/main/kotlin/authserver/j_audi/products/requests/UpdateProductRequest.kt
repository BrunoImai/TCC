package authserver.j_audi.products.requests

class UpdateProductRequest (
    val name: String,
    val price: Float,
    val supplierCnpj: String?
)
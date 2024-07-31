package authserver.j_audi.supplier_business.response

import authserver.j_audi.products.response.ProductResponse
import java.util.Date

data class SupplierBusinessResponse(
    val id: Long,
    val name: String,
    val creationDate: Date,
    val cnpj: String,
    val responsibleCentralId: Long,
    val products: Set<ProductResponse?>
)

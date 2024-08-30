package authserver.j_audi.sale.requests

import authserver.j_audi.products.requests.ProductQttRequest
import java.util.*

data class SaleRequest (
    val productsQtt: List<ProductQttRequest>,
    val clientId: Long,
    val supplierId: Long,
    val purchaseOrder: String,
    val carrier: String,
    val fare: String,
    val billingDate: Date,
)

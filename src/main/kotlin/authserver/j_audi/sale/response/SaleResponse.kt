package authserver.j_audi.sale.response

import authserver.j_audi.products.response.ProductQttResponse

data class SaleResponse (
    val id: Long,
    val clientId: Long,
    val supplierId: Long,
    val purchaseOrder: String,
    val carrier: String,
    val fare: String,
    val productsQtt: List<ProductQttResponse>
)
package authserver.j_audi.products.response

import java.util.Date

data class ProductResponse(
    val id: Long,
    val name: String,
    val price: Float,
    val supplierId: Long,
    val lastTimePurchase: Date?,
    val oldPrices: Set<Float>,
    val creationDate: Date,
)

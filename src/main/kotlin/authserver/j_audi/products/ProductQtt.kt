package authserver.j_audi.products

import authserver.j_audi.products.response.ProductQttResponse
import authserver.j_audi.sale.Sale
import jakarta.persistence.*

@Entity
class ProductQtt(
    @Id
    @GeneratedValue
    var id: Long? = null,

    @Column(nullable = false)
    var qtt: Int,

    @ManyToOne
    @JoinColumn(name = "idProduct")
    var product: Product,

    @ManyToOne
    @JoinColumn(name = "idSale")
    var sale: Sale,

    @Column(nullable = false)
    var priceOnSale: Float = 0.0f
) {
    fun toResponse() = ProductQttResponse(product.id!!, qtt)
}
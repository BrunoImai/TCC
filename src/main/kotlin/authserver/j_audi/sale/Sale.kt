package authserver.j_audi.sale

import authserver.j_audi.client_business.ClientBusiness
import authserver.j_audi.products.ProductQtt
import authserver.j_audi.sale.response.SaleResponse
import authserver.j_audi.supplier_business.SupplierBusiness
import jakarta.persistence.*
import java.util.*

@Entity
class Sale (
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    var id: Long? = null,

    @OneToMany(mappedBy = "sale", cascade = [CascadeType.ALL], orphanRemoval = true)
    var products: MutableSet<ProductQtt> = HashSet(),

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "clientId")
    var client: ClientBusiness? = null,

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "supplierId")
    var supplier: SupplierBusiness? = null,

    @Column(nullable = false)
    var purchaseOrder: String = "",

    @Column(nullable = false)
    var saleDate: Date,

    @Column(nullable = false)
    var carrier: String,

    @Column(nullable = false)
    var fare: String,

    @Column
    var totalPrice: Float = 0.0f,

    @Column
    var billingDate : String
) {
    fun toResponse() = SaleResponse(id!!, client!!.id!!, supplier!!.id!!, purchaseOrder, carrier, fare, products.map { it.toResponse() }, saleDate, billingDate, totalPrice)
}
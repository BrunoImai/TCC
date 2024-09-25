package authserver.j_audi.products

import authserver.j_audi.old_prices.OldPrices
import authserver.j_audi.products.response.ProductResponse
import authserver.j_audi.supplier_business.SupplierBusiness
import jakarta.persistence.Entity
import jakarta.persistence.*
import jakarta.persistence.Table
import java.util.*

@Entity
class Product (
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    var id: Long? = null,

    @Column(nullable = false)
    var creation_date: Date,

    @Column(nullable = false)
    var name: String = "",

    @Column
    var price: Float = 0.0f,

    @Column
    var lastTimePurchased: Date? = null,



    @OneToMany(mappedBy = "product", cascade = [CascadeType.ALL], orphanRemoval = true)
    var producthistory: MutableSet<OldPrices> = HashSet(),

    @OneToMany(mappedBy = "product", cascade = [CascadeType.ALL], orphanRemoval = true)
    var productQtt: MutableSet<ProductQtt> = HashSet(),

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "Supplier_Business_id")
    var supplier: SupplierBusiness,

    ){
fun toResponse() = ProductResponse(id!!, name, price, supplier.id!!, lastTimePurchased, producthistory.map { it.old_price }.toSet(), creation_date)
}
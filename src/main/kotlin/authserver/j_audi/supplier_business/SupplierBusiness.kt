package authserver.j_audi.supplier_business

import authserver.central.Central
import authserver.j_audi.products.Product
import authserver.j_audi.supplier_business.response.SupplierBusinessResponse
import jakarta.persistence.*
import java.util.*

@Entity
@Table(name = "Supplier_Business")
class SupplierBusiness (
    @Id
    @GeneratedValue
    var id: Long? = null,

    @Column(nullable = false)
    var creation_date: Date,

    @Column(nullable = false)
    var name: String = "",

    @Column
    var cnpj: String = "",

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "Central_id")
    var responsibleCentral: Central,

    @OneToMany(cascade = [CascadeType.ALL], orphanRemoval = true)
    var products: MutableList<Product> = mutableListOf(),

    ) {
    fun toResponse() = SupplierBusinessResponse(id!!, name, creation_date, cnpj, responsibleCentral.id!!, products.map { it.toResponse() }.toSet())
}
package authserver.j_audi.old_prices

import authserver.j_audi.products.Product
import jakarta.persistence.*
import java.util.*


@Entity
@Table(name = "Old_prices")
class OldPrices (
    @Id
    @GeneratedValue
    var id: Long? = null,

    @Column(nullable = false)
    var update_date: Date,

    @Column(nullable = false)
    var old_price: Float = 0.0f,

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "Products")
    var product: Product,
)
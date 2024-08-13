package authserver.delta.category

import authserver.central.Central
import authserver.delta.assistance.Assistance
import authserver.delta.category.response.CategoryResponse
import jakarta.persistence.Entity
import jakarta.persistence.GeneratedValue
import jakarta.persistence.*
import jakarta.persistence.Table
import java.util.*

@Entity
@Table(name = "Category")
class Category (
    @Id
    @GeneratedValue
    var id: Long? = null,

    @Column(nullable = false)
    var name: String,

    @Column(nullable = false)
    val creationDate: Date = Date(),

    @ManyToMany(mappedBy = "categories")
    val assistances: MutableSet<Assistance> = mutableSetOf(),

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "Central_id")
    var central: Central? = null,
) {

    fun toResponse() = CategoryResponse(id!!, name, creationDate)
}

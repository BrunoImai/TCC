package authserver.central.role

import authserver.central.Central
import jakarta.persistence.*

@Entity
class Role(
    @Id @GeneratedValue
    val id: Long? = null,

    @Column(unique = true, nullable = false)
    val name: String = "",

    @ManyToMany(mappedBy = "roles")
    val centrals: MutableSet<Central> = mutableSetOf()
)

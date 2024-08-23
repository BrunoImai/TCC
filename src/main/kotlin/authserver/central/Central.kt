package authserver.central

import authserver.delta.assistance.Assistance
import authserver.central.responses.CentralResponse
import authserver.central.role.Role
import authserver.delta.category.Category
import authserver.delta.client.Client
import jakarta.persistence.*

import authserver.delta.worker.Worker
import authserver.j_audi.client_business.ClientBusiness
import authserver.j_audi.supplier_business.SupplierBusiness
import java.util.*

@Entity
class  Central(
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    var id: Long? = null,

    @Column(nullable = false)
    var creationDate: Date,

    @Column(length = 5000)
    var password: String,

    @Column(nullable = false)
    var name: String = "",

    @Column(unique = true, nullable = false)
    var email: String = "",

    @Column(unique = true, nullable = false)
    var cnpj: String = "",

    @Column
    var cellphone: String = "",

    @Column
    var newPasswordCode: String? = null,

    @ManyToMany
    @JoinTable(
        name = "CentralRole",
        joinColumns = [JoinColumn(name = "idCentral")],
        inverseJoinColumns = [JoinColumn(name = "idRole")]
    )
    val roles: MutableSet<Role> = mutableSetOf(),

    @OneToMany(cascade = [CascadeType.ALL], orphanRemoval = true)
    var assistanceQueue: MutableList<Assistance> = mutableListOf(),

    @OneToMany(mappedBy = "central", cascade = [CascadeType.ALL], orphanRemoval = true)
    var workers: MutableSet<Worker> = mutableSetOf(),

    @OneToMany(mappedBy = "responsibleCentral", cascade = [CascadeType.ALL], orphanRemoval = true)
    var assistances: MutableSet<Assistance> = mutableSetOf(),

    @OneToMany(mappedBy = "central", cascade = [CascadeType.ALL], orphanRemoval = true)
    var client: MutableSet<Client> = mutableSetOf(),

    @OneToMany(mappedBy = "central", cascade = [CascadeType.ALL], orphanRemoval = true)
    var category: MutableSet<Category> = mutableSetOf(),

    @OneToMany(mappedBy = "responsibleCentral", cascade = [CascadeType.ALL], orphanRemoval = true)
    var clientBussines: MutableSet<ClientBusiness> = mutableSetOf(),

    @OneToMany(mappedBy = "responsibleCentral", cascade = [CascadeType.ALL], orphanRemoval = true)
    var supplierBusiness: MutableSet<SupplierBusiness> = mutableSetOf(),

) {
    fun toResponse() = CentralResponse(id!!, name, email, creationDate, cnpj, cellphone )
}
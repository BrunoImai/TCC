package authserver.central

import authserver.delta.assistance.Assistance
import authserver.central.responses.CentralResponse
import authserver.central.role.Role
import authserver.delta.category.Category
import authserver.delta.client.Client
import jakarta.persistence.*

import authserver.delta.worker.Worker
import java.util.*

@Entity
@Table(name = "Central")
class Central(
    @Id @GeneratedValue
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
    var category: MutableSet<Category> = mutableSetOf()
) {
    fun toResponse() = CentralResponse(id!!, name, email, creationDate, cnpj, cellphone )
}
package authserver.central

import authserver.assistance.Assistance
import authserver.central.responses.CentralResponse
import authserver.central.role.Role
import jakarta.persistence.*

import authserver.worker.Worker
import org.hibernate.validator.constraints.br.CNPJ
import java.util.*

@Entity
@Table(name = "Central")
class Central(
    @Id @GeneratedValue
    var id: Long? = null,

    @Column(nullable = false)
    var creationDate: Date,

    @Column(length = 50)
    var password: String,

    @Column(nullable = false)
    var name: String = "",

    @Column(unique = true, nullable = false)
    var email: String = "",

    @Column
    var cnpj: String = "",

    @Column
    var celphone: String = "",

    @ManyToMany
    @JoinTable(
        name = "CentralRole",
        joinColumns = [JoinColumn(name = "idCentral")],
        inverseJoinColumns = [JoinColumn(name = "idRole")]
    )
    val roles: MutableSet<Role> = mutableSetOf(),

    @OneToMany(mappedBy = "central", cascade = [CascadeType.ALL], orphanRemoval = true)
    var workers: MutableSet<Worker> = mutableSetOf(),

    @OneToMany(mappedBy = "responsibleCentral", cascade = [CascadeType.ALL], orphanRemoval = true)
    var assistances: MutableSet<Assistance> = mutableSetOf()
) {
    fun toResponse() = CentralResponse(id!!, name, email, creationDate, cnpj, celphone)
}
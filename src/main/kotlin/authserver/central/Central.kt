package authserver.central

import Role
import authserver.central.responses.UserResponse
import jakarta.persistence.*
import org.example.authserver.service.Assistance
import org.example.authserver.worker.Worker
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
    var description: String = "",

    @ManyToMany
    @JoinTable(
        name = "CentralRole",
        joinColumns = [JoinColumn(name = "idCentral")],
        inverseJoinColumns = [JoinColumn(name = "idRole")]
    )
    val roles: MutableSet<Role> = mutableSetOf(),

    @OneToMany(mappedBy = "central", cascade = [CascadeType.ALL], orphanRemoval = true)
    var workers: MutableSet<Worker> = mutableSetOf(),

    @OneToMany(mappedBy = "central", cascade = [CascadeType.ALL], orphanRemoval = true)
    var assistances: MutableSet<Assistance> = mutableSetOf()
) {
    fun toResponse() = UserResponse(id!!, name, email, creationDate,description)
}
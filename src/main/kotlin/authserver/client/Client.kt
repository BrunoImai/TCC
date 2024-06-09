package authserver.client

import authserver.assistance.Assistance
import authserver.central.Central
import authserver.client.response.ClientResponse
import jakarta.persistence.*
import jakarta.validation.constraints.Email
import java.util.*

@Entity
@Table(name = "Client")
class Client(
    @Id @GeneratedValue
    var id: Long? = null,

    @Column(nullable = false)
    var entryDate: Date,

    @Column(nullable = false)
    var address: String,

    @Column
    var complement: String,

    @Column(nullable = false)
    var name: String = "",

    @Column(unique = true, nullable = false)
    var cpf: String = "",

    @Column(nullable = false)
    var cellphone: String = "",

    @Email
    var email: String = "",

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "Central_id")
    var central: Central? = null,

    @OneToMany(mappedBy = "client", cascade = [CascadeType.ALL], orphanRemoval = true)
    var assistances: MutableSet<Assistance> = HashSet()
) {
    fun toResponse() = ClientResponse(id!!, name, cpf, address, complement, cellphone, email, assistances.map { it.id }.toSet(), entryDate)
}
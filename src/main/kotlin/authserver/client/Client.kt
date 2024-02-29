package authserver.client

import authserver.assistance.Assistance
import authserver.central.Central
import jakarta.persistence.*
import java.util.*

@Entity
@Table(name = "Client")
class Client(
    @Id @GeneratedValue
    var id: Long? = null,

    @Column(nullable = false)
    var entryDate: Date,

    @Column(nullable = false)
    var adress: String,

    @Column(nullable = false)
    var name: String = "",

    @Column(unique = true, nullable = false)
    var cpf: String = "",

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "Central_id")
    var central: Central? = null,

    @OneToMany(mappedBy = "client", cascade = [CascadeType.ALL], orphanRemoval = true)
    var assistances: MutableSet<Assistance> = HashSet()
) {
//    fun toResponse() = WorkerResponse(id!!, name, email, creationDate,description)
}
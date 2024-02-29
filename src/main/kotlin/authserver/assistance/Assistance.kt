package authserver.assistance

import authserver.central.Central
import jakarta.persistence.*
import authserver.client.Client
import org.example.authserver.utils.AssistanceStatus
import authserver.worker.Worker
import java.util.*

@Entity
@Table(name = "Assistance")
class Assistance(
    @Id @GeneratedValue
    var id: Long? = null,

    @Column(nullable = false)
    var orderDate: Date,

    @Column(nullable = false)
    var description: String,

    @Column(nullable = false)
    var name: String = "",

    @Column(nullable = false)
    var adress: String = "",

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    var assistanceStatus: AssistanceStatus = AssistanceStatus.EM_ANDAMENTO,

    @Column(unique = true, nullable = false)
    var cpf: String = "",

    @Column
    var hoursToFinish: Float,

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "central_id")
    var responsibleCentral: Central? = null,

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "client_id")
    var client: Client? = null,

    @ManyToMany
    @JoinTable(
        name = "assistance_worker",
        joinColumns = [JoinColumn(name = "assistance_id")],
        inverseJoinColumns = [JoinColumn(name = "worker_id")]
    )
    var responsibleWorkers: MutableSet<Worker> = HashSet()
) {
//    fun toResponse() = WorkerResponse(id!!, name, email, creationDate,description)
}
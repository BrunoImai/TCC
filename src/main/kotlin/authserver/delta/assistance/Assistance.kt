package authserver.delta.assistance

import authserver.delta.assistance.response.AssistanceResponse
import authserver.central.Central
import authserver.delta.category.Category
import jakarta.persistence.*
import authserver.delta.client.Client
import org.example.authserver.utils.AssistanceStatus
import authserver.delta.worker.Worker
import java.util.*

@Entity
@Table(name = "Assistance")
class Assistance(
    @Id @GeneratedValue
    var id: Long? = null,

    @Column(nullable = false)
    var startDate: Date,

    @Column
    var endDate: Date? = null,

    @Column(nullable = false)
    var description: String,

    @Column(nullable = false)
    var name: String = "",

    @Column(nullable = false)
    var address: String = "",

    @Column
    var complement: String? = null,

    @Column(nullable = false)
    var priority: Int = 0,

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    var assistanceStatus: AssistanceStatus = AssistanceStatus.AGUARDANDO,

    @Column(nullable = false)
    var cpf: String = "",

    @Column
    var period: String = "",

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
    var responsibleWorkers: MutableSet<Worker> = HashSet(),

    @ManyToMany
    @JoinTable(
        name = "categories_assistance",
        joinColumns = [JoinColumn(name = "assistance_id")],
        inverseJoinColumns = [JoinColumn(name = "category_id")]
    )
    var categories: MutableSet<Category> = HashSet()

) {
    fun toResponse() = AssistanceResponse(id!!, description, startDate ,name, address, complement, cpf, period, responsibleWorkers.map { it.id }.toSet())
}
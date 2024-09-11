package authserver.delta.budget

import authserver.central.Central
import authserver.central.notification.Notification
import authserver.delta.assistance.Assistance
import authserver.delta.budget.response.BudgetResponse
import authserver.delta.client.Client
import authserver.delta.worker.Worker
import jakarta.persistence.*
import java.util.*

@Entity
class Budget (
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    var id: Long? = null,

    var name: String,

    var description: String,

    @ManyToOne(fetch = FetchType.LAZY)
    var client: Client,

    @ManyToMany
    @JoinTable(
        name = "budget_worker",
        joinColumns = [JoinColumn(name = "budget_id")],
        inverseJoinColumns = [JoinColumn(name = "worker_id")]
    )
    var responsibleWorkers: MutableSet<Worker> = HashSet(),

    var status: BudgetStatus = BudgetStatus.EM_ANALISE,

    var creationDate: Date,

    var totalPrice: Float,

    @ManyToOne(fetch = FetchType.LAZY)
    var responsibleCentral: Central,

    @OneToMany(mappedBy = "budget", cascade = [CascadeType.ALL], orphanRemoval = true)
    var notifications: MutableSet<Notification> = mutableSetOf(),

    @ManyToOne(fetch = FetchType.LAZY)
    var assistance: Assistance? = null,

    ) {
    fun toResponse() = BudgetResponse(id!!, name, description, creationDate.toString(), status.toString(), assistance?.id, client.id!!, responsibleWorkers.map { it.id!! }, totalPrice)
}
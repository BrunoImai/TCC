package authserver.delta.budget

import authserver.central.Central
import authserver.delta.assistance.Assistance
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

    @OneToOne(mappedBy = "budget")
    var assistance: Assistance? = null,

    ) {}
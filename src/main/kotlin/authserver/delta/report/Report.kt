package authserver.delta.report

import authserver.central.Central
import authserver.delta.assistance.Assistance
import authserver.delta.report.response.ReportResponse
import authserver.delta.worker.Worker
import authserver.utils.PaymentType
import jakarta.persistence.*
import java.util.*

@Entity
class Report (
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    var id: Long? = null,

    @Column(nullable = false)
    var name: String = "",

    @Column(nullable = false)
    var description: String = "",

    @ManyToMany
    @JoinTable(
        name = "report_worker",
        joinColumns = [JoinColumn(name = "report_id")],
        inverseJoinColumns = [JoinColumn(name = "worker_id")]
    )
    var responsibleWorkers: MutableSet<Worker> = HashSet(),

    @Column
    var status: ReportStatus = ReportStatus.EM_ANALISE,

    @Column(nullable = false)
    var creationDate: Date,

    @Column
    var totalPrice: Float = 0.0f,

    @OneToOne(mappedBy = "report")
    var assistance: Assistance? = null,

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "Central_id")
    var responsibleCentral: Central,

    @Column
    var paymentType: PaymentType,

    @Column
    var machinePartExchange: Boolean,

    @Column
    var workDelayed: Boolean,

    ) {
    fun toResponse() = ReportResponse(id!!, name, description, creationDate.toString(), status.toString(), assistance?.id, responsibleWorkers.map { it.id!! }, totalPrice, paymentType, machinePartExchange, workDelayed)
}
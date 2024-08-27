package authserver.delta.report

import authserver.central.Central
import authserver.delta.assistance.Assistance
import authserver.delta.client.Client
import authserver.delta.report.response.ReportResponse
import authserver.delta.worker.Worker
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

    @ManyToOne(fetch = FetchType.LAZY)
    var client: Client,

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

    ) {
    fun toResponse() = ReportResponse(id!!, name, description, creationDate.toString(), status.toString(), assistance?.id, client.id!!, responsibleWorkers.map { it.id!! })
}
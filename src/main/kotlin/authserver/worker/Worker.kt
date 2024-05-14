package authserver.worker

import authserver.assistance.Assistance
import authserver.central.Central
import authserver.worker.response.WorkerResponse
import jakarta.persistence.*
import jakarta.validation.constraints.Email
import java.util.*

@Entity
@Table(name = "Worker")
class Worker(
    @Id @GeneratedValue
    var id: Long? = null,

    @Column(nullable = false)
    var entryDate: Date,

    @Email
    var email: String,

    @Column(length = 2000)
    var password: String,

    @Column
    var cellphone: String,

    @Column(nullable = false)
    var name: String = "",

    @Column(unique = true, nullable = false)
    var cpf: String = "",

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "Centra_id")
    var central: Central? = null,

    @ManyToMany(mappedBy = "responsibleWorkers")
    var currentAssistances: MutableSet<Assistance> = HashSet()
) {
    fun toResponse() = WorkerResponse(id!!, name, email, cpf, cellphone, entryDate)
}
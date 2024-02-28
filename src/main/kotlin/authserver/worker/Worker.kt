package org.example.authserver.worker

import authserver.central.Central
import jakarta.persistence.*
import org.example.authserver.service.Assistance
import java.util.*

@Entity
@Table(name = "Worker")
class Worker(
    @Id @GeneratedValue
    var id: Long? = null,

    @Column(nullable = false)
    var entryDate: Date,

    @Column(length = 50)
    var password: String,

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
//    fun toResponse() = WorkerResponse(id!!, name, email, creationDate,description)
}
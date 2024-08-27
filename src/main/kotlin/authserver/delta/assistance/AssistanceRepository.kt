package authserver.delta.assistance;

import authserver.central.Central
import authserver.delta.worker.Worker
import org.springframework.data.jpa.repository.JpaRepository

interface AssistanceRepository : JpaRepository<Assistance, Long> {
    fun findAllByResponsibleCentral(central: Central): List<Assistance>
    fun findByAddress(address: String): Assistance?
    fun findAllByResponsibleWorkersContains(worker: Worker): List<Assistance>
}
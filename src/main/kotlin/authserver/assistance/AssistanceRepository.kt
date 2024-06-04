package authserver.assistance;

import authserver.central.Central
import org.springframework.data.jpa.repository.JpaRepository

interface AssistanceRepository : JpaRepository<Assistance, Long> {
    fun findAllByResponsibleCentral(central: Central): List<Assistance>
    fun findByAddress(address: String): Assistance?
}
package authserver.j_audi.client_business

import authserver.central.Central
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository

@Repository
interface ClientBusinessRepository  : JpaRepository<ClientBusiness, Long> {
    fun findAllByResponsibleCentral(responsibleCentral: Central): List<ClientBusiness>
}
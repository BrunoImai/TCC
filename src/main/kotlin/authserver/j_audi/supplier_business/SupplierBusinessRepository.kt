package authserver.j_audi.supplier_business

import authserver.central.Central
import authserver.delta.client.Client
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository

@Repository
interface SupplierBusinessRepository : JpaRepository<SupplierBusiness, Long> {
    fun findAllByResponsibleCentral(responsibleCentral: Central): List<SupplierBusiness>

    fun findByCnpj(cnpj: String): SupplierBusiness?
}
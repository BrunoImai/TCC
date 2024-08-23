package authserver.j_audi.sale

import authserver.j_audi.products.Product
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository

@Repository
interface SaleRepository  : JpaRepository<Sale, Long> {
    fun findAllByClient_Id(clientId: Long): List<Sale>
    fun findAllBySupplier_Id(supplierId: Long): List<Sale>
}
package authserver.j_audi.products

import authserver.j_audi.supplier_business.SupplierBusiness
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository

@Repository
interface ProductRepository : JpaRepository<Product, Long> {
    fun findAllBySupplier(supplier : SupplierBusiness): List<Product>
}
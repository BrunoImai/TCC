package authserver.j_audi.products

import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository

@Repository
interface ProductQttRepository : JpaRepository<ProductQtt, Long> {
}
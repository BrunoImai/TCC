package authserver.j_audi.old_prices

import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository

@Repository
interface OldPricesRepository: JpaRepository<OldPrices, Long> {
}
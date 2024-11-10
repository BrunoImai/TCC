package authserver.delta.category

import authserver.central.Central
import authserver.delta.client.Client
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository

@Repository
interface CategoryRepository: JpaRepository<Category, Long> {
    fun findAllByCentral(central: Central): List<Category>
}
package authserver.client;

import authserver.central.Central
import org.springframework.data.jpa.repository.JpaRepository

interface ClientRepository : JpaRepository<Client, Long> {
    fun findAllByCentral (central: Central): List<Client>
}
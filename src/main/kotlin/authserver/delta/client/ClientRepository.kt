package authserver.delta.client;

import authserver.central.Central
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository

@Repository
interface ClientRepository : JpaRepository<Client, Long> {
    fun findAllByCentral (central: Central): List<Client>

    fun findByEmail(email: String): Client?

    fun findByCpf(cpf: String): Client?
}
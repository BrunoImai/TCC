package authserver.delta.worker;

import authserver.central.Central
import org.springframework.data.jpa.repository.JpaRepository

interface WorkerRepository : JpaRepository<Worker, Long> {
    fun findByEmail(email: String): Worker?

    fun findByCpf(cpf: String): Worker?

    fun findAllByCentral(central: Central): List<Worker>
}
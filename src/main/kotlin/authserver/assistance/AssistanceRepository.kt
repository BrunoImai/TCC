package authserver.assistance;

import org.springframework.data.jpa.repository.JpaRepository

interface AssistanceRepository : JpaRepository<Assistance, Long> {
}
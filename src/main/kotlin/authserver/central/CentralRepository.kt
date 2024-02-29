package authserver.central

import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.stereotype.Repository

@Repository
interface CentralRepository : JpaRepository<Central, Long> {
    @Query(
        value = "select distinct u from Central u" +
                " join u.roles r" +
                " where r.name = :role" +
                " order by u.name"
    )
    fun findAllByRole(role: String): List<Central>

    fun findByEmail(email: String): Central?
}
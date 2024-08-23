package authserver.central

import authserver.delta.assistance.Assistance
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

//    @Query("select u from Central u where u.email = :email")
    fun findByEmail(email: String): Central?

    fun findByCnpj(cnpj: String): Central?

    fun findByNewPasswordCode(code: String): Central?

    @Query("select c.assistanceQueue from Central c where c.id = :id")
    fun findAssistanceQueueById(id: Long): List<Assistance>

}
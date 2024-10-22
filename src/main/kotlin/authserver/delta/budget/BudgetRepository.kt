package authserver.delta.budget

import authserver.central.Central
import authserver.delta.worker.Worker
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository
import java.util.*

@Repository
interface BudgetRepository : JpaRepository<Budget, Long> {
    fun findAllByStatusAndClient_Central (status: BudgetStatus , central: Central) : List<Budget>

    fun findAllByResponsibleCentral(central: Central) : List<Budget>

    @Query("SELECT b FROM Budget b LEFT JOIN FETCH b.assistance WHERE b.id = :id")
    fun findByIdWithAssistance(@Param("id") id: Long): Budget?

    fun findAllByResponsibleWorkersContains(worker: Worker) : List<Budget>

    @Query("SELECT b FROM Budget b JOIN b.responsibleWorkers w WHERE w = :worker AND b.creationDate BETWEEN :startDate AND :endDate")
    fun findAllByWorkerAndDateRange(@Param("worker") worker: Worker, @Param("startDate") startDate: Date, @Param("endDate") endDate: Date): List<Budget>

}
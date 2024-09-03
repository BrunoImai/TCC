package authserver.delta.budget

import authserver.central.Central
import authserver.delta.worker.Worker
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository

@Repository
interface BudgetRepository : JpaRepository<Budget, Long> {
    fun findAllByStatusAndClient_Central (status: BudgetStatus , central: Central) : List<Budget>

    fun findAllByResponsibleCentral(central: Central) : List<Budget>

    fun findAllByResponsibleWorkersContains(worker: Worker) : List<Budget>
}
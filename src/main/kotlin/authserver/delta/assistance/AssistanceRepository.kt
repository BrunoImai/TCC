package authserver.delta.assistance;

import authserver.central.Central
import authserver.delta.budget.Budget
import authserver.delta.budget.BudgetStatus
import authserver.delta.worker.Worker
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query

interface AssistanceRepository : JpaRepository<Assistance, Long> {
    fun findAllByResponsibleCentral(central: Central): List<Assistance>
    //fun findByAddress(address: String):  List<Assistance>?
    fun findAllByResponsibleWorkersContains(worker: Worker): List<Assistance>

    @Query("SELECT a FROM Assistance a WHERE a.address LIKE %:address% AND a.assistanceStatus = 'AGUARDANDO'")
    fun findByAddress(address: String): List<Assistance>?

    fun findAssistanceByAssistanceStatusAndClient_Central(status: AssistanceStatus, central: Central) : List<Assistance>
}
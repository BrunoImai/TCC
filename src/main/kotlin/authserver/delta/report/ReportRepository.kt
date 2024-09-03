package authserver.delta.report

import authserver.central.Central
import authserver.delta.worker.Worker
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository

@Repository
interface ReportRepository : JpaRepository<Report, Long> {

    fun findAllByResponsibleCentral(central: Central) : List<Report>

    fun findAllByResponsibleWorkersContains(worker: Worker ) : List<Report>
}
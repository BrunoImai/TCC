package authserver.delta.report

import authserver.central.Central
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository

@Repository
interface ReportRepository : JpaRepository<Report, Long> {
    fun findAllByStatusAndClient_Central (status: ReportStatus , central: Central) : List<Report>
}
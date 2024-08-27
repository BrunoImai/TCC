package authserver.delta.worker

import authserver.delta.assistance.Assistance
import authserver.delta.assistance.AssistanceRepository
import authserver.delta.assistance.response.AssistanceResponse
import authserver.central.CentralRepository
import authserver.central.CentralService.Companion.log
import authserver.exception.InvalidCredentialException
import authserver.delta.maps.AddressResponse
import authserver.delta.maps.MapResponse
import authserver.security.UserToken
import authserver.security.Jwt
import authserver.utils.PasswordUtil
import authserver.delta.worker.response.WorkerLoginResponse
import br.pucpr.authserver.users.requests.LoginRequest
import jakarta.servlet.http.HttpServletRequest
import authserver.delta.assistance.AssistanceStatus
import authserver.delta.client.ClientRepository
import authserver.delta.report.Report
import authserver.delta.report.ReportRepository
import authserver.delta.report.request.ReportRequest
import org.springframework.data.repository.findByIdOrNull
import org.springframework.stereotype.Service
import org.springframework.web.client.RestTemplate
import java.time.LocalDate
import java.time.ZoneId
import java.util.*

@Service
class WorkerService (
    private val workerRepository: WorkerRepository,
    val jwt: Jwt,
    val request: HttpServletRequest,
    val centralRepository: CentralRepository,
    val assistanceRepository: AssistanceRepository,
    val clientRepository: ClientRepository,
    val reportRepository: ReportRepository
){
    var apiKey = "AIzaSyC7W_sMVL07McvWJcHGyVD9L0OydVx7rxY"

    fun getWorkerIdFromToken(): Long {
        val authentication = jwt.extract(request)

        return authentication?.let {
            val worker = it.principal as UserToken
            worker.id
        } ?: throw IllegalStateException("Funcionario não está autenticada!")
    }

    fun getClosestAssistance(currentLocation: String): AssistanceResponse {
        val worker = workerRepository.findByIdOrNull(getWorkerIdFromToken()) ?: throw IllegalStateException("Funcionario não encontrado")

        val priorityAssistances = listAllAssistanceQueueByCentralId().filter { it.priority > 2 }
        if (priorityAssistances.isNotEmpty()) {
            val assistance = priorityAssistances.minByOrNull { it.startDate }!!
            assistance.assistanceStatus = AssistanceStatus.EM_ANDAMENTO
            worker.currentAssistances.add(assistance)
            workerRepository.save(worker)
            assistance.responsibleWorkers.add(worker)
            assistanceRepository.save(assistance)
            return AssistanceResponse (
                assistance.id!!,
                assistance.description,
                assistance.startDate,
                assistance.name,
                assistance.address,
                assistance.complement,
                assistance.cpf,
                assistance.period,
                assistance.responsibleWorkers.map { it.id!! }.toSet(),
                assistance.categories.map { it.id!! }.toSet()
            )
        }
        val restTemplate = RestTemplate()
        val responses = listAllAssistanceQueueByCentralId().map { assistance ->
            val url = buildUrl(currentLocation, assistance.address)
            restTemplate.getForObject(url, MapResponse::class.java)
        }

        val closest = responses.filterNotNull().minByOrNull { it.routes[0].legs[0].duration.value }
        val closestAssistanceAddress =  AddressResponse(closest?.routes?.get(0)?.legs?.get(0)?.endAddress ?: "No valid address found")
        val closestAssistance = assistanceRepository.findByAddress(closestAssistanceAddress.address) ?: throw IllegalStateException("Serviço não encontrado")

        closestAssistance.assistanceStatus = AssistanceStatus.EM_ANDAMENTO

        worker.currentAssistances.add(closestAssistance)
        workerRepository.save(worker)
        closestAssistance.responsibleWorkers.add(worker)
        assistanceRepository.save(closestAssistance)

        return AssistanceResponse(
            closestAssistance.id!!,
            closestAssistance.description,
            closestAssistance.startDate,
            closestAssistance.name,
            closestAssistance.address,
            closestAssistance.complement,
            closestAssistance.cpf,
            closestAssistance.period,
            closestAssistance.responsibleWorkers.map{ it.id!! }.toSet(),
            closestAssistance.categories.map{ it.id!! }.toSet()
        )
    }

    fun login(credentials: LoginRequest): WorkerLoginResponse? {
        val worker = workerRepository.findByEmail(credentials.email!!) ?: throw InvalidCredentialException("Credenciais inválidas!")
        if (!PasswordUtil.verifyPassword(credentials.password!!, worker.password)) throw InvalidCredentialException("Credenciais inválidas!")
        log.info("Central logged in. id={} name={}", worker.id, worker.name)
        return WorkerLoginResponse(
            token = jwt.createWorkerToken(worker),
            worker.toResponse()
        )
    }


    fun listAllAssistanceQueueByCentralId(): List<Assistance> {
        val worker = workerRepository.findByIdOrNull(getWorkerIdFromToken()) ?: throw IllegalStateException("Funcionario não encontrado")
        val centralId = worker.central?.id
        val central = centralRepository.findByIdOrNull(centralId) ?: throw IllegalStateException("Central não encontrada")
        return central.assistanceQueue.map { it }
    }

    // Maps
//    fun getClosestAssist(currentLocation: String): AddressResponse {
//        val restTemplate = RestTemplate()
//        val responses = listAllAssistanceQueueByCentralId().map { assistance ->
//            val url = buildUrl(currentLocation, assistance.adress)
//            restTemplate.getForObject(url, MapResponse::class.java)
//        }
//
//        val closest = responses.filterNotNull().minByOrNull { it.routes[0].legs[0].duration.value }
//        return AddressResponse(closest?.routes?.get(0)?.legs?.get(0)?.endAddress ?: "No valid address found")
//    }

    fun createReport(reportReq: ReportRequest) : Report {
        val workerId = getWorkerIdFromToken()
        val worker = workerRepository.findByIdOrNull(workerId) ?: throw IllegalStateException("Funcionário não encontrada")
        val assistance = assistanceRepository.findByIdOrNull(reportReq.assistanceId) ?: throw IllegalStateException("Assistência não encontrada")

        val client = clientRepository.findByIdOrNull(reportReq.clientId) ?: throw IllegalStateException("Cliente não encontrado")
        val report = Report(
            name = reportReq.name,
            description = reportReq.description,
            creationDate = currentTime(),
            assistance = assistance,
            responsibleWorkers = mutableSetOf(worker),
            client = client,
            totalPrice = reportReq.totalPrice,
        )
        return reportRepository.save(report)
    }

    private fun buildUrl(origin: String, destination: String): String {
        return "https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&key=$apiKey"
    }

    fun currentTime() : Date {
        val currentDate = LocalDate.now()
        return Date.from(currentDate.atStartOfDay(ZoneId.systemDefault()).toInstant())
    }

}
package authserver.delta.worker

import authserver.delta.assistance.Assistance
import authserver.delta.assistance.AssistanceRepository
import authserver.delta.assistance.response.AssistanceResponse
import authserver.central.CentralRepository
import authserver.central.CentralService.Companion.log
import authserver.central.notification.Notification
import authserver.central.notification.NotificationRepository
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
import authserver.delta.budget.Budget
import authserver.delta.budget.BudgetRepository
import authserver.delta.budget.request.BudgetRequest
import authserver.delta.category.Category
import authserver.delta.category.CategoryRepository
import authserver.delta.client.Client
import authserver.delta.client.ClientRepository
import authserver.delta.report.Report
import authserver.delta.report.ReportRepository
import authserver.delta.report.request.ReportRequest
import org.springframework.data.repository.findByIdOrNull
import org.springframework.stereotype.Service
import org.springframework.web.client.RestTemplate
import java.time.LocalDate
import java.time.ZoneId
import java.time.temporal.TemporalAdjusters
import java.util.*

@Service
class WorkerService (
    private val workerRepository: WorkerRepository,
    val jwt: Jwt,
    val request: HttpServletRequest,
    val centralRepository: CentralRepository,
    val assistanceRepository: AssistanceRepository,
    val clientRepository: ClientRepository,
    val reportRepository: ReportRepository,
    val categoryRepository: CategoryRepository,
    val budgetRepository: BudgetRepository,
    val notificationRepository: NotificationRepository
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
                assistance.categories.map { it.id!! }.toSet(),
            )
        }
        val restTemplate = RestTemplate()
        val responses = listAllAssistanceQueueByCentralId().map { assistance ->
            val url = buildUrl(currentLocation, assistance.address)
            restTemplate.getForObject(url, MapResponse::class.java)
        }

        val closest = responses.filterNotNull().minByOrNull { it.routes[0].legs[0].duration.value }
        val closestAssistanceAddress =  AddressResponse(closest?.routes?.get(0)?.legs?.get(0)?.endAddress ?: "No valid address found")
        val closestAssistances = assistanceRepository.findByAddress(extractAddressWithNumber(closestAssistanceAddress.address)) ?: throw IllegalStateException("Serviço não encontrado")

        val closestAssistance = closestAssistances.first()
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
            closestAssistance.categories.map{ it.id!! }.toSet(),
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

    fun currentAssistance(): Assistance? {
        val worker = workerRepository.findByIdOrNull(getWorkerIdFromToken()) ?: throw IllegalStateException("Funcionario não encontrado")
        val currentAssistance = worker.currentAssistances.lastOrNull() ?: return null
        if (currentAssistance.assistanceStatus == AssistanceStatus.FINALIZADO || currentAssistance.assistanceStatus == AssistanceStatus.CANCELADO) {
            return null
        }
        return currentAssistance
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

    fun createBudget(budgetReq: BudgetRequest) : Budget {
        val workerId = getWorkerIdFromToken()
        val worker = workerRepository.findByIdOrNull(workerId) ?: throw IllegalStateException("Funcionário não encontrada")
        val assistance = assistanceRepository.findByIdOrNull(budgetReq.assistanceId) ?: throw IllegalStateException("Assistência não encontrada")

        val client = clientRepository.findByIdOrNull(budgetReq.clientId) ?: throw IllegalStateException("Cliente não encontrado")
        val budget = Budget(
            name = budgetReq.name,
            description = budgetReq.description,
            creationDate = currentTime(),
            assistance = assistance,
            responsibleWorkers = mutableSetOf(worker),
            client = client,
            totalPrice = budgetReq.totalPrice,
            responsibleCentral = worker.central!!,
        )

        val central = centralRepository.findByIdOrNull(worker.central?.id!!) ?: throw IllegalStateException("Central não encontrada")
        val createdBudget = budgetRepository.save(budget)

        assistance.budget = budget
        budget.assistance = assistance

        assistanceRepository.save(assistance)

        val notification = Notification(
            title = "Orçamento ${budgetReq.name}",
            message = "Um novo orçamento foi criado para a assistência ${assistance.name}",
            central = central,
            creationDate = currentTime(),
            budget = createdBudget
        )

        notificationRepository.save(notification)

        return createdBudget
    }


    fun getBudgetByAssistanceId (assistanceId: Long) : Budget? {
        val workerId = getWorkerIdFromToken()
        workerRepository.findByIdOrNull(workerId) ?: throw IllegalStateException("Funcionário não encontrada")
        val budget = budgetRepository.findByIdWithAssistance(assistanceId)
        return budget
    }

    fun getBudgetById (budgetId: Long) : Budget? {
        val workerId = getWorkerIdFromToken()
        workerRepository.findByIdOrNull(workerId) ?: throw IllegalStateException("Funcionário não encontrada")
        val budget = budgetRepository.findByIdOrNull(budgetId)
        return budget
    }

    fun updateBudget(budgetId: Long, budgetReq: BudgetRequest) : Budget {
        val budget = budgetRepository.findByIdOrNull(budgetId) ?: throw IllegalStateException("Orçamento não encontrado")
        val workerId = getWorkerIdFromToken()
        val worker = workerRepository.findByIdOrNull(workerId) ?: throw IllegalStateException("Funcionário não encontrada")
        if (budget.client.central != worker.central) throw IllegalStateException("Orçamento não encontrado")
        val workers = mutableListOf<Worker>()
        for (workerId in budgetReq.responsibleWorkersIds) {
            val worker = workerRepository.findByIdOrNull(workerId) ?: throw IllegalStateException("Funcionário não encontrado")
            if (worker.central != worker.central) throw IllegalStateException("Funcionário não encontrado")
            workers.add(worker)
        }
        val client = clientRepository.findByIdOrNull(budgetReq.clientId) ?: throw IllegalStateException("Cliente não encontrado")
        budget.name = budgetReq.name
        budget.description = budgetReq.description
        budget.client = client
        budget.responsibleWorkers = workers.toMutableSet()
        budget.status = budgetReq.status ?: throw IllegalStateException("Status não pode ser nulo")
        return budgetRepository.save(budget)
    }


    fun listBudgets(): List<Budget> {
        val workerId = getWorkerIdFromToken()
        val worker = workerRepository.findByIdOrNull(workerId) ?: throw IllegalStateException("Funcionário não encontrada")
        return budgetRepository.findAllByResponsibleWorkersContains(worker)
    }

    fun listWorkers(): List<Worker> {
        val workerId = getWorkerIdFromToken()
        val worker = workerRepository.findByIdOrNull(workerId) ?: throw IllegalStateException("Funcionário não encontrada")
        val central = centralRepository.findByIdOrNull(worker.central?.id!!) ?: throw IllegalStateException("Central não encontrada")
        return workerRepository.findAllByCentral(central)
    }

    fun listCategories(): List<Category> {
        val workerId = getWorkerIdFromToken()
        val worker = workerRepository.findByIdOrNull(workerId) ?: throw IllegalStateException("Funcionário não encontrada")
        centralRepository.findByIdOrNull(worker.central?.id!!) ?: throw IllegalStateException("Central não encontrada")
        return categoryRepository.findAll()
    }

    fun listAllAssistancesByWorker(): List<Assistance> {
        val workerId = getWorkerIdFromToken()
        val worker = workerRepository.findByIdOrNull(workerId) ?: throw IllegalStateException("Funcionário não encontrada")
        return assistanceRepository.findAllByResponsibleWorkersContains(worker)
    }

    fun getAssistanceById(id: Long): Assistance? {
        val workerId = getWorkerIdFromToken()
        val worker = workerRepository.findByIdOrNull(workerId) ?: throw IllegalStateException("Funcionário não encontrada")
        val assistances = assistanceRepository.findAllByResponsibleWorkersContains(worker)
        return assistances.filter { it.id == id }.first()
    }

    fun getClientByCpf(cpf: String): Client? {
        val workerId = getWorkerIdFromToken()
        val worker = workerRepository.findByIdOrNull(workerId) ?: throw IllegalStateException("Funcionário não encontrada")
        val central = centralRepository.findByIdOrNull(worker.central?.id!!) ?: throw IllegalStateException("Central não encontrada")
        return clientRepository.findByCpf(cpf)?.takeIf { it.central == central }
    }

    fun getClientById(id: Long): Client? {
        val workerId = getWorkerIdFromToken()
        val worker = workerRepository.findByIdOrNull(workerId) ?: throw IllegalStateException("Funcionário não encontrada")
        centralRepository.findByIdOrNull(worker.central?.id!!) ?: throw IllegalStateException("Central não encontrada")
        return clientRepository.findByIdOrNull(id)
    }


    // Report

    fun createReport(reportReq: ReportRequest) : Report {
        val workerId = getWorkerIdFromToken()
        val workerCreator =  workerRepository.findByIdOrNull(workerId) ?: throw IllegalStateException("Funcionário não encontrado")
        val central = centralRepository.findByIdOrNull(workerCreator.central?.id!!) ?: throw IllegalStateException("Central não encontrada")

        val workers = mutableListOf<Worker>()
        for (workerIds in reportReq.responsibleWorkersIds) {
            val worker = workerRepository.findByIdOrNull(workerIds) ?: throw IllegalStateException("Funcionário não encontrado")
            if (worker.central != central) throw IllegalStateException("Funcionário não encontrado")
            workers.add(worker)
        }

        val assistance = assistanceRepository.findByIdOrNull(reportReq.assistanceId) ?: throw IllegalStateException("Assistência não encontrada")

        val report = Report(
            name = reportReq.name,
            description = reportReq.description,
            creationDate = currentTime(),
            responsibleWorkers = workers.toMutableSet(),
            responsibleCentral = central,
            paymentType = reportReq.paymentType,
            machinePartExchange = reportReq.machinePartExchange,
            assistance = assistance,
            workDelayed = reportReq.delayed,
            )

        assistance.report = report
        assistance.assistanceStatus = AssistanceStatus.FINALIZADO
        assistanceRepository.save(assistance)


        return assistance.report!!

//        return reportRepository.save(report)
    }

    fun getReport(reportId: Long) : Report {
        val report = reportRepository.findByIdOrNull(reportId) ?: throw IllegalStateException("Relatório não encontrado")
        val workerId = getWorkerIdFromToken()
        val worker = workerRepository.findByIdOrNull(workerId) ?: throw IllegalStateException("Funcionário não encontrado")
        val central = worker.central
        if (report.responsibleCentral != central) throw IllegalStateException("Relatório não encontrado")
        return report
    }

    fun listReports() : List<Report> {
        val workerId = getWorkerIdFromToken()
        val worker = workerRepository.findByIdOrNull(workerId) ?: throw IllegalStateException("Funcionário não encontrado")
        return reportRepository.findAllByResponsibleWorkersContains(worker)
    }


    fun updateReport(reportId: Long, reportReq: ReportRequest) : Report {
        val report = reportRepository.findByIdOrNull(reportId) ?: throw IllegalStateException("Relatório não encontrado")
        val worker = workerRepository.findByIdOrNull(getWorkerIdFromToken()) ?: throw IllegalStateException("Funcionário não encontrado")
        val centralId = worker.central?.id!!
        val central = centralRepository.findByIdOrNull(centralId) ?: throw IllegalStateException("Central não encontrada")
        if (report.responsibleCentral != central) throw IllegalStateException("Relatório não encontrado")
        val workers = mutableListOf<Worker>()
        for (workerId in reportReq.responsibleWorkersIds) {
            val thisWorker = workerRepository.findByIdOrNull(workerId) ?: throw IllegalStateException("Funcionário não encontrado")
            if (thisWorker.central != central) throw IllegalStateException("Funcionário não encontrado")
            workers.add(worker)
        }
        report.name = reportReq.name
        report.description = reportReq.description
        report.responsibleWorkers = workers.toMutableSet()
        report.paymentType = reportReq.paymentType
        report.workDelayed = reportReq.delayed
        report.machinePartExchange = reportReq.machinePartExchange

        return reportRepository.save(report)
    }

    // Notifications

    fun listNotifications(): MutableSet<Notification> {
        val workerId = getWorkerIdFromToken()
        val worker = workerRepository.findByIdOrNull(workerId)
            ?: throw IllegalStateException("Funcionário não encontrado")

        // Get all budgets for which the worker is responsible
        val budgets = budgetRepository.findAllByResponsibleWorkersContains(worker)

        // Use flatMap to collect all notifications from the budgets and convert to a mutable set
        val notifications =  budgets.flatMap { budget ->
            notificationRepository.findAllByBudget(budget)
        }.toMutableSet()
        return notifications
    }

    fun listUnreadNotifications() : List<Notification> {
        val workerId = getWorkerIdFromToken()
        print("Entrou notificações não lidas worker")
        workerRepository.findByIdOrNull(workerId) ?: throw IllegalStateException("Funcionário não encontrado")
        val unreadedNotifications =  listNotifications().filter { !it.readed }
        return unreadedNotifications
    }

    fun getNotification(notificationId: Long) : Notification {
        val workerId = getWorkerIdFromToken()
        val worker = workerRepository.findByIdOrNull(workerId) ?: throw IllegalStateException("Funcionário não encontrado")
        return worker.central?.notifications?.find { it.id == notificationId } ?: throw IllegalStateException("Notificação não encontrada")
    }

    fun extractAddressWithNumber(input: String): String {
        val pattern = Regex("([\\w\\s.]+\\d+)")
        return pattern.find(input)!!.value
    }

    private fun buildUrl(origin: String, destination: String): String {
        val url = "https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&key=$apiKey"
        return url
    }

    fun getCommissionForMonth(date: Date): Double {
        val workerId = getWorkerIdFromToken()
        val worker = workerRepository.findByIdOrNull(workerId) ?: throw IllegalStateException("Funcionário não encontrado")
        centralRepository.findByIdOrNull(worker.central?.id!!) ?: throw IllegalStateException("Central não encontrada")

        // Converter a data para LocalDate para facilitar a manipulação do mês
        val localDate = date.toInstant().atZone(ZoneId.systemDefault()).toLocalDate()

        // Definir a data inicial e final do mês da data fornecida
        val startOfMonth = localDate.with(TemporalAdjusters.firstDayOfMonth())
        val endOfMonth = localDate.with(TemporalAdjusters.lastDayOfMonth())

        // Converter as datas de volta para Date
        val startDate = Date.from(startOfMonth.atStartOfDay(ZoneId.systemDefault()).toInstant())
        val endDate = Date.from(endOfMonth.atStartOfDay(ZoneId.systemDefault()).toInstant())

        // Obter os budgets do worker para o intervalo de datas
        val budgets = budgetRepository.findAllByWorkerAndDateRange(worker, startDate, endDate)

        // Calcular a comissão do worker para este mês
        val commissionPercentage = worker.commissionPorcentage?.toDouble() ?: 0.0
        return budgets.sumOf { it.totalPrice.toDouble() * commissionPercentage / 100 }
    }

    fun getCommissionByService(serviceId: Long): Double {
        val workerId = getWorkerIdFromToken()
        val worker = workerRepository.findByIdOrNull(workerId) ?: throw IllegalStateException("Funcionário não encontrado")
        centralRepository.findByIdOrNull(worker.central?.id!!) ?: throw IllegalStateException("Central não encontrada")
        val budget = budgetRepository.findByIdOrNull(serviceId) ?: throw IllegalStateException("Orçamento não encontrado")

        // Verifica se a porcentagem de comissão é válida e converte para um tipo Float
        val commissionPercentage = worker.commissionPorcentage.toDouble() ?: 0.0

        // Calcula a comissão do budget
        return budget.totalPrice * commissionPercentage / 100
    }

    fun getAllCommissions(): Double {
        val workerId = getWorkerIdFromToken()
        val worker = workerRepository.findByIdOrNull(workerId) ?: throw IllegalStateException("Funcionário não encontrado")
        centralRepository.findByIdOrNull(worker.central?.id!!) ?: throw IllegalStateException("Central não encontrada")

        // Obter todos os budgets do worker
        val budgets = budgetRepository.findAllByResponsibleWorkersContains(worker)

        // Calcular a comissão total do worker
        val commissionPercentage = worker.commissionPorcentage?.toDouble() ?: 0.0
        return budgets.sumOf { it.totalPrice.toDouble() * commissionPercentage / 100 }
    }





    fun currentTime() : Date {
        val currentDate = LocalDate.now()
        return Date.from(currentDate.atStartOfDay(ZoneId.systemDefault()).toInstant())
    }

}
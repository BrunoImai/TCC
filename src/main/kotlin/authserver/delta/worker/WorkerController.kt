package authserver.delta.worker

import authserver.delta.budget.request.BudgetRequest
import authserver.delta.report.request.ReportRequest
import br.pucpr.authserver.users.requests.LoginRequest
import jakarta.validation.Valid
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*

@RestController
@RequestMapping("/worker")
class WorkerController(
    val service: WorkerService
) {
    @PostMapping("/login")
    fun login(@Valid @RequestBody credentials: LoginRequest) =
        service.login(credentials)
            ?.let {
                ResponseEntity.ok(it)
            }

    @GetMapping("/assistance")
    fun getAssistances() =
        service.listAllAssistancesByWorker()
            .map{ it.toResponse() }
            .let { ResponseEntity.ok(it) }

    @GetMapping("/assistance/{id}")
    fun getAssistanceById(@PathVariable("id") id: Long) =
        service.getAssistanceById(id)
            ?.toResponse()
            .let { ResponseEntity.ok(it) }

    @GetMapping("/assistance/currentAssistance")
    fun getLastAssistance() =
        service.currentAssistance()
            ?.toResponse()
            ?.let { ResponseEntity.ok(it) }
            ?: ResponseEntity.notFound().build()

    @PostMapping("/budget")
    fun createBudget(@Valid @RequestBody budgetRequest: BudgetRequest) =
        service.createBudget(budgetRequest)
            .toResponse()
            .let {
                ResponseEntity.ok(it)
            }

    @GetMapping("/budget")
    fun getBudgets() =
        service.listBudgets()
            .map{ it.toResponse() }
            .let { ResponseEntity.ok(it) }

    @GetMapping("/budget/byAssistance/{id}")
    fun getBudgetByAssistanceId(@PathVariable("id") id: Long) =
        service.getBudgetByAssistanceId(id)
            ?.toResponse()
            .let { ResponseEntity.ok(it) }

    @GetMapping("/budget/{id}")
    fun getBudgetById(@PathVariable("id") id: Long) =
        service.getBudgetById(id)
            ?.toResponse()
            .let { ResponseEntity.ok(it) }

    @PutMapping("/budget/{id}")
    fun updateBudget(@PathVariable("id") id: Long, @Valid @RequestBody req: BudgetRequest) =
        service.updateBudget(id, req)
            .toResponse()
            .let { ResponseEntity.ok(it) }

    @GetMapping("/assistance/closest")
    fun getClosestAssistance(@RequestParam("coordinate") coordinate: String) =
        service.getClosestAssistance(coordinate)

    @PostMapping("/report")
    fun createReport(@Valid @RequestBody reportRequest: ReportRequest) =
        service.createReport(reportRequest)
            .toResponse()
            .let {
                ResponseEntity.ok(it)
            }

    @GetMapping("/report")
    fun listReports() =
        service.listReports()
            .map { it.toResponse() }
            .let { ResponseEntity.ok(it) }

    @GetMapping("/category")
    fun listCategories() =
        service.listCategories()
            .map { it.toResponse() }

    @GetMapping("/worker")
    fun listWorkers() =
        service.listWorkers()
            .map { it.toResponse() }

    @GetMapping("/client/byCpf/{cpf}")
    fun getClientByCpf(@PathVariable("cpf") cpf: String) =
        service.getClientByCpf(cpf)
            ?.toResponse()
            ?.let { ResponseEntity.ok(it) }
            ?: ResponseEntity.notFound().build()

    @GetMapping("/client/{id}")
    fun getClientByCpf(@PathVariable("id") id: Long) =
        service.getClientById(id)
            ?.toResponse()
            ?.let { ResponseEntity.ok(it) }
            ?: ResponseEntity.notFound().build()

    @GetMapping("/notification")
    fun listNotifications() =
        service.listNotifications()
            .map { it.toResponse() }

    @GetMapping("/notification/{id}")
    fun getNotification(@PathVariable("id") id: Long) =
        service.getNotification(id)
            .toResponse()
            .let { ResponseEntity.ok(it) }
            ?: ResponseEntity.notFound().build()

    @GetMapping("/notification/unread")
    fun listUnreadNotifications() =
        service.listUnreadNotifications()
            .map { it.toResponse() }
}
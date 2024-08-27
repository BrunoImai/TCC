package authserver.delta.worker

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

    @GetMapping("/assistance/closest")
    fun getClosestAssistance(@RequestParam("coordinate") coordinate: String) = service.getClosestAssistance(coordinate)

    @PostMapping("/report")
    fun createReport(@Valid @RequestBody reportRequest: ReportRequest) =
        service.createReport(reportRequest)
            .toResponse()
            .let {
                ResponseEntity.ok(it)
            }
}
package authserver.worker

import br.pucpr.authserver.users.requests.LoginRequest
import ch.qos.logback.core.recovery.RecoveryCoordinator
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

    @PostMapping("/assistance/closest")
    fun getClosestAssistance(@RequestParam("coordinate") coordinate: String) = service.getClosestAssistance(coordinate)
}
package authserver.worker

import ch.qos.logback.core.recovery.RecoveryCoordinator
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RequestParam
import org.springframework.web.bind.annotation.RestController

@RestController
@RequestMapping("/worker")
class WorkerController(
    val service: WorkerService
) {
    @PostMapping("/assistance/closest")
    fun getClosestAssistance(@RequestParam("coordinate") coordinate: String) = service.getClosestAssistance(coordinate)
}
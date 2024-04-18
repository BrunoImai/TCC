package authserver.central

import authserver.central.requests.CentralPasswordChange
import authserver.client.Client
import authserver.client.requests.ClientRequest
import br.pucpr.authserver.users.requests.LoginRequest
import authserver.central.requests.CentralRequest
import authserver.central.requests.CentralUpdateRequest
import io.swagger.v3.oas.annotations.Operation
import io.swagger.v3.oas.annotations.Parameter
import jakarta.transaction.Transactional
import jakarta.validation.Valid
import org.springframework.http.HttpStatus
import org.springframework.http.HttpStatus.CREATED
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*

@RestController
@RequestMapping("/central")
class CentralController(val service: CentralService) {

    // CENTRAL
    @Operation(
        summary = "Lista todas as centrais",
        parameters = [
            Parameter(
                name = "role",
                description = "Papel a ser usado no filtro (opcional)",
                example = "USER"
            )]
    )

    @Transactional
    @PostMapping
    fun createCentral(@Valid @RequestBody req: CentralRequest) =
        service.createCentral(req)
            .let { ResponseEntity.status(CREATED).body(it) }

    @PostMapping("/login")
    fun login(@Valid @RequestBody credentials: LoginRequest) =
        service.centralLogin(credentials)
            ?.let { ResponseEntity.ok(it) }
            ?: ResponseEntity.status(HttpStatus.UNAUTHORIZED).build()

    @DeleteMapping("/{id}")
    fun delete(@PathVariable("id") id: Long): ResponseEntity<Void> =
        if (service.centralSelfDelete(id)) ResponseEntity.ok().build()
        else ResponseEntity.notFound().build()

    @PutMapping("/update/{id}")
    fun updateCentral(@PathVariable("id") id: Long, @Valid @RequestBody req: CentralUpdateRequest) =
        service.updateCentral(id, req)
            .let { ResponseEntity.ok(it) }

    @PostMapping("/login/sendToken")
    fun sendToken(@RequestParam("email") email: String) =
        service.generatePasswordCode(email)
            .let { ResponseEntity.ok(it) }

    @PostMapping("/login/validateToken")
    fun validateToken(@RequestParam("email") email: String, @RequestParam("code") code: String) =
        service.validateCode(email, code)
            .let { ResponseEntity.ok(it) }

    @PostMapping("/login/resetPassword")
    fun resetPassword(@RequestBody CentralRequest: CentralPasswordChange) =
        service.resetPassword(CentralRequest)
            .let { ResponseEntity.ok(it) }


    // Client

    @GetMapping("/client/{id}")
    fun getClient(@PathVariable("id") id: Long) =
        service.getClient(id)
            ?.toResponse()
            ?.let { ResponseEntity.ok(it) }
            ?: ResponseEntity.notFound().build()

    @GetMapping("/client")
    fun listClients() =
        service.listClients()
            .map { it.toResponse() }

    @PostMapping("/client")
    fun createClient(@Valid @RequestBody req: ClientRequest) =
        service.createClient(req)
            .toResponse()
            .let {
                ResponseEntity.status(CREATED).body(it)

            }

    @PutMapping("/client/{id}")
    fun updateClient(@PathVariable("id") id: Long, @Valid @RequestBody client: ClientRequest) =
        service.updateClient(id, client)
            .toResponse()
            .let { ResponseEntity.ok(it) }

    @DeleteMapping("/client/{id}")
    fun deleteClient(@PathVariable("id") id: Long) =
        if (service.deleteClient(id)) ResponseEntity.ok()
        else ResponseEntity.notFound()
}
package authserver.central

import authserver.delta.assistance.request.AssistanceRequest
import authserver.central.requests.CentralPasswordChange
import authserver.delta.client.requests.ClientRequest
import br.pucpr.authserver.users.requests.LoginRequest
import authserver.central.requests.CentralRequest
import authserver.central.requests.CentralUpdateRequest
import authserver.delta.worker.requests.WorkerRequest
import authserver.delta.worker.requests.WorkerUpdateRequest
import authserver.j_audi.products.requests.ProductRequest
import authserver.j_audi.products.requests.UpdateProductRequest
import authserver.j_audi.supplier_business.requests.SupplierBusinessRequest
import authserver.j_audi.supplier_business.response.SupplierBusinessResponse
import io.swagger.v3.oas.annotations.Operation
import io.swagger.v3.oas.annotations.Parameter
import jakarta.transaction.Transactional
import jakarta.validation.Valid
import org.springframework.http.HttpStatus.CREATED
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*
import java.net.URLDecoder
import java.nio.charset.StandardCharsets

@RestController
@RequestMapping("/central")
class CentralController(
    val service: CentralService,
    private val centralService: CentralService
) {

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
            ?.let {
                ResponseEntity.ok(it)
            }


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

    // Assistance

    @PostMapping("/assistance")
    fun addAssistance(@Valid @RequestBody assistance: AssistanceRequest) =
        service.createAssistance(assistance)
            .toResponse()
            .let { ResponseEntity.ok(it) }

    @GetMapping("/assistance")
    fun getAssistances() =
        service.listAllAssistancesByCentralId()
            .map{ it.toResponse() }
            .let { ResponseEntity.ok(it) }

    @GetMapping("/assistance/{id}")
    fun getAssistance(@PathVariable("id") id: Long) =
        service.getAssistance(id)
            ?.toResponse()
            .let { ResponseEntity.ok(it) }

    @PutMapping("/assistance/{id}")
    fun updateAssistance(@PathVariable("id") id: Long, @Valid @RequestBody assistance: AssistanceRequest) =
        service.updateAssistance(id, assistance)
            .toResponse()
            .let { ResponseEntity.ok(it) }

    @DeleteMapping("/assistance/{id}")
    fun deleteAssistance(@PathVariable("id") id: Long) =
        if (service.deleteAssistance(id)) ResponseEntity.ok()
        else ResponseEntity.notFound()


    // Client

    @GetMapping("/client/{id}")
    fun getClient(@PathVariable("id") id: Long) =
        service.getClient(id)
            ?.toResponse()
            ?.let { ResponseEntity.ok(it) }
            ?: ResponseEntity.notFound().build()

    @GetMapping("/client/byCpf/{cpf}")
    fun getClientByCpf(@PathVariable("cpf") cpf: String) =
        service.getClientByCpf(cpf)
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

    // Worker

    @GetMapping("/worker/{id}")
    fun getWorker(@PathVariable("id") id: Long) =
        service.getWorker(id)
            ?.toResponse()
            ?.let { ResponseEntity.ok(it) }
            ?: ResponseEntity.notFound().build()

    @GetMapping("/worker")
    fun listWorkers() =
        service.listWorkers()
            .map { it.toResponse() }

    @PostMapping("/worker")
    fun createWorker(@Valid @RequestBody req: WorkerRequest) =
        service.createWorker(req)
            .toResponse()
            .let {
                ResponseEntity.status(CREATED).body(it)
            }

    @PutMapping("/worker/{id}")
    fun updateWorker(@PathVariable("id") id: Long, @Valid @RequestBody worker: WorkerUpdateRequest) =
        service.updateWorker(id, worker)
            .toResponse()
            .let { ResponseEntity.ok(it) }

    @DeleteMapping("/worker/{id}")
    fun deleteWorker(@PathVariable("id") id: Long): ResponseEntity<Void> =
        if (service.deleteWorker(id)) ResponseEntity.ok().build()
        else ResponseEntity.notFound().build()

    // Supplier Business

    @GetMapping("/supplierBusiness/{id}")
    fun getSupplierBusiness(@PathVariable("id") id: Long) =
        service.getSupplier(id)
            ?.toResponse()
            ?.let { ResponseEntity.ok(it) }
            ?: ResponseEntity.notFound().build()

    @GetMapping("/supplierBusiness/byCnpj")
    fun getSupplierBusinessByCnpj(@RequestParam("cnpj") cnpj: String) =
        service.getSupplierByCnpj(cnpj)
            ?.toResponse()
            .let { ResponseEntity.ok(it) }
            ?: ResponseEntity.notFound().build()

    @GetMapping("/supplierBusiness")
    fun listSupplierBusiness() =
        service.listSuppliers()
            .map { it.toResponse() }

    @PostMapping("/supplierBusiness")
    fun createSupplierBusiness(@Valid @RequestBody req: SupplierBusinessRequest) =
        service.createSupplier(req)
            .toResponse()
            .let {
                ResponseEntity.status(CREATED).body(it)
            }

    @PutMapping("/supplierBusiness/{id}")
    fun updateSupplierBusiness(@PathVariable("id") id: Long, @Valid @RequestBody supplier: SupplierBusinessRequest) =
        service.updateSupplier(id, supplier)
            .toResponse()
            .let { ResponseEntity.ok(it) }

    @DeleteMapping("/supplierBusiness/{id}")
    fun deleteSupplierBusiness(@PathVariable("id") id: Long): ResponseEntity<Void> =
        if (service.deleteSupplier(id)) ResponseEntity.ok().build()
        else ResponseEntity.notFound().build()

    @GetMapping("/supplierBusiness/{id}/products")
    fun listProducts(@PathVariable("id") id: Long) =
        service.listProductsBySupplier(id)
            .map { it.toResponse() }

    // Product

    @GetMapping("/product/{id}")
    fun getProduct(@PathVariable("id") id: Long) =
        service.getProduct(id)
            ?.toResponse()
            ?.let { ResponseEntity.ok(it) }
            ?: ResponseEntity.notFound().build()

    @GetMapping("/product")
    fun listProducts() =
        service.listProducts()
            .map { it.toResponse() }

    @PostMapping("/product")
    fun createProduct(@Valid @RequestBody req: ProductRequest) =
        service.createProduct(req)
            .toResponse()
            .let {
                ResponseEntity.status(CREATED).body(it)
            }

    @PutMapping("/product/{id}")
    fun updateProduct(@PathVariable("id") id: Long, @Valid @RequestBody product: UpdateProductRequest) =
        service.updateProduct(id, product)
            .toResponse()
            .let { ResponseEntity.ok(it) }

    @DeleteMapping("/product/{id}")
    fun deleteProduct(@PathVariable("id") id: Long): ResponseEntity<Void> =
        if (service.deleteProduct(id)) ResponseEntity.ok().build()
        else ResponseEntity.notFound().build()
}
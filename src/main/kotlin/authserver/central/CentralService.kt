package authserver.central

import authserver.central.notification.Notification
import authserver.central.notification.NotificationRepository
import authserver.delta.assistance.Assistance
import authserver.delta.assistance.AssistanceRepository
import authserver.delta.assistance.request.AssistanceRequest
import authserver.central.requests.CentralPasswordChange
import authserver.central.requests.CentralRequest
import authserver.central.requests.CentralUpdateRequest
import authserver.security.Jwt
import authserver.security.UserToken

import br.pucpr.authserver.users.requests.LoginRequest
import authserver.central.responses.CentralLoginResponse
import jakarta.servlet.http.HttpServletRequest
import authserver.central.role.RolesRepository
import authserver.delta.assistance.AssistanceStatus
import authserver.delta.category.Category
import authserver.delta.category.CategoryRepository
import authserver.delta.category.request.CategoryRequest
import authserver.delta.client.Client
import authserver.delta.client.ClientRepository
import authserver.delta.client.requests.ClientRequest
import authserver.delta.budget.Budget
import authserver.delta.budget.BudgetRepository
import authserver.delta.budget.request.BudgetRequest
import authserver.delta.budget.BudgetStatus
import authserver.delta.report.Report
import authserver.delta.report.ReportRepository
import authserver.delta.report.request.ReportRequest
import authserver.exception.InvalidCredentialException
import authserver.utils.PasswordUtil
import authserver.delta.worker.Worker
import authserver.delta.worker.WorkerRepository
import authserver.delta.worker.requests.WorkerRequest
import authserver.delta.worker.requests.WorkerUpdateRequest
import authserver.j_audi.client_business.ClientBusiness
import authserver.j_audi.client_business.ClientBusinessRepository
import authserver.j_audi.client_business.request.ClientBusinessRequest
import authserver.j_audi.old_prices.OldPrices
import authserver.j_audi.products.Product
import authserver.j_audi.products.ProductQtt
import authserver.j_audi.products.ProductQttRepository
import authserver.j_audi.products.ProductRepository
import authserver.j_audi.products.requests.ProductRequest
import authserver.j_audi.products.requests.UpdateProductRequest
import authserver.j_audi.sale.Sale
import authserver.j_audi.sale.SaleRepository
import authserver.j_audi.sale.requests.SaleRequest
import authserver.j_audi.supplier_business.SupplierBusiness
import authserver.j_audi.supplier_business.SupplierBusinessRepository
import authserver.j_audi.supplier_business.requests.SupplierBusinessRequest
import com.amazonaws.regions.Regions
import com.amazonaws.services.simpleemail.AmazonSimpleEmailServiceClientBuilder
import com.amazonaws.services.simpleemail.model.*
import org.slf4j.LoggerFactory
import org.springframework.data.domain.Sort
import org.springframework.data.repository.findByIdOrNull
import org.springframework.stereotype.Service
import java.time.LocalDate
import java.time.LocalDateTime
import java.time.ZoneId
import java.util.*

@Service
class CentralService(
    val centralRepository: CentralRepository,
    val rolesRepository: RolesRepository,
    val workerRepository: WorkerRepository,
    val assistanceRepository: AssistanceRepository,
    val jwt: Jwt,
    val request: HttpServletRequest,
    private val clientRepository: ClientRepository,
    private val supplierRepository: SupplierBusinessRepository,
    private val productRepository: ProductRepository,
    private val categoryRepository: CategoryRepository,
    private val clientBusinessRepository: ClientBusinessRepository,
    private val saleRepository: SaleRepository,
    private val productQttRepository: ProductQttRepository,
    private val budgetRepository: BudgetRepository,
    private val reportRepository: ReportRepository,
    private val notificationRepository: NotificationRepository
    ) {

    fun getCentralIdFromToken(): Long {
        val authentication = jwt.extract(request)

        return authentication?.let {
            val central = it.principal as UserToken
            central.id
        } ?: throw IllegalStateException("Central não está autenticada!")
    }


    fun createCentral(req: CentralRequest): CentralLoginResponse {

        if (centralRepository.findByEmail(req.email!!) != null) throw IllegalStateException("Email já cadastrado!")
        if (centralRepository.findByCnpj(req.cnpj!!) != null) throw IllegalStateException("CNPJ já cadastrado!")

        // Convert LocalDate to Date

        log.info("entrou")
        val central = Central(
            email = req.email,
            password = PasswordUtil.hashPassword(req.password!!),
            name = req.name!!,
            creationDate = currentTime(),
            cnpj = req.cnpj,
            cellphone = req.cellphone!!
        )
        val userRole = rolesRepository.findByName("CENTRAL")
            ?: throw IllegalStateException("Central não encontrada")

        central.roles.add(userRole)

        val newCentral = centralRepository.save(central)

        return CentralLoginResponse(
            token = jwt.createCentralToken(central),
            newCentral.toResponse()
        )
    }

    fun getCentralById(id: Long) = centralRepository.findByIdOrNull(id)

    fun findAllCentrals(role: String?): List<Central> =
        if (role == null) centralRepository.findAll(Sort.by("name"))
        else centralRepository.findAllByRole(role)

    fun centralLogin(credentials: LoginRequest): CentralLoginResponse? {
        val central = centralRepository.findByEmail(credentials.email!!) ?: throw InvalidCredentialException("Credenciais inválidas!")
        if (!PasswordUtil.verifyPassword(credentials.password!!, central.password)) throw InvalidCredentialException("Credenciais inválidas!")
        log.info("Central logged in. id={} name={}", central.id, central.name)
        return CentralLoginResponse(
            token = jwt.createCentralToken(central),
            central.toResponse()
        )
    }


    fun centralSelfDelete(id: Long): Boolean {
        val central = centralRepository.findByIdOrNull(id) ?: return false
        if (central.id != getCentralIdFromToken()) throw IllegalStateException("Somente a própria central pode se deletar!")
        log.warn("Central deleted. id={} name={}", central.id, central.name)
        centralRepository.delete(central)
        return true
    }

    fun updateCentral(id: Long, centralUpdated: CentralUpdateRequest): Central {
        val central = getCentralById(id) ?: throw IllegalStateException("Central não encontrada!")
        if (central.id != getCentralIdFromToken()) throw IllegalStateException("Somente a própria central pode se atualizar!")

        if (centralUpdated.newPassword == null) {
            central.email = centralUpdated.email!!
            central.name = centralUpdated.name!!
            central.cnpj = centralUpdated.cnpj!!
            central.cellphone = centralUpdated.cellphone!!
            return centralRepository.save(central)
        } else if (PasswordUtil.verifyPassword(centralUpdated.oldPassword!!, central.password)) {
            central.email = centralUpdated.email!!
            central.name = centralUpdated.name!!
            central.cnpj = centralUpdated.cnpj!!
            central.cellphone = centralUpdated.cellphone!!
            central.password = PasswordUtil.hashPassword(centralUpdated.newPassword)
            return centralRepository.save(central)
        } else {
            throw IllegalStateException("As senhas não conferem!")
        }
    }

    fun sendEmail(to: String, subject: String, bodyHtml: String) {
        val client = AmazonSimpleEmailServiceClientBuilder.standard()
            .withRegion(Regions.SA_EAST_1) // Specify the AWS region
            .build()

        val request = SendEmailRequest().apply {
            source = "equipe.a.g.e.oficial@gmail.com"
            destination = Destination().withToAddresses(to)
            message = Message().apply {
                body = Body().withHtml(Content().withData(bodyHtml))
            }
            message.subject = Content().withData(subject)
        }

        try {
            client.sendEmail(request)
            log.info("Email sent successfully to $to")
        } catch (e: Exception) {
            log.error("Failed to send email: ${e.message}")
        }
    }

    fun generatePasswordCode(email: String) {
        val central = centralRepository.findByEmail(email) ?: throw IllegalStateException("Email invalido")
        val newPasswordCode = UUID.randomUUID().toString().substring(0, 6)
        central.newPasswordCode = newPasswordCode
        sendEmail(
            to = email,
            subject = "AGE - Recuperação de senha",
            bodyHtml = "Olá, ${central.name}! <br> Seu código de recuperação de senha é: <b>$newPasswordCode</b>"
        )
        centralRepository.save(central)
    }

    fun validateCode(email: String, code: String): Boolean {
        val central = centralRepository.findByEmail(email) ?: throw IllegalStateException("Email invalido")
        if(centralRepository.findByNewPasswordCode(code) == null) throw IllegalStateException("Token invalido")
        return if (central.newPasswordCode == code) {
            central.newPasswordCode = null
            true
        } else {
            false
        }
    }

    fun resetPassword(centralPasswordChange: CentralPasswordChange): Boolean {
        val central = centralRepository.findByNewPasswordCode(centralPasswordChange.token!!) ?: throw IllegalStateException("Token inválido!")
        central.password = PasswordUtil.hashPassword(centralPasswordChange.password!!)
        central.newPasswordCode = null
        centralRepository.save(central)
        return true
    }

    //CLIENT

    fun getClient(clientId: Long): Client? {
        val centralId = getCentralIdFromToken()
        val central = centralRepository.findByIdOrNull(centralId) ?: throw IllegalStateException("Central não encontrada")
        val client = clientRepository.findByIdOrNull(clientId) ?: throw IllegalStateException("Cliente não encontrado")
        if (client.central != central) throw IllegalStateException("Cliente não encontrado")
        return client
    }

    fun getClientByCpf(cpf: String): Client? {
        val centralId = getCentralIdFromToken()
        val central = centralRepository.findByIdOrNull(centralId) ?: throw IllegalStateException("Central não encontrada")
        return clientRepository.findByCpf(cpf)?.takeIf { it.central == central }
    }


    fun createClient(req: ClientRequest): Client {
        val centralId = getCentralIdFromToken()
        val central = centralRepository.findByIdOrNull(centralId) ?: throw IllegalStateException("Central não encontrada")

        if (clientRepository.findByEmail(req.email) != null) throw IllegalStateException("Email do cliente já cadastrado!")
        if (clientRepository.findByCpf(req.cpf) != null) throw IllegalStateException("CPF do cliente já cadastrado!")

        val client = Client(
            email = req.email,
            name = req.name,
            cpf = req.cpf,
            cellphone = req.cellphone,
            entryDate = currentTime(),
            central = central,
            address = req.address,
            complement = req.complement
        )

        return clientRepository.save(client)
    }

    fun deleteClient(clientId: Long): Boolean {
        val client = getClient(clientId) ?: return false

        log.warn("Client deleted deleted. id={} name={}", client.id, client.name)
        clientRepository.delete(client)
        return true
    }

    fun updateClient(id: Long, clientUpdated: ClientRequest): Client {
        val client = getClient(id) ?: throw IllegalStateException("Cliente não encontrado")

        val existingClientWithSameCpf = clientRepository.findByCpf(clientUpdated.cpf!!)
        if (existingClientWithSameCpf != null && existingClientWithSameCpf.id != id) {
            throw IllegalStateException("Já existe outro cliente cadastrado com este CPF.")
        }

        client.email = clientUpdated.email
        client.name = clientUpdated.name
        client.address = clientUpdated.address
        client.cellphone = clientUpdated.cellphone
        client.cpf = clientUpdated.cpf
        return clientRepository.save(client)
    }

    fun listClients(): List<Client> {
        val centralId = getCentralIdFromToken()
        val central = getCentralById(centralId) ?: throw IllegalStateException("Central não encontrada")
        return clientRepository.findAllByCentral(central)
    }

    // WORKER

    fun createWorker(req: WorkerRequest): Worker {
        val centralId = getCentralIdFromToken()
        val central = centralRepository.findByIdOrNull(centralId) ?: throw IllegalStateException("Central não encontrada")

        if (workerRepository.findByEmail(req.email) != null) throw IllegalStateException("Email do funcionário já cadastrado!")
        if (workerRepository .findByCpf(req.cpf) != null) throw IllegalStateException("CPF do funcionário já cadastrado!")

        val worker = Worker(
            email = req.email,
            name = req.name,
            cpf = req.cpf,
            entryDate = currentTime(),
            central = central,
            cellphone = req.cellphone,
            password = PasswordUtil.hashPassword(req.password),
        )

        return workerRepository.save(worker)
    }

    fun getWorker(workerId: Long): Worker? {
        val centralId = getCentralIdFromToken()
        val central = centralRepository.findByIdOrNull(centralId) ?: throw IllegalStateException("Central não encontrada")
        val worker = workerRepository.findByIdOrNull(workerId) ?: throw IllegalStateException("Funcionário não encontrado")
        if (worker.central != central) throw IllegalStateException("Funcionário não encontrado")
        return worker
    }

    fun listWorkers(): List<Worker> {
        val centralId = getCentralIdFromToken()
        val central = getCentralById(centralId) ?: throw IllegalStateException("Central não encontrada")
        return workerRepository.findAllByCentral(central)
    }

    fun deleteWorker(workerId: Long): Boolean {
        val worker = getWorker(workerId) ?: return false

        log.warn("Worker deleted. id={} name={}", worker.id, worker.name)
        workerRepository.delete(worker)
        return true
    }

    fun updateWorker(id: Long, workerUpdated: WorkerUpdateRequest): Worker {
        val worker = getWorker(id) ?: throw IllegalStateException("Funcionário não encontrado")

        val existingWorkerWithSameCpf = workerRepository.findByCpf(workerUpdated.cpf!!)
        if (existingWorkerWithSameCpf != null && existingWorkerWithSameCpf.id != id) {
            throw IllegalStateException("Já existe outro funcionário cadastrado com este CPF.")
        }

        if (workerUpdated.newPassword == null) {
            worker.email = workerUpdated.email!!
            worker.name = workerUpdated.name!!
            worker.cpf = workerUpdated.cpf!!
            worker.cellphone = workerUpdated.cellphone!!
            return workerRepository.save(worker)
        } else if (PasswordUtil.verifyPassword(workerUpdated.oldPassword!!, worker.password)) {
            worker.email = workerUpdated.email!!
            worker.name = workerUpdated.name!!
            worker.cpf = workerUpdated.cpf!!
            worker.cellphone = workerUpdated.cellphone!!
            worker.password = PasswordUtil.hashPassword(workerUpdated.newPassword)
            return workerRepository.save(worker)
        } else {
            throw IllegalStateException("As senhas não conferem!")
        }
    }

    // Assistance

    fun createAssistance(req: AssistanceRequest): Assistance {
        val centralId = getCentralIdFromToken()
        val central = centralRepository.findByIdOrNull(centralId) ?: throw IllegalStateException("Central não encontrada")
        val client = clientRepository.findByCpf(req.cpf) ?: throw IllegalStateException("Cliente não encontrado")

        val workers = mutableListOf<Worker>()
        val categories = mutableListOf<Category>()

        for (workerId in req.workersIds) {
            val worker = workerRepository.findByIdOrNull(workerId) ?: throw IllegalStateException("Funcionário não encontrado")
            if (worker.central != central) throw IllegalStateException("Funcionário não encontrado")
            workers.add(worker)
        }

        for (categoryId in req.categoriesId) {
            val category = categoryRepository.findByIdOrNull(categoryId) ?: throw IllegalStateException("Categoria não encontrada")
            if (category.central != central) throw IllegalStateException("Categoria não encontrado")
            categories.add(category)
        }

        val assistance = Assistance(
            startDate = currentTime(),
            description = req.description,
            name = req.name,
            address = req.address,
            complement = req.complement,
            cpf = req.cpf,
            period = req.period,
            responsibleCentral = central,
            client = client,
            responsibleWorkers = workers.toMutableSet(),
            categories = categories.toMutableSet(),
            assistanceStatus = if (workers.isNotEmpty()) AssistanceStatus.EM_ANDAMENTO else AssistanceStatus.AGUARDANDO
        )
        central.assistanceQueue.add(assistance)
        return assistanceRepository.save(assistance)
    }

    fun listAllAssistancesAddressByCentralId(): List<String> {
        val centralId = getCentralIdFromToken()
        val central = centralRepository.findByIdOrNull(centralId) ?: throw IllegalStateException("Central não encontrada")
        return assistanceRepository.findAllByResponsibleCentral(central).map { it.address }
    }

    fun listAllAssistancesByCentralId(): List<Assistance> {
        val centralId = getCentralIdFromToken()
        val central = centralRepository.findByIdOrNull(centralId) ?: throw IllegalStateException("Central não encontrada")
        return assistanceRepository.findAllByResponsibleCentral(central)
    }

    fun listAssistancesByStatus (status: String) : List<Assistance> {
        val centralId = getCentralIdFromToken()
        val central = centralRepository.findByIdOrNull(centralId) ?: throw IllegalStateException("Central não encontrada")
        val assistanceStatus = try {
            AssistanceStatus.valueOf(status.uppercase())
        } catch (e: IllegalArgumentException) {
            throw IllegalStateException("Status inválido")
        }
        return assistanceRepository.findAssistanceByAssistanceStatusAndClient_Central(assistanceStatus, central)
    }

    fun getAssistance(assistanceId: Long): Assistance? {
        val centralId = getCentralIdFromToken()
        val central = centralRepository.findByIdOrNull(centralId) ?: throw IllegalStateException("Central não encontrada")
        val assistance = assistanceRepository.findByIdOrNull(assistanceId) ?: throw IllegalStateException("Assistência não encontrada")
        if (assistance.responsibleCentral != central) throw IllegalStateException("Assistência não encontrada")
        return assistance
    }

    fun updateAssistance(assistanceId: Long, assistance: AssistanceRequest): Assistance {
        val assistanceToUpdate = getAssistance(assistanceId) ?: throw IllegalStateException("Assistência não encontrada")
        assistanceToUpdate.name = assistance.name
        assistanceToUpdate.description = assistance.description
        assistanceToUpdate.address = assistance.address
        assistanceToUpdate.cpf = assistance.cpf
        assistanceToUpdate.period = assistance.period
        assistanceToUpdate.complement = assistance.complement
        assistanceToUpdate.responsibleWorkers  = assistance.workersIds.map { workerRepository.findByIdOrNull(it) ?: throw IllegalStateException("Funcionário não encontrado") }.toMutableSet()
        assistanceToUpdate.categories = assistance.categoriesId.map { categoryRepository.findByIdOrNull(it) ?: throw IllegalStateException("Categoria não encontrada") }.toMutableSet()
        return assistanceRepository.save(assistanceToUpdate)
    }

    fun deleteAssistance(assistanceId: Long): Boolean {
        val assistance = getAssistance(assistanceId) ?: return false
        val centralId = getCentralIdFromToken()
        val central = centralRepository.findByIdOrNull(centralId) ?: throw IllegalStateException("Central não encontrada")
        log.warn("Assistance deleted. id={} name={}", assistance.id, assistance.name)
        central.assistanceQueue.remove(assistance)
        assistanceRepository.delete(assistance)
        return true
    }

    // Suppliers

    fun createSupplier(req: SupplierBusinessRequest): SupplierBusiness {
        val centralId = getCentralIdFromToken()
        val central = centralRepository.findByIdOrNull(centralId) ?: throw IllegalStateException("Central não encontrada")

        val supplier = SupplierBusiness(
            name = req.name,
            cnpj = req.cnpj,
            creation_date = currentTime(),
            responsibleCentral = central,
        )
        return supplierRepository.save(supplier)
    }

    fun listSuppliers(): List<SupplierBusiness> {
        val centralId = getCentralIdFromToken()
        val central = centralRepository.findByIdOrNull(centralId) ?: throw IllegalStateException("Central não encontrada")
        return supplierRepository.findAllByResponsibleCentral(central)
    }

    fun getSupplier(supplierId: Long): SupplierBusiness? {
        val centralId = getCentralIdFromToken()
        val central = centralRepository.findByIdOrNull(centralId) ?: throw IllegalStateException("Central não encontrada")
        val supplier = supplierRepository.findByIdOrNull(supplierId) ?: throw IllegalStateException("Fornecedor não encontrado")
        if (supplier.responsibleCentral != central) throw IllegalStateException("Fornecedor não encontrado")
        return supplier
    }



    fun updateSupplier(supplierId: Long, supplier: SupplierBusinessRequest): SupplierBusiness {
        val supplierToUpdate = getSupplier(supplierId) ?: throw IllegalStateException("Fornecedor não encontrado")
        supplierToUpdate.name = supplier.name
        supplierToUpdate.cnpj = supplier.cnpj
        return supplierRepository.save(supplierToUpdate)
    }

    fun deleteSupplier(supplierId: Long): Boolean {
        val supplier = supplierRepository.findByIdOrNull(supplierId) ?: return false
        supplierRepository.delete(supplier)
        return true
    }

    fun getSupplierByCnpj(cnpj: String): SupplierBusiness? {
        val centralId = getCentralIdFromToken()
        val central = centralRepository.findByIdOrNull(centralId) ?: throw IllegalStateException("Central não encontrada")
        val supplier =  supplierRepository.findByCnpj(cnpj) ?: throw IllegalStateException("Fornecedor não encontrado")
        return supplier.takeIf { it.responsibleCentral == central } ?: throw IllegalStateException("Fornecedor não encontrado")
    }
    // Products

    fun getProduct(productId: Long): Product? {
        val centralId = getCentralIdFromToken()
        centralRepository.findByIdOrNull(centralId) ?: throw IllegalStateException("Central não encontrada")
        return productRepository.findByIdOrNull(productId)
    }

    fun createProduct(req: ProductRequest): Product {
        val centralId = getCentralIdFromToken()
        centralRepository.findByIdOrNull(centralId) ?: throw IllegalStateException("Central não encontrada")
        val supplier = supplierRepository.findByCnpj(req.supplierCnpj) ?: throw IllegalStateException("Fornecedor não encontrado")
        val product = Product(
            name = req.name,
            price = req.price,
            supplier = supplier,
            creation_date = currentTime(),
        )
        return productRepository.save(product)
    }

    fun updateProduct(productId: Long, product: UpdateProductRequest): Product {
        val productToUpdate = productRepository.findByIdOrNull(productId) ?: throw IllegalStateException("Produto não encontrado")
        val oldPrice = productToUpdate.price
        productToUpdate.producthistory.add(
            OldPrices(
                update_date = currentTime(),
                old_price = oldPrice,
                product = productToUpdate
            )
        )

        productToUpdate.name = product.name
        productToUpdate.price = product.price
        return productRepository.save(productToUpdate)
    }

    fun deleteProduct(productId: Long): Boolean {
        val product = productRepository.findByIdOrNull(productId) ?: return false
        productRepository.delete(product)
        return true
    }

    fun listProductsBySupplier(supplierId: Long): List<Product> {
        val centralId = getCentralIdFromToken()
        centralRepository.findByIdOrNull(centralId) ?: throw IllegalStateException("Central não encontrada")
        val supplier = supplierRepository.findByIdOrNull(supplierId) ?: throw IllegalStateException("Fornecedor não encontrado")
        return productRepository.findAllBySupplier(supplier)
    }

    fun listProducts(): List<Product> {
        val centralId = getCentralIdFromToken()
        centralRepository.findByIdOrNull(centralId) ?: throw IllegalStateException("Central não encontrada")
        return productRepository.findAll()
    }

    fun listProductHistory(productId: Long): List<OldPrices> {
        val product = productRepository.findByIdOrNull(productId) ?: throw IllegalStateException("Produto não encontrado")
        return product.producthistory.toList()
    }

    // Category

    fun createCategory(req: CategoryRequest): Category {
        val centralId = getCentralIdFromToken()
        val central = centralRepository.findByIdOrNull(centralId) ?: throw IllegalStateException("Central não encontrada")
        val category = Category(
            name = req.name,
            creationDate = currentTime(),
            central = central
        )
        return categoryRepository.save(category)
    }

    fun listCategories(): List<Category> {
        val centralId = getCentralIdFromToken()
        val central = centralRepository.findByIdOrNull(centralId) ?: throw IllegalStateException("Central não encontrada")
        return categoryRepository.findAllByCentral(central)
    }

    fun getCategory(categoryId: Long): Category? {
        val centralId = getCentralIdFromToken()
        centralRepository.findByIdOrNull(centralId) ?: throw IllegalStateException("Central não encontrada")
        return categoryRepository.findByIdOrNull(categoryId)
    }

    fun updateCategory(categoryId: Long, req: CategoryRequest): Category {
        val category = categoryRepository.findByIdOrNull(categoryId) ?: throw IllegalStateException("Categoria não encontrada")
        category.name = req.name
        return categoryRepository.save(category)
    }

    fun deleteCategory(categoryId: Long): Boolean {
        val category = categoryRepository.findByIdOrNull(categoryId) ?: return false
        categoryRepository.delete(category)
        return true
    }

    // ClientBusiness

    fun createClientBusiness(req: ClientBusinessRequest): ClientBusiness {
        val centralId = getCentralIdFromToken()
        val central = centralRepository.findByIdOrNull(centralId) ?: throw IllegalStateException("Central não encontrada")
        val clientBusiness = ClientBusiness(
            name = req.name,
            cnpj = req.cnpj,
            cellphone = req.cellphone,
            creationDate = currentTime(),
            responsibleCentral = central
        )
        return clientBusinessRepository.save(clientBusiness)
    }

    fun listClientBusiness(): List<ClientBusiness> {
        val centralId = getCentralIdFromToken()
        val central = centralRepository.findByIdOrNull(centralId) ?: throw IllegalStateException("Central não encontrada")
        return clientBusinessRepository.findAllByResponsibleCentral(central)
    }

    fun getClientBusiness(clientBusinessId: Long): ClientBusiness? {
        val centralId = getCentralIdFromToken()
        val central = centralRepository.findByIdOrNull(centralId) ?: throw IllegalStateException("Central não encontrada")
        val clientBusiness = clientBusinessRepository.findByIdOrNull(clientBusinessId) ?: throw IllegalStateException("Cliente não encontrado")
        if (clientBusiness.responsibleCentral != central) throw IllegalStateException("Cliente não encontrado")
        return clientBusiness
    }

    fun updateClientBusiness(clientBusinessId: Long, clientBusiness: ClientBusinessRequest): ClientBusiness {
        val clientBusinessToUpdate = clientBusinessRepository.findByIdOrNull(clientBusinessId) ?: throw IllegalStateException("Cliente não encontrado")
        clientBusinessToUpdate.name = clientBusiness.name
        clientBusinessToUpdate.cnpj = clientBusiness.cnpj
        clientBusinessToUpdate.cellphone = clientBusiness.cellphone
        return clientBusinessRepository.save(clientBusinessToUpdate)
    }

    fun deleteClientBusiness(clientBusinessId: Long): Boolean {
        val clientBusiness = clientBusinessRepository.findByIdOrNull(clientBusinessId) ?: return false
        clientBusinessRepository.delete(clientBusiness)
        return true
    }

    // Sale

    fun createSale(saleRequest: SaleRequest): Sale {
        val centralId = getCentralIdFromToken()
        centralRepository.findByIdOrNull(centralId) ?: throw IllegalStateException("Central não encontrada")
        val client = clientBusinessRepository.findByIdOrNull(saleRequest.clientId) ?: throw IllegalStateException("Cliente não encontrado")
        val supplier = supplierRepository.findByIdOrNull(saleRequest.supplierId) ?: throw IllegalStateException("Fornecedor não encontrado")

        val sale = Sale(
            saleDate = currentTime(),
            purchaseOrder = saleRequest.purchaseOrder,
            carrier = saleRequest.carrier,
            fare = saleRequest.fare,
            client = client,
            supplier = supplier,
            billingDate = saleRequest.billingDate
        )

        var totalPrice = 0.0f

        var productsQtts = mutableSetOf<ProductQtt>()

        for (productSale in saleRequest.productsQtt) {
            val product = productRepository.findByIdOrNull(productSale.idProduct) ?: throw IllegalStateException("Produto não encontrado")
            if (product.supplier != supplier) throw IllegalStateException("Produto não encontrado")

            val productQtt = ProductQtt (
                product = product,
                qtt = productSale.qtt,
                priceOnSale = product.price,
                sale = sale
            )

            totalPrice += product.price * productSale.qtt

            productsQtts.add(productQtt)
        }

        sale.totalPrice = totalPrice

        saleRepository.save(sale)

        productsQtts.map { productQttRepository.save(it) }

        return sale
    }

    fun listSalesByClient(clientId: Long): List<Sale> {
        val centralId = getCentralIdFromToken()
        val central = centralRepository.findByIdOrNull(centralId) ?: throw IllegalStateException("Central não encontrada")
        central.clientBussines.find { it.id == clientId } ?: throw IllegalStateException("Cliente não encontrado")
        return saleRepository.findAllByClient_Id(clientId)
    }

    fun listSalesBySupplier(supplierId: Long): List<Sale> {
        val centralId = getCentralIdFromToken()
        val central = centralRepository.findByIdOrNull(centralId) ?: throw IllegalStateException("Central não encontrada")
        central.supplierBusiness.find { it.id == supplierId } ?: throw IllegalStateException("Fornecedor não encontrado")
        return saleRepository.findAllBySupplier_Id(supplierId)
    }

    fun listSales(): List<Sale> {
        val centralId = getCentralIdFromToken()
        val central = centralRepository.findByIdOrNull(centralId) ?: throw IllegalStateException("Central não encontrada")

        return central.clientBussines.flatMap { client -> saleRepository.findAllByClient_Id(client.id!!) } +
               central.supplierBusiness.flatMap { supplier -> saleRepository.findAllBySupplier_Id(supplier.id!!) }
    }

    fun getSale(saleId: Long): Sale? {
        val centralId = getCentralIdFromToken()
        val central = centralRepository.findByIdOrNull(centralId) ?: throw IllegalStateException("Central não encontrada")
        val sale = saleRepository.findByIdOrNull(saleId)
        return sale?.takeIf { it.client?.responsibleCentral == central || it.supplier?.responsibleCentral == central }
    }

    fun updateSale(saleId: Long, saleRequest: SaleRequest): Sale {
        val sale = saleRepository.findByIdOrNull(saleId) ?: throw IllegalStateException("Venda não encontrada")
        val client = clientBusinessRepository.findByIdOrNull(saleRequest.clientId) ?: throw IllegalStateException("Cliente não encontrado")
        val supplier = supplierRepository.findByIdOrNull(saleRequest.supplierId) ?: throw IllegalStateException("Fornecedor não encontrado")

        sale.purchaseOrder = saleRequest.purchaseOrder
        sale.carrier = saleRequest.carrier
        sale.fare = saleRequest.fare
        sale.client = client
        sale.supplier = supplier

        var totalPrice = 0.0f

        saleRepository.save(sale)

        for (productSale in saleRequest.productsQtt) {
            val product = productRepository.findByIdOrNull(productSale.idProduct) ?: throw IllegalStateException("Produto não encontrado")
            if (product.supplier != supplier) throw IllegalStateException("Produto não encontrado")

            val productQtt = ProductQtt (
                product = product,
                qtt = productSale.qtt,
                priceOnSale = product.price,
                sale = sale
            )

            totalPrice += product.price * productSale.qtt

            productQttRepository.save(productQtt)
        }

        sale.totalPrice = totalPrice

        return saleRepository.save(sale)
    }

    fun deleteSale(saleId: Long): Boolean {
        val sale = saleRepository.findByIdOrNull(saleId) ?: return false
        saleRepository.delete(sale)
        return true
    }

    // Budget

    fun createBudget(budgetReq: BudgetRequest) : Budget {
        val centralId = getCentralIdFromToken()
        val central = centralRepository.findByIdOrNull(centralId) ?: throw IllegalStateException("Central não encontrada")
        val assistance = assistanceRepository.findByIdOrNull(budgetReq.assistanceId) ?: throw IllegalStateException("Assistência não encontrada")
        val workers = mutableListOf<Worker>()
        for (workerId in budgetReq.responsibleWorkersIds) {
            val worker = workerRepository.findByIdOrNull(workerId) ?: throw IllegalStateException("Funcionário não encontrado")
            if (worker.central != central) throw IllegalStateException("Funcionário não encontrado")
            workers.add(worker)
        }
        val client = clientRepository.findByIdOrNull(budgetReq.clientId) ?: throw IllegalStateException("Cliente não encontrado")
        val budget = Budget(
            name = budgetReq.name,
            description = budgetReq.description,
            creationDate = currentTime(),
            assistance = assistance,
            responsibleWorkers = workers.toMutableSet(),
            client = client,
            totalPrice = budgetReq.totalPrice,
            responsibleCentral = central
        )
        budget.assistance = assistance
        assistance.budget = budget
        return budgetRepository.save(budget)

    }


    fun listBudgetsByStatus (status: String) : List<Budget> {
        val centralId = getCentralIdFromToken()
        val central = centralRepository.findByIdOrNull(centralId) ?: throw IllegalStateException("Central não encontrada")
        val budgetStatus = try {
            BudgetStatus.valueOf(status.uppercase())
        } catch (e: IllegalArgumentException) {
            throw IllegalStateException("Status inválido")
        }
        return budgetRepository.findAllByStatusAndClient_Central(budgetStatus, central)
    }

    fun listBudgets () : List<Budget> {
        val centralId = getCentralIdFromToken()
        val central = centralRepository.findByIdOrNull(centralId) ?: throw IllegalStateException("Central não encontrada")
        return budgetRepository.findAllByResponsibleCentral(central)
    }

    fun getBudget(budgetId: Long) : Budget {
        val budget = budgetRepository.findByIdOrNull(budgetId) ?: throw IllegalStateException("Orçamento não encontrado")
        val centralId = getCentralIdFromToken()
        val central = centralRepository.findByIdOrNull(centralId) ?: throw IllegalStateException("Central não encontrada")
        if (budget.client.central != central) throw IllegalStateException("Orçamento não encontrado")
        central.notifications.find { it.budget.id == budgetId }?.let { it.readed = true }
        centralRepository.save(central)
        return budget
    }

    fun updateBudget(budgetId: Long, budgetReq: BudgetRequest) : Budget {
        val budget = budgetRepository.findByIdOrNull(budgetId) ?: throw IllegalStateException("Orçamento não encontrado")
        val centralId = getCentralIdFromToken()
        val central = centralRepository.findByIdOrNull(centralId) ?: throw IllegalStateException("Central não encontrada")
        if (budget.client.central != central) throw IllegalStateException("Orçamento não encontrado")
        val workers = mutableListOf<Worker>()
        for (workerId in budgetReq.responsibleWorkersIds) {
            val worker = workerRepository.findByIdOrNull(workerId) ?: throw IllegalStateException("Funcionário não encontrado")
            if (worker.central != central) throw IllegalStateException("Funcionário não encontrado")
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

    fun validateBudget(budgetId: Long, budgetReq: BudgetRequest) : Budget {
        val budget = updateBudget(budgetId, budgetReq)
        val central = centralRepository.findByIdOrNull(getCentralIdFromToken())
            ?: throw IllegalStateException("Central não encontrada")
//        var status = ""
//        if (budget.status == BudgetStatus.APROVADO) status = "aprovado"
//        if (budget.status == BudgetStatus.REPROVADO) status = "reprovado"
//        if (budget.status == BudgetStatus.EM_ANALISE) status = "em análise"
        val notification = Notification(
            title = "Orçamento ${budget.name}",
            message = "Seu orçamento foi  ${budget.status}",
            central = central,
            creationDate = currentTime(),
            budget = budget
        )

        notificationRepository.save(notification)
        return budget
    }

    fun deleteBudget(budgetId: Long): Boolean {
        val central = centralRepository.findByIdOrNull(getCentralIdFromToken())
            ?: throw IllegalStateException("Central não encontrada")
        val budget = budgetRepository.findByIdOrNull(budgetId) ?: return false

        if (budget.assistance?.responsibleCentral?.id != central.id)
            throw IllegalStateException("Orçamento não encontrado")

        val assistance = budget.assistance
        if (assistance != null) {
            // Remove the budget reference from Assistance
            assistance.budget = null
            assistanceRepository.save(assistance)
        }

        // Now delete the Budget
        budgetRepository.delete(budget)
        return true
    }

    fun createReport(reportReq: ReportRequest) : Report {
        val centralId = getCentralIdFromToken()
        val central = centralRepository.findByIdOrNull(centralId) ?: throw IllegalStateException("Central não encontrada")

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

        assistance.assistanceStatus = AssistanceStatus.FINALIZADO
        assistanceRepository.save(assistance)

        return assistance.report!!
    }

    fun getReport(reportId: Long) : Report {
        val report = reportRepository.findByIdOrNull(reportId) ?: throw IllegalStateException("Relatório não encontrado")
        val centralId = getCentralIdFromToken()
        val central = centralRepository.findByIdOrNull(centralId) ?: throw IllegalStateException("Central não encontrada")
        if (report.responsibleCentral != central) throw IllegalStateException("Relatório não encontrado")
        return report
    }

    fun listReports() : List<Report> {
        val centralId = getCentralIdFromToken()
        val central = centralRepository.findByIdOrNull(centralId) ?: throw IllegalStateException("Central não encontrada")
        return reportRepository.findAllByResponsibleCentral(central)
    }


    fun updateReport(reportId: Long, reportReq: ReportRequest) : Report {
        val report = reportRepository.findByIdOrNull(reportId) ?: throw IllegalStateException("Relatório não encontrado")
        val centralId = getCentralIdFromToken()
        val central = centralRepository.findByIdOrNull(centralId) ?: throw IllegalStateException("Central não encontrada")
        if (report.responsibleCentral != central) throw IllegalStateException("Relatório não encontrado")
        val workers = mutableListOf<Worker>()
        for (workerId in reportReq.responsibleWorkersIds) {
            val worker = workerRepository.findByIdOrNull(workerId) ?: throw IllegalStateException("Funcionário não encontrado")
            if (worker.central != central) throw IllegalStateException("Funcionário não encontrado")
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

    fun deleteReport(reportId: Long) : Boolean {
        val central = centralRepository.findByIdOrNull(getCentralIdFromToken()) ?: throw IllegalStateException("Central não encontrada")
        val report = reportRepository.findByIdOrNull(reportId) ?: return false
        if (report.responsibleCentral != central) throw IllegalStateException("Relatório não encontrado")
        reportRepository.delete(report)
        return true
    }

    // Notifications

    fun listNotifications() : MutableSet<Notification> {
        val centralId = getCentralIdFromToken()
        val central = centralRepository.findByIdOrNull(centralId) ?: throw IllegalStateException("Central não encontrada")
        return central.notifications
    }

    fun listUnreadNotifications() : MutableSet<Notification> {
        val centralId = getCentralIdFromToken()
        val central = centralRepository.findByIdOrNull(centralId) ?: throw IllegalStateException("Central não encontrada")
        val notifications = central.notifications.filter { !it.readed }.toMutableSet()
        return notifications
    }

    fun getNotification(notificationId: Long) : Notification {
        val centralId = getCentralIdFromToken()
        val central = centralRepository.findByIdOrNull(centralId) ?: throw IllegalStateException("Central não encontrada")
        val notification = central.notifications.find { it.id == notificationId } ?: throw IllegalStateException("Notificação não encontrada")
        notification.readed = true
        return notificationRepository.save(notification)
    }

    fun deleteNotification(notificationId: Long) : Boolean {
        val central = centralRepository.findByIdOrNull(getCentralIdFromToken()) ?: throw IllegalStateException("Central não encontrada")
        val notification = central.notifications.find { it.id == notificationId } ?: return false
        central.notifications.remove(notification)
        centralRepository.save(central)
        return true
    }

    fun deleteAllNotifications() : Boolean {
        val central = centralRepository.findByIdOrNull(getCentralIdFromToken()) ?: throw IllegalStateException("Central não encontrada")
        central.notifications.clear()
        centralRepository.save(central)
        return true
    }

    // Utils

    fun currentTime(): Date {
        val currentDateTime = LocalDateTime.now()
        return Date.from(currentDateTime.atZone(ZoneId.systemDefault()).toInstant())
    }

    companion object {
        val log = LoggerFactory.getLogger(CentralService::class.java)
    }
}
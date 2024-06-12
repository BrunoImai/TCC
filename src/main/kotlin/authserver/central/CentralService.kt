package authserver.central

import authserver.assistance.Assistance
import authserver.assistance.AssistanceRepository
import authserver.assistance.request.AssistanceRequest
import authserver.central.requests.CentralPasswordChange
import authserver.central.requests.CentralRequest
import authserver.central.requests.CentralUpdateRequest
import authserver.security.Jwt
import authserver.security.UserToken

import br.pucpr.authserver.users.requests.LoginRequest
import authserver.central.responses.CentralLoginResponse
import jakarta.servlet.http.HttpServletRequest
import authserver.central.role.RolesRepository
import authserver.client.Client
import authserver.client.ClientRepository
import authserver.client.requests.ClientRequest
import authserver.exception.InvalidCredentialException
import authserver.utils.PasswordUtil
import authserver.worker.Worker
import authserver.worker.WorkerRepository
import authserver.worker.requests.WorkerRequest
import authserver.worker.requests.WorkerUpdateRequest
import com.amazonaws.regions.Regions
import com.amazonaws.services.simpleemail.AmazonSimpleEmailServiceClientBuilder
import com.amazonaws.services.simpleemail.model.*
import org.slf4j.LoggerFactory
import org.springframework.data.domain.Sort
import org.springframework.data.repository.findByIdOrNull
import org.springframework.stereotype.Service
import java.time.LocalDate
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

) {

    fun getCentralIdFromToken(): Long {
        val authentication = jwt.extract(request)

        return authentication?.let {
            val central = it.principal as UserToken
            central.id
        } ?: throw IllegalStateException("Central não está autenticada!")
    }


    fun createCentral(req: CentralRequest): CentralLoginResponse {
        val currentDate = LocalDate.now()

        if (centralRepository.findByEmail(req.email!!) != null) throw IllegalStateException("Email já cadastrado!")
        if (centralRepository.findByCnpj(req.cnpj!!) != null) throw IllegalStateException("CNPJ já cadastrado!")

        // Convert LocalDate to Date
        val date = Date.from(currentDate.atStartOfDay(ZoneId.systemDefault()).toInstant())
        log.info("entrou")
        val central = Central(
            email = req.email,
            password = PasswordUtil.hashPassword(req.password!!),
            name = req.name!!,
            creationDate = date,
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
        val currentDate = LocalDate.now()

        val centralId = getCentralIdFromToken()
        val central = centralRepository.findByIdOrNull(centralId) ?: throw IllegalStateException("Central não encontrada")

        if (clientRepository.findByEmail(req.email) != null) throw IllegalStateException("Email do cliente já cadastrado!")
        if (clientRepository.findByCpf(req.cpf) != null) throw IllegalStateException("CPF do cliente já cadastrado!")

        val date = Date.from(currentDate.atStartOfDay(ZoneId.systemDefault()).toInstant())

        val client = Client(
            email = req.email,
            name = req.name,
            cpf = req.cpf,
            cellphone = req.cellphone,
            entryDate = date,
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

        val currentDate = LocalDate.now()
        val date = Date.from(currentDate.atStartOfDay(ZoneId.systemDefault()).toInstant())

        val worker = Worker(
            email = req.email,
            name = req.name,
            cpf = req.cpf,
            entryDate = date,
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

        for (workerId in req.workersIds) {
            val worker = workerRepository.findByIdOrNull(workerId) ?: throw IllegalStateException("Funcionário não encontrado")
            if (worker.central != central) throw IllegalStateException("Funcionário não encontrado")
            workers.add(worker)
        }

        val currentDate = LocalDate.now()
        val date = Date.from(currentDate.atStartOfDay(ZoneId.systemDefault()).toInstant())

        val assistance = Assistance(
            startDate = date,
            description = req.description,
            name = req.name,
            address = req.address,
            cpf = req.cpf,
            period = req.period,
            responsibleCentral = central,
            client = client,
            responsibleWorkers = workers.toMutableSet()
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



    companion object {
        val log = LoggerFactory.getLogger(CentralService::class.java)
    }
}
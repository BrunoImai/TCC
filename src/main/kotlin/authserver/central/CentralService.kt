package authserver.central

import authserver.central.responses.CentralLoginResponse
import authserver.central.role.RolesRepository
import authserver.client.Client
import authserver.client.ClientRepository
import authserver.client.requests.ClientRequest
import authserver.security.CentralToken
import authserver.security.Jwt
import br.pucpr.authserver.users.requests.CentralRequest
import br.pucpr.authserver.users.requests.LoginRequest
import jakarta.servlet.http.HttpServletRequest
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
    val jwt: Jwt,
    val request: HttpServletRequest, private val clientRepository: ClientRepository,
) {

    fun getCentralIdFromToken(): Long {
        val authentication = jwt.extract(request)

        return authentication?.let {
            val central = it.principal as CentralToken
            central.id
        } ?: throw IllegalStateException("Central is not authenticated")
    }


    fun createCentral(req: CentralRequest): Central {
        val currentDate = LocalDate.now()

        // Convert LocalDate to Date
        val date = Date.from(currentDate.atStartOfDay(ZoneId.systemDefault()).toInstant())

        val central = Central(
            email = req.email!!,
            password = req.password!!,
            name = req.name!!,
            creationDate = date
        )
        val userRole = rolesRepository.findByName("CENTRAL")
            ?: throw IllegalStateException("Role 'CENTRAL' not found!")

        central.roles.add(userRole)
        return centralRepository.save(central)
    }

    fun getCentralById(id: Long) = centralRepository.findByIdOrNull(id)

    fun findAllCentrals(role: String?): List<Central> =
        if (role == null) centralRepository.findAll(Sort.by("name"))
        else centralRepository.findAllByRole(role)

    fun centralLogin(credentials: LoginRequest): CentralLoginResponse? {
        val central = centralRepository.findByEmail(credentials.email!!) ?: return null
        if (central.password != credentials.password) return null
        log.info("Central logged in. id={} name={}", central.id, central.name)
        return CentralLoginResponse(
            token = jwt.createToken(central),
            central.toResponse()
        )
    }

    fun centralSelfDelete(id: Long): Boolean {
        val central = centralRepository.findByIdOrNull(id) ?: return false
        if (central.id != getCentralIdFromToken()) throw IllegalStateException("Not accepted! Only the own central can delete itself!")
        log.warn("Central deleted. id={} name={}", central.id, central.name)
        centralRepository.delete(central)
        return true
    }

    //CLIENT

    fun getClient(clientId: Long): Client? {
        val centralId = getCentralIdFromToken()
        val central = centralRepository.findByIdOrNull(centralId) ?: throw IllegalStateException("Not accepted! Central not found!")
        val client = clientRepository.findByIdOrNull(clientId) ?: throw IllegalStateException("Client not found!")
        if (client.central != central) throw IllegalStateException("Client not exist on Central: centralName = {}" + central.name)
        return client
    }

    fun createClient(req: ClientRequest): Client {
        val currentDate = LocalDate.now()

        val centralId = getCentralIdFromToken()
        val central = centralRepository.findByIdOrNull(centralId) ?: throw IllegalStateException("Not accepted! Central not found!")

        val date = Date.from(currentDate.atStartOfDay(ZoneId.systemDefault()).toInstant())

        val client = Client(
            email = req.email,
            name = req.name,
            entryDate = date,
            central = central,
            address = req.address
        )

        return clientRepository.save(client)
    }

    fun deleteClient(clientId: Long): Boolean {
        val client = getClient(clientId) ?: return false

        log.warn("Client deleted deleted. id={} name={}", client.id, client.name)
        clientRepository.delete(client)
        return true
    }

    fun updateClient(id: Long, clientUpdated: Client): Client {
        val client = getClient(id) ?: throw IllegalStateException("Client not found!")
        client.email = clientUpdated.email
        client.name = clientUpdated.name
        client.address = clientUpdated.address
        client.cellphone = clientUpdated.cellphone
        client.cpf = clientUpdated.cpf
        client.assistances = clientUpdated.assistances
        client.central = clientUpdated.central
        return clientRepository.save(client)
    }

    fun listClients(): List<Client> {
        val centralId = getCentralIdFromToken()
        val central = getCentralById(centralId) ?: throw IllegalStateException("Central not found!")
        return clientRepository.findAllByCentral(central)
    }

    companion object {
        val log = LoggerFactory.getLogger(CentralService::class.java)
    }
}
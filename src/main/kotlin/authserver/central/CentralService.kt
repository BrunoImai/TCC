package authserver.central

import authserver.security.Jwt
import authserver.security.CentralToken
import br.pucpr.authserver.users.requests.CentralRequest
import br.pucpr.authserver.users.requests.LoginRequest
import br.pucpr.authserver.users.responses.CentralLoginResponse
import jakarta.servlet.http.HttpServletRequest
import authserver.central.role.RolesRepository
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
    val request: HttpServletRequest,
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

    companion object {
        val log = LoggerFactory.getLogger(CentralService::class.java)
    }
}
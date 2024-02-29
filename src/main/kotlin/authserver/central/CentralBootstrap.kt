package authserver.central



import authserver.central.role.Role
import authserver.central.role.RolesRepository
import org.springframework.context.ApplicationListener
import org.springframework.context.event.ContextRefreshedEvent
import org.springframework.stereotype.Component
import java.time.LocalDate
import java.time.ZoneId
import java.util.*

@Component
class CentralBootstrap(
    val rolesRepository: RolesRepository,
    val userRepository: CentralRepository
) : ApplicationListener<ContextRefreshedEvent> {
    override fun onApplicationEvent(event: ContextRefreshedEvent) {
        val adminRole = Role(name = "ADMIN")
        if (rolesRepository.count() == 0L) {
            rolesRepository.save(adminRole)
            rolesRepository.save(Role(name = "CENTRAL"))
        }
        if (userRepository.count() == 0L) {
            val admin = Central(
                email = "admin@authserver.com",
                password = "admin",
                name = "Auth Server Administrator",
                creationDate = Date.from(LocalDate.now()
                                   .atStartOfDay(ZoneId.systemDefault()).toInstant())
            )
            admin.roles.add(adminRole)
            userRepository.save(admin)
        }
    }
}
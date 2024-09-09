package authserver.central.notification

import authserver.central.Central
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository

@Repository
interface NotificationRepository : JpaRepository<Notification, Long> {
    fun findAllByCentral(central: Central): List<Notification>
}
package authserver.central.notification

import authserver.central.Central
import authserver.central.notification.response.NotificationResponse
import authserver.delta.budget.Budget
import jakarta.persistence.*
import java.util.Date

@Entity
class Notification (
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    var id: Long? = null,

    @Column(nullable = false)
    var title: String,

    @Column(nullable = false)
    var message: String,

    @Column
    var creationDate: Date,

    @Column
    var readed: Boolean = false,

    @ManyToOne(fetch = FetchType.LAZY)
    var central: Central,

    @ManyToOne(fetch = FetchType.LAZY)
    var budget: Budget,

    ) {
    fun toResponse() = NotificationResponse(id!!, title, message, creationDate.toString(), readed, central.id!!, budget.toResponse())
}
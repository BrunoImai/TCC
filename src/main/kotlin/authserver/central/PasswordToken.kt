package authserver.central

import jakarta.persistence.Entity
import jakarta.persistence.GeneratedValue
import jakarta.persistence.Id
import jakarta.persistence.Table
import java.util.*

@Entity
@Table(name = "password_token")
class PasswordToken (
    @Id @GeneratedValue
    var id: Long? = null,
    var token: String,
    var exispirationDate: Date

)
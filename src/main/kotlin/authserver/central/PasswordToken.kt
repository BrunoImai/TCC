package authserver.central

import jakarta.persistence.*
import java.util.*

@Entity
class PasswordToken (
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    var id: Long? = null,
    var token: String,
    var exispirationDate: Date

)
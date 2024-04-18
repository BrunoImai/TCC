package authserver.utils

import de.mkammerer.argon2.Argon2Factory
import de.mkammerer.argon2.Argon2

object PasswordUtil {
    private val argon2: Argon2 = Argon2Factory.create()

    fun hashPassword(password: String): String {
        // Parameters: iterations, memory, parallelism
        return argon2.hash(2, 65536, 1, password.toCharArray())
    }

    fun verifyPassword(password: String, hash: String): Boolean {
        return argon2.verify(hash, password.toCharArray())
    }
}

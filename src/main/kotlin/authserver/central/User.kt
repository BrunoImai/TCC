package authserver.central

import authserver.central.role.Role

interface User {
    val id: Long?
    val name: String
    val roles: MutableSet<Role>
}
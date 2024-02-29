package authserver.security

data class CentralToken(
    val id: Long,
    val name: String,
    val roles: Set<String>
) {
    constructor() : this(0, "", setOf())
}

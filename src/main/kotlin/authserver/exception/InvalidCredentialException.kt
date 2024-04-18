package authserver.exception

import org.springframework.http.HttpStatus
import org.springframework.web.bind.annotation.ResponseStatus

@ResponseStatus(HttpStatus.CONFLICT)
class InvalidCredentialException (
    message: String = HttpStatus.CONFLICT.reasonPhrase,
    cause: Throwable? = null
): IllegalArgumentException(message, cause)
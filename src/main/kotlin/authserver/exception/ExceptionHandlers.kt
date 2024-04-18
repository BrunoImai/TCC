package authserver.exception

import org.springframework.http.ResponseEntity
import org.springframework.validation.FieldError
import org.springframework.web.bind.MethodArgumentNotValidException
import org.springframework.web.bind.annotation.ControllerAdvice
import org.springframework.web.bind.annotation.ExceptionHandler

@ControllerAdvice
class ExceptionHandlers {
    @ExceptionHandler(MethodArgumentNotValidException::class)
    fun handleValidationException(ex: MethodArgumentNotValidException) =
        ex.bindingResult.allErrors
            .joinToString("\n") { "'${(it as FieldError).field}': ${it.defaultMessage}"}
            .let { ResponseEntity.badRequest().body(it) }

    @ExceptionHandler(IllegalStateException::class)
    fun handleIllegalStateException(ex: IllegalStateException) =
        ResponseEntity.badRequest().body(ex.message)

    @ExceptionHandler(InvalidCredentialException::class)
    fun handleInvalidCredentialException(ex: InvalidCredentialException) =
        ResponseEntity.status(409).body(ex.message)

}
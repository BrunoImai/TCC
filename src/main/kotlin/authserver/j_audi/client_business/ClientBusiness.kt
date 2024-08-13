package authserver.j_audi.client_business

import authserver.central.Central
import authserver.j_audi.client_business.response.ClientBusinessResponse
import jakarta.persistence.*
import java.util.*

@Entity
class ClientBusiness(
    @Id
    @GeneratedValue
    var id: Long? = null,

    @Column(nullable = false)
    var name: String = "",

    @Column
    var cnpj: String = "",

    @Column
    var cellphone: String = "",


    @Column(nullable = false)
    var creationDate: Date,

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "Central_id")
    var responsibleCentral: Central? = null,

    ) {
    fun toResponse() = ClientBusinessResponse(id!!, name, cnpj, cellphone, creationDate, responsibleCentral!!.id!!)
}

package authserver.delta.maps

import com.fasterxml.jackson.annotation.JsonProperty

data class AddressRequest(
    val currentLocation: String,
    val addresses: List<String>
)


data class AddressResponse(val address: String)
data class MapResponse(val routes: List<Route>)
data class Route(val legs: List<Leg>)
data class Leg(
    val duration: Duration,
    @JsonProperty("end_address") val endAddress: String,  // Ensures correct mapping
    @JsonProperty("start_address") val startAddress: String? = null
)
data class Duration(val value: Int)
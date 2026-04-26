
import Foundation

// Renombramos los modelos para evitar conflictos con el código existente
struct BarberoAPI: Codable {
    var idBarbero: Int?
    var nombreBarbero: String
    var edadBarbero: Int?
    var emailBarbero: String?
    var usuarioBarbero: String?
}

struct ClienteAPI: Codable {
    var idCliente: Int?
    var nombreCliente: String
    var telefonoCliente: String?
    var emailCliente: String?
}

struct ServicioAPI: Codable {
    var idServicio: Int?
    var nombreServicio: String
    var precioServicio: Double?
    var duracionServicio: Int?
}

struct CitaAPI: Codable {
    var idCita: Int?
    var barbero: BarberoAPI
    var cliente: ClienteAPI
    var servicio: ServicioAPI
    var fecha: String
    var hora: String
    var estado: String?
}


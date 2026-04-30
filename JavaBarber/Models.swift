
import Foundation


struct BarberoAPI: Codable {
    var idBarbero: Int?
    var nombreBarbero: String
    var edadBarbero: Int?
    var emailBarbero: String?
    var usuarioBarbero: String?
    var contrasenaBarbero: String?
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
    var barbero: BarberoAPI?
    var cliente: ClienteAPI?
    var servicio: ServicioAPI?
    var fecha: String
    var hora: String
    var estado: String?
}

struct LoginResponseAPI: Codable {
    let token: String?
    let username: String?
    let rol: String?
    let idBarbero: Int?
    let idCliente: Int?
}

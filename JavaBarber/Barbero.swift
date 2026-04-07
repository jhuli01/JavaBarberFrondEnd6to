//
//  Usuario.swift
//  JavaBarber
//
//

import Foundation

class Barbero: Codable{
    var idBarbero: Int
    var nombreBarbero: String
    var edadBarbero: Int
    var emailBarbero: String
    var usuarioBarbero: String
    var contraseñaBarbero: String
    
    init(idBarbero: Int, nombreBarbero: String, edadBarbero: Int, emailBarbero: String, usuarioBarbero: String, contraseñaBarbero: String){
        self.idBarbero = idBarbero
        self.nombreBarbero = nombreBarbero
        self.edadBarbero = edadBarbero
        self.emailBarbero = emailBarbero
        self.usuarioBarbero = usuarioBarbero
        self.contraseñaBarbero = contraseñaBarbero
        
    }
    
}


class BarberoManager{
    static let shared = BarberoManager()
    var barberos: [Barbero]
    
    private init(){
        barberos = [
            Barbero(idBarbero: 1, nombreBarbero: "José Martinez", edadBarbero: 34, emailBarbero: "mjose@correo.com", usuarioBarbero: "jose", contraseñaBarbero: "jose123"),
            Barbero(idBarbero: 2, nombreBarbero: "Mario Martinez", edadBarbero: 34, emailBarbero: "mmaria@correo.com", usuarioBarbero: "mario", contraseñaBarbero: "mario123"),
            Barbero(idBarbero: 3, nombreBarbero: "Pedro Tello", edadBarbero: 20, emailBarbero: "tpedro@correo.com", usuarioBarbero: "pedro", contraseñaBarbero: "pedro123")
        ]
    }
    
}

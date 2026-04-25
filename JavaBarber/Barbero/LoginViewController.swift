//
//  LoginViewController.swift
//  JavaBarber
//
//  Created by wilder trujillo on 2026/04/23.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var txtClave: UITextField!
    @IBOutlet weak var txtUsuario: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnIngresar(_ sender: UIButton) {
        // 1. Validar que no estén vacíos
        guard let usuario = txtUsuario.text, !usuario.isEmpty,
              let clave = txtClave.text, !clave.isEmpty else {
            mostrarAlerta(mensaje: "Por favor, completa todos los campos.")
            return
        }

        let parametros: [String: Any] = [
                "username": usuario,
                "password": clave
            ]
            
            guard let url = URL(string: "https://motivated-courage-production-877a.up.railway.app/api/auth/login") else { return }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            // Convertir el diccionario a Data JSON
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parametros, options: [])
            } catch {
                print("Error al serializar JSON")
                return
            }

            // 2. Ejecutar la petición
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                
                // Regresamos al hilo principal para actualizar la UI
                DispatchQueue.main.async {
                    if let error = error {
                        self.mostrarAlerta(mensaje: "Error de conexión: \(error.localizedDescription)")
                        return
                    }
                    
                    guard let httpResponse = response as? HTTPURLResponse else { return }
                    
                    if httpResponse.statusCode == 200 {

                        self.ingresarAlApp()
                    } else if httpResponse.statusCode == 403 {
                        self.mostrarAlerta(mensaje: "Acceso denegado (403). Revisa tus credenciales o el backend.")
                    } else {
                        self.mostrarAlerta(mensaje: "Error en el servidor: \(httpResponse.statusCode)")
                    }
                }
            }
            task.resume()
        
    }

        func ingresarAlApp() {
            if let mainVC = storyboard?.instantiateViewController(withIdentifier: "NavIndentificador") {
                    mainVC.modalPresentationStyle = .fullScreen
                    self.present(mainVC, animated: true, completion: nil)
                }
        }

        func mostrarAlerta(mensaje: String) {
            let alerta = UIAlertController(title: "Atención", message: mensaje, preferredStyle: .alert)
            alerta.addAction(UIAlertAction(title: "OK", style: .default))
            present(alerta, animated: true)
        }

}

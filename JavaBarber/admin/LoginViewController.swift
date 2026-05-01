

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var txtClave: UITextField!
    @IBOutlet weak var txtUsuario: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
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
                
                DispatchQueue.main.async {
                    if let error = error {
                        self.mostrarAlerta(mensaje: "Error de conexión: \(error.localizedDescription)")
                        return
                    }
                    
                    guard let httpResponse = response as? HTTPURLResponse else { return }
                    
                    if httpResponse.statusCode == 200, let data = data {
                        do {
                            let loginResponse = try JSONDecoder().decode(LoginResponseAPI.self, from: data)
                            
                            // Guardar el token para usarlo en las peticiones
                            UserDefaults.standard.set(loginResponse.token, forKey: "userToken")
                            
                            if let idCliente = loginResponse.idCliente {
                                UserDefaults.standard.set(idCliente, forKey: "idCliente")
                            }
                            if let idBarbero = loginResponse.idBarbero {
                                UserDefaults.standard.set(idBarbero, forKey: "idBarbero")
                            }
                            
                            self.ingresarAlApp(rol: loginResponse.rol ?? "")
                        } catch {
                            print("Error al decodificar respuesta: \(error)")
                            self.ingresarAlApp(rol: "ADMIN") // Fallback
                        }
                    } else if httpResponse.statusCode == 401 || httpResponse.statusCode == 403 {
                        self.mostrarAlerta(mensaje: "Usuario o contraseña incorrectos.")
                    } else {
                        self.mostrarAlerta(mensaje: "Error en el servidor: \(httpResponse.statusCode)")
                    }
                }
            }
            task.resume()
        
        txtUsuario.text = ""
        txtClave.text = ""
    }

        func ingresarAlApp(rol: String) {
            var identifier = "NavIndentificador" // Default Admin
            
            switch rol.uppercased() {
            case "ADMIN":
                identifier = "NavIndentificador"
            case "BARBERO":
                identifier = "BarberoIndentificador"
            case "CLIENTE":
                identifier = "clienteNavIdentificador"
            default:
                identifier = "NavIndentificador"
            }
            
            if let mainVC = storyboard?.instantiateViewController(withIdentifier: identifier) {
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

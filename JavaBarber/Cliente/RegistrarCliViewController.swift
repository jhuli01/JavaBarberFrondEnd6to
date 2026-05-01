

import UIKit

class RegistrarCliViewController: UIViewController {

    @IBOutlet weak var txtTelefono: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtNombreCompleto: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    @IBAction func btnRegistrarCliente(_ sender: Any) {
        // 1. Validar campos
                guard let nombre = txtNombreCompleto.text, !nombre.isEmpty,
                      let email = txtEmail.text, !email.isEmpty,
                      let telefono = txtTelefono.text, !telefono.isEmpty else {
                    self.mostrarAlerta(titulo: "Error", mensaje: "Todos los campos son obligatorios")
                    return
                }
                
                let nuevoCliente: [String: Any] = [
                    "idCliente": NSNull(),
                    "nombreCliente": nombre,
                    "telefonoCliente": telefono,
                    "emailCliente": email
                ]
                
                enviarDatosAlApi(json: nuevoCliente)
    }
    func enviarDatosAlApi(json: [String: Any]) {
            guard let url = URL(string: "https://motivated-courage-production-877a.up.railway.app/api/clientes") else { return }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: json, options: [])
            } catch {
                print("Error al serializar el cliente")
                return
            }
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                DispatchQueue.main.async {
                    if let error = error {
                        self.mostrarAlerta(titulo: "Error", mensaje: error.localizedDescription)
                        return
                    }
                    
                    guard let httpResponse = response as? HTTPURLResponse else { return }
                    
                    if httpResponse.statusCode == 200 || httpResponse.statusCode == 201 {
                        self.mostrarAlerta(titulo: "Éxito", mensaje: "Cliente registrado correctamente") {
                            // Regresar a la pantalla anterior después de registrar
                            self.navigationController?.popViewController(animated: true)
                        }
                    } else {
                        self.mostrarAlerta(titulo: "Error", mensaje: "Código de servidor: \(httpResponse.statusCode)")
                    }
                }
            }.resume()
        }
        
        func mostrarAlerta(titulo: String, mensaje: String, accion: (() -> Void)? = nil) {
            let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
            alerta.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                accion?()
            })
            present(alerta, animated: true)
        }

}



import UIKit

class BarberoFormViewController: UIViewController {

    @IBOutlet weak var nombreTextField: UITextField!
    @IBOutlet weak var edadTextField: UITextField!
    @IBOutlet weak var emaiTextField: UITextField!
    @IBOutlet weak var usuarioTextField: UITextField!
    @IBOutlet weak var contrasenaTextField: UITextField!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    
    // MARK: - Guardar
     
    @IBAction func guardarBarbero(_ sender: Any) {
        
        validarGuardarDatos()
        
    }
    
    func validarGuardarDatos(){
    
        let nombre = nombreTextField.text ?? ""
        let edad = Int(edadTextField.text ?? "")
        let email = emaiTextField.text ?? ""
        let usuario = usuarioTextField.text ?? ""
        let contrasena = contrasenaTextField.text ?? ""
        
        guard !nombre.isEmpty, !email.isEmpty, !usuario.isEmpty, !contrasena.isEmpty else {
            mostrarAlerta("Por favor complete todos los campos")
            return
        }
        
        let nuevoBarbero = BarberoAPI (
            nombreBarbero: nombre,
            edadBarbero: edad,
            emailBarbero: email,
            usuarioBarbero: usuario,
            contrasenaBarbero: contrasena
        )
        
        
        guard let url = URL(string: "https://motivated-courage-production-877a.up.railway.app/api/barberos") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        if let token = UserDefaults.standard.string(forKey: "userToken") {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        request.httpBody = try? JSONEncoder().encode(nuevoBarbero)
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.mostrarAlerta("Error de red: \(error.localizedDescription)")
                    return
                    }
            
                if let httpResponse = response as? HTTPURLResponse {
                    guard (200...299).contains(httpResponse.statusCode) else {
                        var mensajeeServidor = "Error del servidor: código \(httpResponse.statusCode)"
                        if let data = data, let texto = String(data: data, encoding: .utf8) {
                            mensajeeServidor += "\n\(texto)"
                        }
                        self?.mostrarAlerta(mensajeeServidor)
                        return
                    }
                }
        
                    self?.limpiarCampos()
                    self?.mostrarAlerta("Barbero guardado con éxito", titulo: "Éxito") {
                        self?.navigationController?.popViewController(animated: true)
                    }
                }
            }.resume()
    }
    
    
    private func mostrarAlerta(_ mensaje: String, titulo: String = "Atención", completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        })
        present(alert, animated: true)
    }

    private func limpiarCampos() {
        [nombreTextField, edadTextField, emaiTextField, usuarioTextField, contrasenaTextField].forEach { $0?.text = "" }
        view.endEditing(true)
    }
    
    
    

}

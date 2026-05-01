
import UIKit

class ServicioNuevoFormViewController: UIViewController {

    @IBOutlet weak var servicioNombreTextField: UITextField!
    @IBOutlet weak var servicioPrecioTextField: UITextField!
    @IBOutlet weak var servicioDuracionTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func guardarServicio(_ sender: Any) {
        
        validarGuardarDatos()
    }
    
    func validarGuardarDatos() {
        let nombreServicio = servicioNombreTextField.text ?? ""
        let precio = servicioPrecioTextField.text ?? ""
        let duracion = servicioDuracionTextField.text ?? ""
        
        guard !nombreServicio.isEmpty, !precio.isEmpty, !duracion.isEmpty else {
            mostrarAlerta("Por favor ingrese todos los campos")
            return
        }
        
        let nuevoServicio = ServicioAPI (
            nombreServicio: nombreServicio,
            precioServicio: Double(precio),
            duracionServicio: Int(duracion)
        )
        
        guard let url = URL(string: "https://motivated-courage-production-877a.up.railway.app/api/servicios") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        if let token = UserDefaults.standard.string(forKey: "userToken") {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        request.httpBody = try? JSONEncoder().encode(nuevoServicio)
        
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
        [servicioNombreTextField, servicioPrecioTextField, servicioDuracionTextField].forEach { $0?.text = "" }
        view.endEditing(true)
    }

}

//
//  BarberoFormViewController.swift
//  JavaBarber
//
//  Created by trujillo on 2026/04/21.
//

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
        
        
        // Aquí podrías guardar en tu modelo/base de datos
        print("Guardando barbero: \(nombre), \(edad ?? 0 ), \(email), \(usuario), \(contrasena)")
        
        let nuevoBarbero:[String: Any] = [
            "nombreBarbero": nombre,
              "edadBarbero": edad as Any,
              "emailBarbero": email,
              "usuarioBarbero": usuario,
              "contrasenaBarbero": contrasena
        ]
        
        
        // 2. Configurar la URL y el Request
        guard let url = URL(string: "http://localhost:8080/api/barberos") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: nuevoBarbero)
        
        // 3. Ejecutar la petición
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    // Error: solo mostrar alerta, sin navegar
                    self?.mostrarAlerta("Error de red: \(error.localizedDescription)")
                    return
                }
            
        // Éxito: mostrar alerta y navegar AL TOCAR OK
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

//
//  BarberoFormViewController.swift
//  JavaBarber
//
//  Created by wilder trujillo on 2026/04/21.
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
        
        let nombre = nombreTextField.text ?? ""
        let edad = edadTextField.text ?? ""
        let email = emaiTextField.text ?? ""
        let usuario = usuarioTextField.text ?? ""
        let contraseña = contrasenaTextField.text ?? ""
        
        // Aquí podrías guardar en tu modelo/base de datos
        print("Guardando barbero: \(nombre), \(edad), \(email), \(usuario), \(contraseña)")

        // Feedback al usuario
        mostrarAlerta("Barbero guardado con éxito", titulo: "Éxito")
        limpiarCampos()
    }
    
    
    private func mostrarAlerta(_ mensaje: String, titulo: String = "Atención") {
        let alert = UIAlertController(title: titulo, message: mensaje, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    private func limpiarCampos() {
        [nombreTextField, edadTextField, emaiTextField, usuarioTextField, contrasenaTextField].forEach { $0?.text = "" }
        view.endEditing(true)
    }
    

}

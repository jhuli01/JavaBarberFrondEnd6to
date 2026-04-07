//
//  UsuariosViewController.swift
//  JavaBarber
//
//  Created by XCODE on 5/04/26.
//

import UIKit

class BarberoListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    // se conecto a la celda del tableView con el storyboard
    @IBOutlet weak var barberoCellTableView: UITableView!
    
    
    
    
    
    var barberos: [Barbero] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        barberoCellTableView.dataSource = self
        barberoCellTableView.delegate = self
        
        // cargar los barberos
        barberos = BarberoManager.shared.barberos
        barberoCellTableView.reloadData()
       
    }
    
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return barberos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BarberoCell", for: indexPath) as? BarberoCell else {
            return UITableViewCell()
        }
        
        let barbero = barberos[indexPath.row]
        
        // Configurar la celda
        cell.configure(with: barbero)
        return cell
    }
    
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Aquí puedes manejar la selección de un barbero
        let barbero = barberos[indexPath.row]
        print("Barbero seleccionado: \(barbero.nombreBarbero)")
    }
    
    
    // MARK: - Editar Barbero
    func editarBarbero(at indexPath: IndexPath) {
        let barbero = barberos[indexPath.row]
        
        // Crear un UIAlertController para editar
        let alert = UIAlertController(title: "Editar Barbero", message: "Modifica los datos del barbero", preferredStyle: .alert)
        
        // Agregar campos de texto
        alert.addTextField { textField in
            textField.placeholder = "Nombre"
            textField.text = barbero.nombreBarbero
        }
        
        alert.addTextField { textField in
            textField.placeholder = "Email"
            textField.text = barbero.emailBarbero
            textField.keyboardType = .emailAddress
        }
        
        // Acción de guardar
        let guardarAction = UIAlertAction(title: "Guardar", style: .default) { [weak self] _ in
            guard let self = self,
                  let nuevoNombre = alert.textFields?[0].text, !nuevoNombre.isEmpty,
                  let nuevoEmail = alert.textFields?[1].text, !nuevoEmail.isEmpty else {
                return
            }
            
            // Actualizar el barbero
            self.barberos[indexPath.row].nombreBarbero = nuevoNombre
            self.barberos[indexPath.row].emailBarbero = nuevoEmail
            
            // Actualizar en el manager si es necesario
            BarberoManager.shared.barberos = self.barberos
            
            // Recargar la celda específica
            self.barberoCellTableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
        // Acción de cancelar
        let cancelarAction = UIAlertAction(title: "Cancelar", style: .cancel)
        
        alert.addAction(guardarAction)
        alert.addAction(cancelarAction)
        
        present(alert, animated: true)
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    
    

}

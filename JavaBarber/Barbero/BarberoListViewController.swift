//
//  UsuariosViewController.swift
//  JavaBarber
//
//  Created by XCODE on 5/04/26.
//

import UIKit


struct Barbero: Decodable{
    var idBarbero: Int
    var nombreBarbero: String
    var edadBarbero: Int
    var emailBarbero: String
    var usuarioBarbero: String?
    var contrasenaBarbero: String?
}

class BarberoListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    // se conecto a la celda del tableView con el storyboard
    @IBOutlet weak var barberoCellTableView: UITableView!
    
    
    var barberos: [Barbero] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        barberoCellTableView.dataSource = self
        barberoCellTableView.delegate = self
        
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchBarverosDeAPI() // Se ejecuta cada vez que la pantalla aparece
    }
    
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return barberos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BarberoCell", for: indexPath) as? BarberoCell else {
            return UITableViewCell()
        }
        
        let barbero = barberos[indexPath.row]
        
        // Configurar la celda
        cell.configureBarberoCell(with: barbero)
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
    
    
    

    // MARK: - API Read (GET) /// listar productos
    func fetchBarverosDeAPI() {
        guard let url = URL(string: "https://motivated-courage-production-877a.up.railway.app/api/barberos") else { return }
            
            URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
                // Primero, verifica si hay un error de red
                if let error = error {
                    print("Error de red: \(error)")
                    return
                }
                
                guard let data = data else { return }
                
                do {
                    let decoded = try JSONDecoder().decode([Barbero].self, from: data)
                    DispatchQueue.main.async {
                        self?.barberos = decoded
                        self?.barberoCellTableView.reloadData()
                    }
                } catch {
                    // Esto te dirá exactamente qué parte del JSON falló
                    print("Error al decodificar: \(error)")
                }
            }.resume()
    }

    
    
    

}

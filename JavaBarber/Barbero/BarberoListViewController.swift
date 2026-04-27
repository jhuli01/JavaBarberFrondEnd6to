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
    
    
    var barberos: [BarberoAPI] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        barberoCellTableView.dataSource = self
        barberoCellTableView.delegate = self
        
    }
    
    
    @IBAction func cerrarSesion(_ sender: Any) {
        
        UserDefaults.standard.removeObject(forKey: "userToken")
        dismiss(animated: true, completion: nil)
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
        
        cell.nombresLabel.text = barbero.nombreBarbero
        cell.emailLabel.text = barbero.emailBarbero
        
        return cell
    }
    
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
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
                    let decoded = try JSONDecoder().decode([BarberoAPI].self, from: data)
                    DispatchQueue.main.async {
                        self?.barberos = decoded
                        self?.barberoCellTableView.reloadData()
                    }
                } catch {
                    print("Error al decodificar: \(error)")
                }
            }.resume()
    }

    
    
    

}

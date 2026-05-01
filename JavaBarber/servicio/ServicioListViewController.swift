//
//  ServicioListViewController.swift
//  JavaBarber
//
//  Created by wilder trujillo on 2026/04/28.
//

import UIKit

class ServicioListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate  {
    
    
    @IBOutlet weak var buscadorSearchBar: UISearchBar!
    
    @IBOutlet weak var servicioTableViewCell: UITableView!
    
    var servicios: [ServicioAPI] = []
    var serviciosFiltrados: [ServicioAPI] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        servicioTableViewCell.dataSource = self
        servicioTableViewCell.delegate = self
        buscadorSearchBar.delegate = self
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchServicios()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    if searchText.isEmpty {
        serviciosFiltrados = servicios
    } else {
        serviciosFiltrados = servicios.filter {
            $0.nombreServicio.lowercased().contains(searchText.lowercased())
        }
    }
    servicioTableViewCell.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return serviciosFiltrados.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "serviciosCell", for: indexPath) as? ServicioCell else {
            return UITableViewCell()
        }
        
        let servicio = serviciosFiltrados[indexPath.row]
        
        cell.servicioNombreLabel.text = servicio.nombreServicio
        cell.servicioPrecioLabel.text = "Precio: \(servicio.precioServicio ?? 0.0)"
        cell.servicioDuracionLabel.text = "Duracion: \(servicio.duracionServicio ?? 00) min"
        
        return cell
        
    }
    

    func fetchServicios(){
        
        guard let url = URL(string: "https://motivated-courage-production-877a.up.railway.app/api/servicios") else { return }
            
            var request = URLRequest(url: url)
            
            if let token = UserDefaults.standard.string(forKey: "userToken") {
                request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            }
            
            URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
                if let error = error {
                    print("Error de red: \(error.localizedDescription)")
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                    print("Error del servidor: código \(httpResponse.statusCode)")
                    return
                }
                
                guard let data = data else { return }
                
                do {
                    let decoded = try JSONDecoder().decode([ServicioAPI].self, from: data)
                    DispatchQueue.main.async {
                        self?.servicios = decoded
                        self?.serviciosFiltrados = decoded
                        self?.servicioTableViewCell.reloadData()
                    }
                } catch {
                    print("Error de decodificación: \(error)")
                }
            }.resume()
        
    }
    
}

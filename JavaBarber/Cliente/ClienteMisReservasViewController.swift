//
//  ClienteMisReservasViewController.swift
//  JavaBarber
//
//  Created by wilder trujillo on 2026/04/29.
//

import UIKit

class ClienteMisReservasViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
   
    @IBOutlet weak var reservasTableCell: UITableView!
    
    var citas: [CitaAPI] = []
    var idCliente: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        idCliente = UserDefaults.standard.integer(forKey: "idCliente")
        
        reservasTableCell.dataSource = self
        reservasTableCell.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        idCliente = UserDefaults.standard.integer(forKey: "idCliente")
        fetchCitasCliente()
    }
    
    func fetchCitasCliente() {
        guard let url = URL(string: "https://motivated-courage-production-877a.up.railway.app/api/citas") else { return }
        
        var request = URLRequest(url: url)
        if let token = UserDefaults.standard.string(forKey: "userToken") {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    return
                }
                guard let data = data else { return }
                
                do {
                    let todasLasCitas = try JSONDecoder().decode([CitaAPI].self, from: data)
                    let idCliente = self?.idCliente ?? 0
                    let citasDelCliente = todasLasCitas.filter { $0.cliente?.idCliente == idCliente }
                    
                    DispatchQueue.main.async {

                        self?.citas = citasDelCliente
                        self?.reservasTableCell.reloadData()
                    }
                } catch {
                    print("Error al decodificar: \(error)")
                }
            }.resume()
        }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return citas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CitaReservaListCell", for: indexPath) as? CitaHistorialTableViewCell else {
                        return UITableViewCell()
                    }
                    let cita = citas[indexPath.row]
                    cell.configurar(con: cita)
                    return cell
    }
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let citaSeleccionada = citas[indexPath.row]
        performSegue(withIdentifier: "segueCitaDetalle", sender: citaSeleccionada)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueCitaDetalle",
           let destination = segue.destination as? ClienteCitaDetalleViewController,
           let cita = sender as? CitaAPI {
            destination.cita = cita
        }
    }

}

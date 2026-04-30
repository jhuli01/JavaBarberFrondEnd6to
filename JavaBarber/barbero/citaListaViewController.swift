import UIKit

class citaListaViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var reservaCitaCell: UITableView!
    
    var idBarbero: Int = 0
    
    var citas: [CitaAPI] = []
    let apiUrl = "https://motivated-courage-production-877a.up.railway.app/api/citas"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        idBarbero = UserDefaults.standard.integer(forKey: "idBarbero")
        
        reservaCitaCell.dataSource = self
        reservaCitaCell.delegate = self
    }
    
    @IBAction func cerrarSesion(_ sender: Any) {
        
        UserDefaults.standard.removeObject(forKey: "userToken")
        UserDefaults.standard.removeObject(forKey: "idBarbero")
        dismiss(animated: true, completion: nil)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        idBarbero = UserDefaults.standard.integer(forKey: "idBarbero")
        
        fetchReservas()
    }
    
    
    
    func fetchReservas() {
        guard let url = URL(string: apiUrl) else { return }
        
        var request = URLRequest(url: url)
        if let token = UserDefaults.standard.string(forKey: "userToken") {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            if let error = error {
                print("Error de red: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else { return }
            
            do {
                
                let decoded = try JSONDecoder().decode([CitaAPI].self, from: data)
                let idCBarbero = self?.idBarbero ?? 0
                
                let citasDelBarbero = decoded.filter { $0.barbero?.idBarbero == idCBarbero }
                
                DispatchQueue.main.async {
                    self?.citas = citasDelBarbero
                    self?.reservaCitaCell.reloadData()
                }
            } catch {
                print("Error al decodificar: \(error)")
            }
        }.resume()
    }

    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return citas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "citaReservadaCell", for: indexPath) as? citaReservadaCell else {
            return UITableViewCell()
        }
        
        let cita = citas[indexPath.row]
        cell.nombreClienteLabel.text = cita.cliente?.nombreCliente ?? "Sin cliente"
        cell.servicioLabel.text = cita.servicio?.nombreServicio ?? "Sin servicio"
        cell.horaLabel.text = cita.hora
        cell.estadoLabel.text = cita.estado ?? "-"
        
        // Cambiamos el color según el estado
        switch cita.estado?.lowercased() {
        case "programada": cell.estadoLabel.textColor = .systemOrange
        case "atendida": cell.estadoLabel.textColor = .systemGreen
        case "cancelada": cell.estadoLabel.textColor = .systemRed
        default: cell.estadoLabel.textColor = .label
        }
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let citaSeleccionada = citas[indexPath.row]
        
        performSegue(withIdentifier: "segueCitaDetalle", sender: citaSeleccionada)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueCitaDetalle",
           let destination = segue.destination as? citaReservadaDetalleViewController,
           let cita = sender as? CitaAPI {
            destination.cita = cita
        }
    }
}


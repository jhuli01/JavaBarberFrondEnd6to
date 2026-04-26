import UIKit

class BarberoReservaListaViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var reservaCitaCell: UITableView!
    
    var citas: [CitaAPI] = []
    let apiUrl = "https://motivated-courage-production-877a.up.railway.app/api/citas"

    override func viewDidLoad() {
        super.viewDidLoad()
        reservaCitaCell.dataSource = self
        reservaCitaCell.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchReservas() // Carga los datos cada vez que entras a la pantalla
    }
    
    func fetchReservas() {
        guard let url = URL(string: apiUrl) else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            if let error = error {
                print("Error de red: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else { return }
            
            do {
                // Usamos nuestro nuevo modelo CitaAPI
                let decoded = try JSONDecoder().decode([CitaAPI].self, from: data)
                DispatchQueue.main.async {
                    self?.citas = decoded
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
        // Asegúrate de que en el Storyboard la celda tenga el Identifier "ReservaBarberoCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReservaBarberoCell", for: indexPath) as? ReservaBarberoCell else {
            return UITableViewCell()
        }
        
        let cita = citas[indexPath.row]
        
        // Llenamos la celda con los datos de la API
        cell.nombreClienteLabel.text = cita.cliente.nombreCliente
        cell.sservicioLabel.text = cita.servicio.nombreServicio
        cell.horaLabel.text = cita.hora
        cell.estadoLabel.text = cita.estado
        
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
        // Este Segue lo debes crear en el Storyboard (de la celda al Detalle)
        performSegue(withIdentifier: "segueDetalleReserva", sender: citaSeleccionada)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueDetalleReserva",
           let destination = segue.destination as? DetalleReservaBarberoViewController,
           let cita = sender as? CitaAPI {
            destination.cita = cita
        }
    }
}


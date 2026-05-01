
import UIKit

class ClienteInicioViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    
    
    @IBOutlet weak var clienteNombreLabel: UILabel!
    @IBOutlet weak var ServicioNombreLabel: UILabel!
    @IBOutlet weak var nombreBarberoLabel: UILabel!
    @IBOutlet weak var estadoLabel: UILabel!
    @IBOutlet weak var fechaHoraLabel: UILabel!
    
    @IBOutlet weak var proximaCitaView: UIView!
    
    @IBOutlet weak var historialCitaTableCell: UITableView!
    
    var proximaCita: CitaAPI?
    var historialCitas: [CitaAPI] = []
    var idCliente: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        idCliente = UserDefaults.standard.integer(forKey: "idCliente")
        
        historialCitaTableCell.dataSource = self
        historialCitaTableCell.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(verProximaCita))
        proximaCitaView.addGestureRecognizer(tap)
        proximaCitaView.isUserInteractionEnabled = true
        
        aplicarEstilo()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
        idCliente = UserDefaults.standard.integer(forKey: "idCliente")
            fetchCitasCliente()
        }
    
    @objc func verProximaCita() {
            guard let cita = proximaCita else { return }
            performSegue(withIdentifier: "segueCitaDetalle", sender: cita)
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
                            
                            self?.proximaCita = citasDelCliente.first(where: { $0.estado == "Programada" })
                            self?.historialCitas = citasDelCliente.filter({ $0.estado != "Programada" })
                            self?.actualizarUI()
                            self?.historialCitaTableCell.reloadData()
                        }
                    } catch {
                        print("Error al decodificar: \(error)")
                    }
                }.resume()
        }
    
    func aplicarEstilo() {
        // Fondo general
        view.backgroundColor = UIColor.systemGroupedBackground
        historialCitaTableCell.backgroundColor = .clear

        // Card próxima cita
        proximaCitaView.backgroundColor = .systemBackground
        proximaCitaView.layer.cornerRadius = 16
        proximaCitaView.layer.shadowColor = UIColor.black.cgColor
        proximaCitaView.layer.shadowOpacity = 0.08
        proximaCitaView.layer.shadowOffset = CGSize(width: 0, height: 4)
        proximaCitaView.layer.shadowRadius = 8
        proximaCitaView.clipsToBounds = false
    }
    
    func actualizarUI() {
        if let cita = proximaCita {
            clienteNombreLabel.text = "Hola, \(cita.cliente?.nombreCliente ?? "Cliente")"
            ServicioNombreLabel.text = cita.servicio?.nombreServicio ?? "Sin Servicio"
            nombreBarberoLabel.text = cita.barbero?.nombreBarbero ?? "Sin Barbero"
            fechaHoraLabel.text = "\(cita.fecha)  •  \(cita.hora)"

            estadoLabel.text = "  \(cita.estado ?? "Programada")  "
            estadoLabel.backgroundColor = .systemOrange
            estadoLabel.textColor = .white
            estadoLabel.font = UIFont.boldSystemFont(ofSize: 13)
            estadoLabel.layer.cornerRadius = 8
            estadoLabel.clipsToBounds = true

            proximaCitaView.isHidden = false
        } else {
            proximaCitaView.isHidden = true
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historialCitas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CitaHistorialCell", for: indexPath) as? CitaHistorialTableViewCell else {
                    return UITableViewCell()
                }
                let cita = historialCitas[indexPath.row]
                cell.configurar(con: cita)
                return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let citaSeleccionada = historialCitas[indexPath.row]
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

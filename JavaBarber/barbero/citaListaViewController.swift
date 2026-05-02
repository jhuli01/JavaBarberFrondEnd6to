import UIKit

class citaListaViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var reservaCitaCell: UITableView!
    
    @IBOutlet weak var filtroSegmented: UISegmentedControl!
    
    var idBarbero: Int = 0
    
    var citas: [CitaAPI] = []
    var citasFiltradas: [CitaAPI] = []
    let apiUrl = "https://motivated-courage-production-877a.up.railway.app/api/citas"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        reservaCitaCell.dataSource = self
        reservaCitaCell.delegate = self
        
        // Estilo general
        view.backgroundColor = .systemGroupedBackground
        reservaCitaCell.backgroundColor = .clear
        reservaCitaCell.separatorStyle = .none
        reservaCitaCell.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)

        // Segmented
        filtroSegmented.selectedSegmentTintColor = .systemOrange
        filtroSegmented.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        filtroSegmented.setTitleTextAttributes([.foregroundColor: UIColor.label], for: .normal)
    }

    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        idBarbero = UserDefaults.standard.integer(forKey: "idBarbero")
        
        fetchReservas()
    }
    
    @IBAction func filtroChanged(_ sender: UISegmentedControl) {
            aplicarFiltro()
        }

    func aplicarFiltro() {
        switch filtroSegmented.selectedSegmentIndex {
        case 0: citasFiltradas = citas.filter { $0.estado == "Programada" }
        case 1: citasFiltradas = citas.filter { $0.estado == "Atendida" }
        case 2: citasFiltradas = citas.filter { $0.estado == "Cancelada" }
        default: citasFiltradas = citas
        }
        reservaCitaCell.reloadData()
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
                    self?.aplicarFiltro()
                }
            } catch {
                print("Error al decodificar: \(error)")
            }
        }.resume()
    }

    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return citasFiltradas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "citaReservadaCell", for: indexPath) as? citaReservadaCell else {
            return UITableViewCell()
        }
        
        let cita = citasFiltradas[indexPath.row]
        cell.nombreClienteLabel.text = cita.cliente?.nombreCliente ?? "Sin cliente"
        cell.servicioLabel.text = cita.servicio?.nombreServicio ?? "Sin servicio"
        cell.horaLabel.text = cita.hora
        cell.estadoLabel.text = cita.estado ?? "-"
        
        // Cambiamos el color según el estado
        switch cita.estado?.lowercased() {
        case "programada": cell.estadoLabel.backgroundColor = .systemOrange
        case "atendida": cell.estadoLabel.backgroundColor = .systemGray
        case "cancelada": cell.estadoLabel.backgroundColor = .systemRed
        default: cell.estadoLabel.backgroundColor = .systemGray
        }
        
        cell.estadoLabel.textColor = .white
        cell.estadoLabel.layer.cornerRadius = 8
        cell.estadoLabel.clipsToBounds = true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let citaSeleccionada = citasFiltradas[indexPath.row]
        
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


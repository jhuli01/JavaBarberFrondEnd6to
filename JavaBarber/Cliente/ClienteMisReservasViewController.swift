
import UIKit

class ClienteMisReservasViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
   
    @IBOutlet weak var reservasTableCell: UITableView!
    @IBOutlet weak var filtroSegmented: UISegmentedControl!
    
    var citas: [CitaAPI] = []
    var citasFiltradas: [CitaAPI] = []
    var idCliente: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        reservasTableCell.dataSource = self
        reservasTableCell.delegate = self
        
        // Estilo general
        view.backgroundColor = .systemGroupedBackground
        reservasTableCell.backgroundColor = .clear
        reservasTableCell.separatorStyle = .none
        reservasTableCell.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)

        // Estilo segmented
        filtroSegmented.selectedSegmentTintColor = .systemOrange
        filtroSegmented.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        filtroSegmented.setTitleTextAttributes([.foregroundColor: UIColor.label], for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        idCliente = UserDefaults.standard.integer(forKey: "idCliente")
        fetchCitasCliente()
    }
    
    @IBAction func filtroChanged(_ sender: UISegmentedControl) {
            aplicarFiltro()
        }

        func aplicarFiltro() {
            switch filtroSegmented.selectedSegmentIndex {
            case 0: citasFiltradas = citas
            case 1: citasFiltradas = citas.filter { $0.estado == "Programada" }
            case 2: citasFiltradas = citas.filter { $0.estado == "Cancelada" }
            case 3: citasFiltradas = citas.filter { $0.estado == "Atendida" }
            default: citasFiltradas = citas
            }
            reservasTableCell.reloadData()
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
                        self?.aplicarFiltro()
                    }
                } catch {
                    print("Error al decodificar: \(error)")
                }
            }.resume()
        }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return citasFiltradas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CitaReservaListCell", for: indexPath) as? CitaHistorialTableViewCell else { return UITableViewCell() }
        
            let cita = citasFiltradas[indexPath.row]
            cell.configurar(con: cita)
            return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let citaSeleccionada = citasFiltradas[indexPath.row]
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

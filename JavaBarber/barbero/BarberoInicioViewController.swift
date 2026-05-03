

import UIKit

class BarberoInicioViewController: UIViewController {
    @IBOutlet weak var nombreBarberoLabel: UILabel!
    
    @IBOutlet weak var servicioNombreLabel: UILabel!
    @IBOutlet weak var clienteNombreLabel: UILabel!
    @IBOutlet weak var fechaHoraLabel: UILabel!
    @IBOutlet weak var estadoLabel: UILabel!
    
    @IBOutlet weak var programadasCountLabel: UILabel!
    @IBOutlet weak var atendidasCountLabel: UILabel!
    
    @IBOutlet weak var proximaCitaView: UIView!
    
    var proximaCita: CitaAPI?
    var citas: [CitaAPI] = []
    var idBarbero: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(verProximaCita))
        proximaCitaView.addGestureRecognizer(tap)
        proximaCitaView.isUserInteractionEnabled = true
        
        aplicarEstilo()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        idBarbero = UserDefaults.standard.integer(forKey: "idBarbero")
        fetchCitasCitas()
    }
    
    
    
    func fetchCitasCitas(){
        
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
                let idCliente = self?.idBarbero ?? 0
                
                let citasDelBarbero = todasLasCitas.filter { $0.barbero?.idBarbero == idCliente }
                
                DispatchQueue.main.async {
                    
                    let formatter = DateFormatter()
                        formatter.dateFormat = "yyyy-MM-dd"
                        let hoy = Date()
                    
                    self?.citas = citasDelBarbero
                    
                    self?.proximaCita = citasDelBarbero
                        .filter { $0.estado == "Programada" }
                        .filter {
                            if let fecha = formatter.date(from: $0.fecha) {
                                return fecha >= Calendar.current.startOfDay(for: hoy)
                            }
                            return false
                        }
                        .sorted {
                            let formatterCompleto = DateFormatter()
                            formatterCompleto.dateFormat = "yyyy-MM-dd HH:mm:ss"
                            
                            let str1 = "\($0.fecha) \($0.hora)"
                            let str2 = "\($1.fecha) \($1.hora)"
                            
                            let fechaHora1 = formatterCompleto.date(from: str1) ?? Date.distantFuture
                            let fechaHora2 = formatterCompleto.date(from: str2) ?? Date.distantFuture
                            
                            return fechaHora1 < fechaHora2
                        }
                        .first
                    
                    self?.actualizarUI()
                }
            } catch {
                print("Error al decodificar: \(error)")
            }
        }.resume()
        
    }
    
    func actualizarUI() {
        nombreBarberoLabel.text = "Hola, \(citas.first?.barbero?.nombreBarbero ?? "Barbero")"

        if let cita = proximaCita {
            clienteNombreLabel.text = cita.cliente?.nombreCliente
            servicioNombreLabel.text = cita.servicio?.nombreServicio ?? "Sin Servicio"
            fechaHoraLabel.text = "\(cita.fecha)  •  \(cita.hora)"
            estadoLabel.text = "  \(cita.estado ?? "Programada")  "
            estadoLabel.font = UIFont.boldSystemFont(ofSize: 13)
            estadoLabel.backgroundColor = .systemOrange
            estadoLabel.textColor = .white
            estadoLabel.layer.cornerRadius = 8
            estadoLabel.clipsToBounds = true
            proximaCitaView.isHidden = false

        } else {
            proximaCitaView.isHidden = false
            servicioNombreLabel.text = "No tienes citas próximas"
            servicioNombreLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
            servicioNombreLabel.textColor = .secondaryLabel
            clienteNombreLabel.text = ""
            fechaHoraLabel.text = ""
            estadoLabel.text = ""
            estadoLabel.backgroundColor = .clear
        }

        let programadas = citas.filter { $0.estado == "Programada" }.count
        let atendidas = citas.filter { $0.estado == "Atendida" }.count
        programadasCountLabel.text = "\(programadas)"
        atendidasCountLabel.text = "\(atendidas)"
    }
    
    @objc func verProximaCita() {
        guard let cita = proximaCita else { return }
        performSegue(withIdentifier: "segueCitaDetalle", sender: cita)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueCitaDetalle",
           let destination = segue.destination as? citaReservadaDetalleViewController,
           let cita = sender as? CitaAPI {
            destination.cita = cita
        }
    }
    
    //=============estilo=========
    
    func aplicarEstilo() {
        view.backgroundColor = .systemGroupedBackground
        
        // Card próxima cita
        proximaCitaView.backgroundColor = .systemBackground
        proximaCitaView.layer.cornerRadius = 16
        proximaCitaView.layer.shadowColor = UIColor.black.cgColor
        proximaCitaView.layer.shadowOpacity = 0.08
        proximaCitaView.layer.shadowOffset = CGSize(width: 0, height: 4)
        proximaCitaView.layer.shadowRadius = 8
        proximaCitaView.clipsToBounds = false
        
        // Label nombre barbero
        nombreBarberoLabel.font = UIFont.boldSystemFont(ofSize: 22)
        nombreBarberoLabel.textColor = .label
        
        // Label servicio
        servicioNombreLabel.font = UIFont.boldSystemFont(ofSize: 16)
        
        // Labels secundarios
        clienteNombreLabel.font = UIFont.systemFont(ofSize: 14)
        clienteNombreLabel.textColor = .secondaryLabel
        fechaHoraLabel.font = UIFont.systemFont(ofSize: 14)
        fechaHoraLabel.textColor = .secondaryLabel
        
        // Cards contadores
        estilizarCardContador(programadasCountLabel, color: .systemOrange)
        estilizarCardContador(atendidasCountLabel, color: .systemGray)
    }
    
    func estilizarCardContador(_ label: UILabel, color: UIColor) {
        guard let card = label.superview else { return }
        card.backgroundColor = color.withAlphaComponent(0.12)
        card.layer.cornerRadius = 16
        card.layer.borderWidth = 1
        card.layer.borderColor = color.withAlphaComponent(0.3).cgColor
        card.clipsToBounds = true
        
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.textColor = color
        
    }
}

import UIKit

class citaReservadaDetalleViewController: UIViewController {

    var cita: CitaAPI?
    

    @IBOutlet weak var clienteNombreLabel: UILabel!
    @IBOutlet weak var clienteTelefonoLabel: UILabel!
    @IBOutlet weak var clienteEmailLabel: UILabel!
    
    @IBOutlet weak var servicioPrecioLabel: UILabel!
    @IBOutlet weak var servicioNombreLabel: UILabel!
    @IBOutlet weak var servicioDuracionLabel: UILabel!
    
    @IBOutlet weak var citaFechaLabel: UILabel!
    @IBOutlet weak var citaHoraLabel: UILabel!
    @IBOutlet weak var citaEstadoLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        configurarVista()
    }
    
    func configurarVista() {
        guard let cita = cita else { return }
        
        
        clienteNombreLabel.text = cita.cliente?.nombreCliente
        clienteTelefonoLabel.text = cita.cliente?.telefonoCliente ?? "No disponible"
        clienteEmailLabel.text = cita.cliente?.emailCliente ?? "No disponible"
        
        servicioNombreLabel.text = cita.servicio?.nombreServicio
        servicioPrecioLabel.text = "Precio: $\(cita.servicio?.precioServicio ?? 0.0)"
        servicioDuracionLabel.text = "Duración: \(cita.servicio?.duracionServicio ?? 0) min"
        
        citaFechaLabel.text = "Fecha: \(cita.fecha)"
        citaHoraLabel.text = "Hora: \(cita.hora)"
        citaEstadoLabel.text = "Estado: \(cita.estado ?? "Desconocido")"
        
        actualizarColorEstado(cita.estado)
    }
    
    func actualizarColorEstado(_ estado: String?) {
        switch estado?.lowercased() {
        case "programada": citaEstadoLabel.backgroundColor = .systemOrange
        case "atendida": citaEstadoLabel.backgroundColor = .systemGreen
        case "cancelada": citaEstadoLabel.backgroundColor = .systemRed
        default: citaEstadoLabel.backgroundColor = .systemGray
        }
        citaEstadoLabel.textColor = .white
        citaEstadoLabel.layer.cornerRadius = 8
        citaEstadoLabel.clipsToBounds = true
    }

    // Acciones de los botones
    @IBAction func marcarCompletada(_ sender: Any) {
        actualizarEstado(nuevoEstado: "Atendida")
    }
    
    @IBAction func confirmarCita(_ sender: Any) {
        actualizarEstado(nuevoEstado: "Programada")
    }
    
    @IBAction func cancelarCita(_ sender: Any) {
        actualizarEstado(nuevoEstado: "Cancelada")
    }
    
    func actualizarEstado(nuevoEstado: String) {
        guard var citaActualizada = cita else { return }
        citaActualizada.estado = nuevoEstado
        
        let urlString = "https://motivated-courage-production-877a.up.railway.app/api/citas"
        guard let url = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONEncoder().encode(citaActualizada)
            
            URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
                DispatchQueue.main.async {
                    if let error = error {
                        print("Error: \(error.localizedDescription)")
                        return
                    }
                    
                    self?.cita = citaActualizada
                    self?.configurarVista()
                    
                    let alert = UIAlertController(title: "Éxito", message: "Cita actualizada a: \(nuevoEstado)", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self?.present(alert, animated: true)
                }
            }.resume()
            
        } catch {
            print("Error al codificar cita")
        }

    }
}

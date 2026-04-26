import UIKit

class DetalleReservaBarberoViewController: UIViewController {

    var cita: CitaAPI?
    
    // Conecta estos 3 a la sección de "Cliente"
    @IBOutlet weak var clienteNombreLabel: UILabel!
    @IBOutlet weak var clienteTelefonoLabel: UILabel!
    @IBOutlet weak var clienteEmailLabel: UILabel!
    
    // Conecta estos 4 a la sección de "Servicio"
    @IBOutlet weak var servicioNombreLabel: UILabel! // El nombre del servicio
    @IBOutlet weak var fechaHoraLabel: UILabel!      // Aquí va: "lunes 21 Abr. 10:00 a.m"
    @IBOutlet weak var servicioPrecioLabel: UILabel! // El precio
    @IBOutlet weak var citaEstadoLabel: UILabel!    // El recuadro del estado

    override func viewDidLoad() {
        super.viewDidLoad()
        configurarVista()
    }
    
    func configurarVista() {
        guard let cita = cita else { return }
        
        // Sección Cliente
        clienteNombreLabel.text = cita.cliente.nombreCliente
        clienteTelefonoLabel.text = cita.cliente.telefonoCliente ?? "No disponible"
        clienteEmailLabel.text = cita.cliente.emailCliente ?? "No disponible"
        
        // Sección Servicio (Siguiendo tu diseño)
        servicioNombreLabel.text = cita.servicio.nombreServicio
        fechaHoraLabel.text = "\(cita.fecha) \(cita.hora)"
        servicioPrecioLabel.text = "precio : S/.\(cita.servicio.precioServicio ?? 0.0)"
        
        // Estado
        citaEstadoLabel.text = "estado: \(cita.estado ?? "Desconocido")"
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
            URLSession.shared.dataTask(with: request) { [weak self] _, _, _ in
                DispatchQueue.main.async {
                    self?.cita = citaActualizada
                    self?.configurarVista()
                }
            }.resume()
        } catch {
            print("Error")
        }
    }
}

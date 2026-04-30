
import UIKit

class ClienteCitaDetalleViewController: UIViewController {

    @IBOutlet weak var servicioLabel: UILabel!
    @IBOutlet weak var duracionLabel: UILabel!
    @IBOutlet weak var precioLabel: UILabel!
    @IBOutlet weak var fechaLabel: UILabel!
    @IBOutlet weak var horaLabel: UILabel!
    @IBOutlet weak var barberoLabel: UILabel!
    @IBOutlet weak var estadoLabel: UILabel!
    @IBOutlet weak var cancelarButton: UIButton!
        
    var cita: CitaAPI?
        
    var idCita: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let cita = cita else { return }
                configurarUI(con: cita)
    }
    
    func configurarUI(con cita: CitaAPI) {
        
        
        servicioLabel.text = cita.servicio?.nombreServicio ?? "-"
        duracionLabel.text = "Duración: \(cita.servicio?.duracionServicio ?? 00) min"
        precioLabel.text = "Precio: S/.\(cita.servicio?.precioServicio ?? 00.0)"
        fechaLabel.text = cita.fecha
        horaLabel.text = cita.hora
        barberoLabel.text = "Barbero: \(cita.barbero?.nombreBarbero ?? "-")"
        estadoLabel.text = cita.estado ?? "-"
        
        switch cita.estado {
        case "Programada": estadoLabel.backgroundColor = .systemOrange
        case "Atendida": estadoLabel.backgroundColor = .systemGreen
        case "Cancelada": estadoLabel.backgroundColor = .systemRed
        default: estadoLabel.backgroundColor = .systemGray
        }
        estadoLabel.textColor = .white
        estadoLabel.layer.cornerRadius = 8
        estadoLabel.clipsToBounds = true
        
        
        cancelarButton.isHidden = cita.estado != "Programada"
    }
    
    // MARK: - Cancelar Cita
    @IBAction func cancelarCita(_ sender: Any) {
        let alert = UIAlertController(title: "¿Cancelar cita?", message: "Esta acción no se puede deshacer.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Sí, cancelar", style: .destructive) { [weak self] _ in
            self?.enviarCancelacion(nuevoEstado: "Cancelada")
        })
        alert.addAction(UIAlertAction(title: "No", style: .cancel))
        present(alert, animated: true)
    }
    
    func enviarCancelacion(nuevoEstado: String) {
        guard let url = URL(string: "https://motivated-courage-production-877a.up.railway.app/api/citas") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        if let token = UserDefaults.standard.string(forKey: "userToken") {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        // Enviar cita con estado actualizado
        var citaActualizada = cita!
        citaActualizada.estado = nuevoEstado
        request.httpBody = try? JSONEncoder().encode(citaActualizada)
        
        URLSession.shared.dataTask(with: request) { [weak self] _, response, error in
            DispatchQueue.main.async {
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    let alert = UIAlertController(title: "Cita cancelada", message: nil, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                        self?.navigationController?.popViewController(animated: true)
                    })
                    self?.present(alert, animated: true)
                } else {
                    let alert = UIAlertController(title: "Error", message: "No se pudo cancelar la cita.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self?.present(alert, animated: true)
                }
            }
        }.resume()
    }

}

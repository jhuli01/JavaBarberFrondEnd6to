
import UIKit

class AdminInicioViewController: UIViewController {
    
    @IBOutlet weak var barberosCountLabel: UILabel!
    @IBOutlet weak var clienteCountLabel: UILabel!
    
    @IBOutlet weak var citasProgramadasCountLabel: UILabel!
    @IBOutlet weak var citasAtendidasCountLabel: UILabel!
    @IBOutlet weak var citasCanceladasCountLabel: UILabel!
    @IBOutlet weak var totalCitasLabel: UILabel!
    
    var barberos: [BarberoAPI] = []
    var clientes: [ClienteAPI] = []
    var citas: [CitaAPI] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        aplicarEstilo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchTodo()
    }
    
    @IBAction func cerrarSesion(_ sender: Any) {
        
        UserDefaults.standard.removeObject(forKey: "userToken")
        dismiss(animated: true, completion: nil)
    }
    
    func fetchTodo() {
        let group = DispatchGroup()

        group.enter()
        fetchBarberos { group.leave() }

        group.enter()
        fetchClientes { group.leave() }

        group.enter()
        fetchCitas { group.leave() }

        group.notify(queue: .main) {
            self.actualizarUI()
        }
    }
    
    func fetchBarberos(completion: @escaping () -> Void) {
            fetch("https://motivated-courage-production-877a.up.railway.app/api/barberos",
                  tipo: [BarberoAPI].self) { result in
                self.barberos = result ?? []
                completion()
            }
        }

        func fetchClientes(completion: @escaping () -> Void) {
            fetch("https://motivated-courage-production-877a.up.railway.app/api/clientes",
                  tipo: [ClienteAPI].self) { result in
                self.clientes = result ?? []
                completion()
            }
        }

        func fetchCitas(completion: @escaping () -> Void) {
            fetch("https://motivated-courage-production-877a.up.railway.app/api/citas",
                  tipo: [CitaAPI].self) { result in
                self.citas = result ?? []
                completion()
            }
        }
    
    func fetch<T: Decodable>(_ urlString: String, tipo: T.Type, completion: @escaping (T?) -> Void) {
            guard let url = URL(string: urlString) else { completion(nil); return }
            var request = URLRequest(url: url)
            if let token = UserDefaults.standard.string(forKey: "userToken") {
                request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            }
            URLSession.shared.dataTask(with: request) { data, _, _ in
                guard let data = data else { completion(nil); return }
                let decoded = try? JSONDecoder().decode(T.self, from: data)
                completion(decoded)
            }.resume()
        }
    
    func actualizarUI() {
            barberosCountLabel.text = "\(barberos.count)"
            clienteCountLabel.text = "\(clientes.count)"
            citasProgramadasCountLabel.text = "\(citas.filter { $0.estado == "Programada" }.count)"
            citasAtendidasCountLabel.text = "\(citas.filter { $0.estado == "Atendida" }.count)"
            citasCanceladasCountLabel.text = "\(citas.filter { $0.estado == "Cancelada" }.count)"
            totalCitasLabel.text = "\(citas.count)"
        }

        func aplicarEstilo() {
            view.backgroundColor = .systemGroupedBackground

            // Estilo de todas las cards (superviews de los labels de conteo)
            let contadores = [barberosCountLabel, clienteCountLabel,
                              citasProgramadasCountLabel, citasAtendidasCountLabel,
                              citasCanceladasCountLabel, totalCitasLabel]

            let colores: [UIColor] = [.systemBlue, .systemPurple,
                                      .systemOrange, .systemGreen,
                                      .systemRed, .systemIndigo]

            for (i, label) in contadores.enumerated() {
                guard let card = label?.superview?.superview else { continue }
                let color = colores[i]

                card.backgroundColor = color.withAlphaComponent(0.1)
                card.layer.cornerRadius = 16
                card.layer.borderWidth = 1
                card.layer.borderColor = color.withAlphaComponent(0.3).cgColor
                card.clipsToBounds = true

                label?.font = UIFont.boldSystemFont(ofSize: 32)
                label?.textColor = color
            }
        }

}

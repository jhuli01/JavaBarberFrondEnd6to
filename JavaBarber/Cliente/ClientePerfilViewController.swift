

import UIKit

class ClientePerfilViewController: UIViewController {
    
    @IBOutlet weak var clienteNombreLabel: UILabel!
    @IBOutlet weak var clienteEmailLabel: UILabel!
    @IBOutlet weak var clienteTelefonoLabel: UILabel!
    
    var cliente: ClienteAPI?
    var idCliente: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCliente()
    }

    
    @IBAction func cerrarSesion(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "userToken")
        UserDefaults.standard.removeObject(forKey: "idCliente")
        dismiss(animated: true, completion: nil)
    }
    
    

    func configurarVista(){
        guard let cliente = cliente else { return }
        
        clienteNombreLabel.text = cliente.nombreCliente
        clienteTelefonoLabel.text = cliente.telefonoCliente ?? "No disponible"
        clienteEmailLabel.text = cliente.emailCliente ?? "No disponible"
        
    }
    
    func fetchCliente() {
        let idCliente = UserDefaults.standard.integer(forKey: "idCliente")
        
        guard let url = URL(string: "https://motivated-courage-production-877a.up.railway.app/api/clientes") else { return }
        
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
                
                let decoded = try JSONDecoder().decode([ClienteAPI].self, from: data)
                
                let clienteEncontrado = decoded.first { $0.idCliente == idCliente }
                
                DispatchQueue.main.async {
                    self?.cliente = clienteEncontrado
                    self?.configurarVista()
                }
            } catch {
                print("Error al decodificar: \(error)")
            }
        }.resume()
    }

    
    
    
}

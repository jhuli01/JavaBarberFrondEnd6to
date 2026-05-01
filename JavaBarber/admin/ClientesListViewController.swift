

import UIKit

class ClientesListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    

    @IBOutlet weak var clienteCell: UITableView!
    
    var clientes: [ClienteAPI] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        clienteCell.dataSource = self
        clienteCell.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchClientesDeAPI() // Se ejecuta cada vez que la pantalla aparece
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clientes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "clientesListView", for: indexPath) as? ClienteCell else {
            return UITableViewCell()
        }
        
        let cliente = clientes[indexPath.row]
        
        cell.clienteNombreLabel.text = cliente.nombreCliente
        cell.clienteEmailLabel.text = cliente.emailCliente
        cell.clienteTelefonoLabel.text = cliente.telefonoCliente
        
        return cell
    }
    
    func fetchClientesDeAPI() {
        
        guard let url = URL(string: "https://motivated-courage-production-877a.up.railway.app/api/clientes") else { return }
            
        var request = URLRequest(url: url)
        
        if let token = UserDefaults.standard.string(forKey: "userToken") {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            if let error = error {
                print("Error de red: \(error.localizedDescription)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                print("Error del servidor: código \(httpResponse.statusCode)")
                return
            }
            
            guard let data = data else { return }
            
            do {
                let decoded = try JSONDecoder().decode([ClienteAPI].self, from: data)
                DispatchQueue.main.async {
                    self?.clientes = decoded
                    self?.clienteCell.reloadData()
                }
            } catch {
                print("Error al decodificar: \(error)")
            }
        }.resume()
    }

}

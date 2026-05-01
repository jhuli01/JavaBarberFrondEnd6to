

import UIKit

class ClientesListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    

    @IBOutlet weak var clienteCell: UITableView!
    
    @IBOutlet weak var buscadorSearchBar: UISearchBar!
    
    var clientes: [ClienteAPI] = []
    var clientesFiltrados: [ClienteAPI] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        clienteCell.dataSource = self
        clienteCell.delegate = self
        buscadorSearchBar.delegate = self
        
        view.backgroundColor = .systemGroupedBackground
        clienteCell.backgroundColor = .clear
        clienteCell.separatorStyle = .none
        clienteCell.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)

        buscadorSearchBar.backgroundImage = UIImage()
        buscadorSearchBar.backgroundColor = .clear
        buscadorSearchBar.searchTextField.backgroundColor = .systemBackground
        buscadorSearchBar.searchTextField.layer.cornerRadius = 12
        buscadorSearchBar.searchTextField.clipsToBounds = true
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchClientesDeAPI()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            clientesFiltrados = clientes
        } else {
            clientesFiltrados = clientes.filter {
                $0.nombreCliente.lowercased().contains(searchText.lowercased())
            }
        }
        clienteCell.reloadData()
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clientesFiltrados.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "clientesListView", for: indexPath) as? ClienteCell else {
            return UITableViewCell()
        }
        
        let cliente = clientesFiltrados[indexPath.row]
        
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
                    self?.clientesFiltrados = decoded
                    self?.clienteCell.reloadData()
                }
            } catch {
                print("Error al decodificar: \(error)")
            }
        }.resume()
    }

}

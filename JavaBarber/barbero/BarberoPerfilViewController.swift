
import UIKit

class BarberoPerfilViewController: UIViewController {
    
    @IBOutlet weak var barberoNombreLabel: UILabel!
    @IBOutlet weak var barberoUsuarioLabel: UILabel!
    @IBOutlet weak var barberoEmailLabel: UILabel!
    @IBOutlet weak var barberoEdadLabel: UILabel!
    
    var barbero: BarberoAPI?
    var idBarbero: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchBarbero()
    }
    
    @IBAction func cerrarSesion(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "userToken")
        UserDefaults.standard.removeObject(forKey: "idBarbero")
        dismiss(animated: true, completion: nil)
    }
    
    func configurarVista() {
        guard let barbero = barbero else { return }
        
        barberoNombreLabel.text = barbero.nombreBarbero
        barberoUsuarioLabel.text = barbero.usuarioBarbero
        barberoEmailLabel.text = barbero.emailBarbero
        barberoEdadLabel.text = "\(barbero.edadBarbero ?? 00)"
        
    }
    
    func fetchBarbero() {
        let idBarbero = UserDefaults.standard.integer(forKey: "idBarbero")
        
        guard let url = URL(string: "https://motivated-courage-production-877a.up.railway.app/api/barberos") else { return }
        
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
                
                let decoded = try JSONDecoder().decode([BarberoAPI].self, from: data)
                
                let barberoEncontrado = decoded.first { $0.idBarbero == idBarbero }
                
                DispatchQueue.main.async {
                    self?.barbero = barberoEncontrado
                    self?.configurarVista()
                }
            } catch {
                print("Error al decodificar: \(error)")
            }
        }.resume()
    }
    

}

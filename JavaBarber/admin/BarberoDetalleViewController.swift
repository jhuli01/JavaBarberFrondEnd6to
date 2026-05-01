
import UIKit

class BarberoDetalleViewController: UIViewController {

    @IBOutlet weak var barberoNombreLabel: UILabel!
    @IBOutlet weak var barberoUsuarioLabel: UILabel!
    @IBOutlet weak var barberoEmailLabel: UILabel!
    @IBOutlet weak var barberoEdadLabel: UILabel!
    
    var barbero: BarberoAPI?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurarVista()
    }
    
    
    
    func configurarVista() {
        guard let barbero = barbero else {return}
                
        barberoNombreLabel.text = barbero.nombreBarbero
        barberoUsuarioLabel.text = "Usuario: \(barbero.usuarioBarbero ?? "No disponible")"
        barberoEmailLabel.text = "E-mail: \(barbero.emailBarbero ?? "No disponible")"
        barberoEdadLabel.text = "Edad: \(barbero.edadBarbero ?? 00) años"
        
    }
    
    
    
}

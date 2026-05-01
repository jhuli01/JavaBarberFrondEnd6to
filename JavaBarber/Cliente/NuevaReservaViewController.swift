
import UIKit

struct ReservaPost: Codable {
    let fecha: String
    let hora: String
    let estado: String
    let cliente: ClienteId
    let barbero: BarberoId
    let servicio: ServicioId
    
    struct ClienteId: Codable {
        let idCliente: Int
    }
    struct BarberoId: Codable {
        let idBarbero: Int
    }
    struct ServicioId: Codable {
        let idServicio: Int
    }
}

class NuevaReservaViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource{

    @IBOutlet weak var horaCita: UIDatePicker!
    @IBOutlet weak var fechaCita: UIDatePicker!
    @IBOutlet weak var comboBarbero: UIPickerView!
    @IBOutlet weak var comboServicio: UIPickerView!
    
    var listaBarberos: [BarberoAPI] = []
    var listaServicios: [ServicioAPI] = []
    

    var idBarberoSeleccionado: Int?
    var idServicioSeleccionado: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        comboBarbero.delegate = self
        comboBarbero.dataSource = self
        comboServicio.delegate = self
        comboServicio.dataSource = self
        
        fechaCita.datePickerMode = .date
        horaCita.datePickerMode = .time
        
        aplicarEstilo()
        cargarDatosDeAPI()
    }
    func cargarDatosDeAPI() {
        let token = UserDefaults.standard.string(forKey: "userToken") ?? ""

        func makeRequest(_ urlString: String) -> URLRequest {
            var request = URLRequest(url: URL(string: urlString)!)
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            return request
        }

        // Cargar Barberos
        URLSession.shared.dataTask(with: makeRequest("https://motivated-courage-production-877a.up.railway.app/api/barberos")) { data, _, _ in
            if let data = data, let lista = try? JSONDecoder().decode([BarberoAPI].self, from: data) {
                self.listaBarberos = lista
                DispatchQueue.main.async {
                    self.comboBarbero.reloadAllComponents()
                    if !lista.isEmpty { self.idBarberoSeleccionado = lista[0].idBarbero }
                }
            }
        }.resume()

        // Cargar Servicios
        URLSession.shared.dataTask(with: makeRequest("https://motivated-courage-production-877a.up.railway.app/api/servicios")) { data, _, _ in
            if let data = data, let lista = try? JSONDecoder().decode([ServicioAPI].self, from: data) {
                self.listaServicios = lista
                DispatchQueue.main.async {
                    self.comboServicio.reloadAllComponents()
                    if !lista.isEmpty { self.idServicioSeleccionado = lista[0].idServicio }
                }
            }
        }.resume()
    }

    @IBAction func btnRegistrarReserva(_ sender: Any) {
        guard let idBarb = idBarberoSeleccionado, let idServ = idServicioSeleccionado else {
            print("Faltan seleccionar datos")
            return
        }

        let formatterFecha = DateFormatter()
        formatterFecha.dateFormat = "yyyy-MM-dd"
        let fechaString = formatterFecha.string(from: fechaCita.date)

        let formatterHora = DateFormatter()
        formatterHora.dateFormat = "HH:mm:ss"
        let horaString = formatterHora.string(from: horaCita.date)

        let idCliente = UserDefaults.standard.integer(forKey: "idCliente")

        let nuevaReserva = ReservaPost(
            fecha: fechaString,
            hora: horaString,
            estado: "Programada",
            cliente: .init(idCliente: idCliente),
            barbero: .init(idBarbero: idBarb),
            servicio: .init(idServicio: idServ)
        )

        enviarReserva(reserva: nuevaReserva)
    }
    func enviarReserva(reserva: ReservaPost) {
        guard let url = URL(string: "https://motivated-courage-production-877a.up.railway.app/api/citas") else { return }
        
        var request = URLRequest(url: url)
        if let token = UserDefaults.standard.string(forKey: "userToken") {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONEncoder().encode(reserva)
        } catch { return }

        URLSession.shared.dataTask(with: request) { _, response, error in
            DispatchQueue.main.async {
                if let httpRes = response as? HTTPURLResponse {
                    
                    if httpRes.statusCode == 200 || httpRes.statusCode == 201 {
                        self.navigationController?.popViewController(animated: true)
                    } else {
                        let alert = UIAlertController(title: "Error", message: "No se pudo registrar la reserva.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default))
                        self.present(alert, animated: true)
                    }
                }
            }
        }.resume()
    }
    
    func aplicarEstilo() {
        // Fondo general
        view.backgroundColor = UIColor.systemGroupedBackground
        
        // Estilo PickerViews
        for picker in [comboBarbero, comboServicio] {
            picker?.backgroundColor = .systemBackground
            picker?.layer.cornerRadius = 12
            picker?.layer.borderWidth = 1
            picker?.layer.borderColor = UIColor.systemGray4.cgColor
            picker?.clipsToBounds = true
        }
        
        // Estilo DatePickers
        for datePicker in [fechaCita, horaCita] {
            datePicker?.backgroundColor = .systemBackground
            datePicker?.layer.cornerRadius = 12
            datePicker?.layer.borderWidth = 1
            datePicker?.layer.borderColor = UIColor.systemGray4.cgColor
            datePicker?.clipsToBounds = true
            datePicker?.tintColor = .systemBlue
            datePicker?.preferredDatePickerStyle = .compact
        }
    }

    // MARK: - UIPickerView DataSource & Delegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerView == comboBarbero ? listaBarberos.count : listaServicios.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerView == comboBarbero ? listaBarberos[row].nombreBarbero : listaServicios[row].nombreServicio
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == comboBarbero {
            idBarberoSeleccionado = listaBarberos[row].idBarbero
        } else {
            idServicioSeleccionado = listaServicios[row].idServicio
        }
    }
    
}

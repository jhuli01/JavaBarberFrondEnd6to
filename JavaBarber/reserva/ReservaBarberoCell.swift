//
//  ReservaBarberoCellTableViewCell.swift
//  JavaBarber
//
//  Created by wilder trujillo on 2026/04/25.
//

import UIKit

class ReservaBarberoCell: UITableViewCell {
    
    @IBOutlet weak var nombreClienteLabel: UILabel!
    @IBOutlet weak var servicioLabel: UILabel!
    @IBOutlet weak var horaLabel: UILabel!
    @IBOutlet weak var estadoLabel: UILabel!
    /*
    func configure(with cita: CitaAPI) {
        nombreClienteLabel.text = cita.cliente.nombreCliente
        servicioLabel.text = cita.servicio.nombreServicio
        horaLabel.text = cita.hora
        estadoLabel.text = cita.estado
        
        switch cita.estado?.lowercased() {
        case "programada": estadoLabel.textColor = .systemOrange
        case "atendida": estadoLabel.textColor = .systemGreen
        case "cancelada": estadoLabel.textColor = .systemRed
        default: estadoLabel.textColor = .label
        }
    }
*/
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

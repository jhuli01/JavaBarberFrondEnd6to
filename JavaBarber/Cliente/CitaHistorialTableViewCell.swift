//
//  CitaHistorialTableViewCell.swift
//  JavaBarber
//
//  Created by wilder trujillo on 2026/04/28.
//

import UIKit

class CitaHistorialTableViewCell: UITableViewCell {

    
    @IBOutlet weak var servicioLabel: UILabel!
    @IBOutlet weak var fechaHoraLabel: UILabel!
    @IBOutlet weak var barberoLabel: UILabel!
    @IBOutlet weak var estadoLabel: UILabel!
    
    func configurar(con cita: CitaAPI) {
        servicioLabel.text = cita.servicio.nombreServicio
        fechaHoraLabel.text = "\(cita.fecha) - \(cita.hora)"
        barberoLabel.text = cita.barbero.nombreBarbero
        estadoLabel.text = cita.estado ?? "-"
        
        switch cita.estado {
        case "Atendida":
            estadoLabel.backgroundColor = .systemGray
        case "Cancelada":
            estadoLabel.backgroundColor = .systemRed
        default:
            estadoLabel.backgroundColor = .systemGray
        }
        estadoLabel.textColor = .white
        estadoLabel.layer.cornerRadius = 4
        estadoLabel.clipsToBounds = true
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

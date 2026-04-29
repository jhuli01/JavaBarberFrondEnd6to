//
//  ReservaBarberoCellTableViewCell.swift
//  JavaBarber
//
//  Created by wilder trujillo on 2026/04/25.
//

import UIKit

class citaReservadaCell: UITableViewCell {
    
    @IBOutlet weak var nombreClienteLabel: UILabel!
    @IBOutlet weak var servicioLabel: UILabel!
    @IBOutlet weak var horaLabel: UILabel!
    @IBOutlet weak var estadoLabel: UILabel!
 
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

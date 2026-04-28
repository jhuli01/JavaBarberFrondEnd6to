//
//  ServicioCellTableViewCell.swift
//  JavaBarber
//
//  Created by wilder trujillo on 2026/04/28.
//

import UIKit

class ServicioCell: UITableViewCell {

    @IBOutlet weak var servicioNombreLabel: UILabel!
    @IBOutlet weak var servicioPrecioLabel: UILabel!
    @IBOutlet weak var servicioDuracionLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

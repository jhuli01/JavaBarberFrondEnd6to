//
//  UsuariosCell.swift
//  JavaBarber
//
//  Created by XCODE on 5/04/26.
//

import UIKit

class BarberoCell: UITableViewCell {

    @IBOutlet weak var nombresLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    
    
    
    func configure(with barbero: Barbero){
        nombresLabel.text = barbero.nombreBarbero
        emailLabel.text = barbero.emailBarbero
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

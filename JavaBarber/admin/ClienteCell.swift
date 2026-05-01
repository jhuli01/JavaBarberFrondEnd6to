

import UIKit

class ClienteCell: UITableViewCell {

    @IBOutlet weak var clienteNombreLabel: UILabel!
    
    @IBOutlet weak var clienteEmailLabel: UILabel!
    
    @IBOutlet weak var clienteTelefonoLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}



import UIKit

class ClienteCell: UITableViewCell {

    @IBOutlet weak var clienteNombreLabel: UILabel!
    
    @IBOutlet weak var clienteEmailLabel: UILabel!
    
    @IBOutlet weak var clienteTelefonoLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .clear
        selectionStyle = .none

        contentView.backgroundColor = .systemBackground
        contentView.layer.cornerRadius = 14
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.07
        contentView.layer.shadowOffset = CGSize(width: 0, height: 3)
        contentView.layer.shadowRadius = 6
        contentView.layer.masksToBounds = false

        clienteNombreLabel.font = UIFont.boldSystemFont(ofSize: 16)
        clienteNombreLabel.textColor = .label

        clienteEmailLabel.font = UIFont.systemFont(ofSize: 13)
        clienteEmailLabel.textColor = .secondaryLabel

        clienteTelefonoLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        clienteTelefonoLabel.textColor = .systemBlue
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 6, left: 16, bottom: 6, right: 16))
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

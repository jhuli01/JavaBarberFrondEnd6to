
import UIKit

class citaReservadaCell: UITableViewCell {
    
    @IBOutlet weak var nombreClienteLabel: UILabel!
    @IBOutlet weak var servicioLabel: UILabel!
    @IBOutlet weak var horaLabel: UILabel!
    @IBOutlet weak var estadoLabel: UILabel!
 
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .clear
        selectionStyle = .none

        // Card
        contentView.backgroundColor = .systemBackground
        contentView.layer.cornerRadius = 14
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.07
        contentView.layer.shadowOffset = CGSize(width: 0, height: 3)
        contentView.layer.shadowRadius = 6
        contentView.layer.masksToBounds = false

        // Márgenes internos con inset
        contentView.layoutMargins = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)

        // Fuentes
        servicioLabel.font = UIFont.boldSystemFont(ofSize: 16)
        servicioLabel.textColor = .label

        nombreClienteLabel.font = UIFont.systemFont(ofSize: 14)
        nombreClienteLabel.textColor = .secondaryLabel

        horaLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 14, weight: .medium)
        horaLabel.textColor = .secondaryLabel

        estadoLabel.font = UIFont.boldSystemFont(ofSize: 12)
        estadoLabel.textAlignment = .center
        estadoLabel.layer.cornerRadius = 8
        estadoLabel.clipsToBounds = true
    }
    
    //===
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 6, left: 16, bottom: 6, right: 16))
    }
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

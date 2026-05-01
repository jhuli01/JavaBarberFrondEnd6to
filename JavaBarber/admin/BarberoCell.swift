
import UIKit

class BarberoCell: UITableViewCell {

    @IBOutlet weak var nombresLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!

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

        nombresLabel.font = UIFont.boldSystemFont(ofSize: 16)
        nombresLabel.textColor = .label

        emailLabel.font = UIFont.systemFont(ofSize: 13)
        emailLabel.textColor = .secondaryLabel
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

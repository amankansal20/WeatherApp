import UIKit

class Cell: UITableViewCell {
    static let reuseIdentifier: String = "cell"
    
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var weatherType: UILabel!
    @IBOutlet weak var weatherTypeImage: UIImageView!
    @IBOutlet weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.gray.cgColor
        containerView.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

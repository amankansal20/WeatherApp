
import UIKit

class SearchBarTableViewCell: UITableViewCell {

    @IBOutlet weak var searchTextField: UITextField!
    //MARK: Action Blocks
    var searchBarAction:((String, Int) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.searchTextField.delegate = self
        self.searchTextField.textColor = .black
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
extension SearchBarTableViewCell: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text {
            let query = text.replacingOccurrences(of: " ", with: "")
            self.searchBarAction?(query,query.count)
        }
        return true
    }
}




import UIKit

class MainViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = "Welcome to the Library App"
    }

    @IBAction func loginButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "toLogin", sender: self)
    }
}

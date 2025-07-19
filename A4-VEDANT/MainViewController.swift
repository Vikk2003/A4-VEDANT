import UIKit

class MainViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Create the image view
        let backgroundImage = UIImage(named: "yourImageName")
        let imageView = UIImageView(image: backgroundImage)
        
        // Calculate height as 40% of view height
        let height = view.frame.height * 0.4
        imageView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: height)
        
        // Make it translucent
        imageView.alpha = 0.5  // Adjust for desired translucency
        
        // Optional: aspect fill to avoid distortion
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        // Add as subview behind everything else
        view.addSubview(imageView)
        view.sendSubviewToBack(imageView)
    }


    @IBAction func loginButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "toLogin", sender: self)
    }
}

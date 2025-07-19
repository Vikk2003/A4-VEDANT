import UIKit
import CoreData

class LoginViewController: UIViewController {

    @IBOutlet weak var Heading: UILabel!
    @IBOutlet weak var UserNameIndicator: UILabel!
    @IBOutlet weak var PasswordIndicator: UILabel!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        addBackgroundImage()
        preloadDataIfNeeded()
    }

    func addBackgroundImage() {
        let imageView = UIImageView(image: UIImage(named: "library_bg"))
        imageView.contentMode = .scaleAspectFill
        imageView.alpha = 0.3
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(imageView, at: 0)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4)
        ])
    }

    func preloadDataIfNeeded() {
        let request: NSFetchRequest<User> = User.fetchRequest()
        let userCount = (try? context.count(for: request)) ?? 0
        if userCount == 0 {
            let u1 = User(context: context)
            u1.username = "user1"
            u1.password = "pass1"

            let u2 = User(context: context)
            u2.username = "user2"
            u2.password = "pass2"

            let b1 = Book(context: context)
            b1.title = "Swift"
            b1.author = "Apple"
            b1.borrower = ""

            let b2 = Book(context: context)
            b2.title = "Java"
            b2.author = "Oracle"
            b2.borrower = ""

            let b3 = Book(context: context)
            b3.title = "Python"
            b3.author = "Guido"
            b3.borrower = ""

            try? context.save()
        }
    }

    @IBAction func loginPressed(_ sender: UIButton) {
        let username = usernameField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let password = passwordField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

        guard !username.isEmpty, !password.isEmpty else {
            showAlert(title: "Missing Fields", message: "Please enter both username and password.")
            return
        }

        let request: NSFetchRequest<User> = User.fetchRequest()
        request.predicate = NSPredicate(format: "username == %@ AND password == %@", username, password)

        do {
            let result = try context.fetch(request)
            if result.count > 0 {
                print("✅ Login successful for: \(username)")
                performSegue(withIdentifier: "toBooksList", sender: username)
            } else {
                print("❌ Invalid credentials: \(username), \(password)")
                showAlert(title: "Login Failed", message: "Invalid username or password.")
            }
        } catch {
            print("🔥 CoreData fetch error: \(error.localizedDescription)")
            showAlert(title: "Error", message: "Something went wrong. Please try again.")
        }
    }


    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toBooksList" {
            let dest = segue.destination as! BooksListViewController
            dest.loggedInUsername = sender as? String
        }
    }
}

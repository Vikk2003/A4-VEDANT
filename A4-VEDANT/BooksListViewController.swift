import UIKit
import CoreData

class BooksListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var books: [Book] = []
    var loggedInUsername: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addBackgroundImage()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        welcomeLabel.text = "Welcome to the book list"
        fetchBooks()
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

    func fetchBooks() {
        let request: NSFetchRequest<Book> = Book.fetchRequest()
        books = (try? context.fetch(request)) ?? []
        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseId = "BookCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseId) ??
                   UITableViewCell(style: .subtitle, reuseIdentifier: reuseId)
        
        let book = books[indexPath.row]
        cell.textLabel?.text = book.title
        cell.detailTextLabel?.text = "Author: \(book.author ?? "")"
        
        switch book.borrower {
        case "":
            cell.accessoryView = statusLabel(text: "Available, tap to checkout", color: .systemGreen)
        case loggedInUsername:
            cell.accessoryView = statusLabel(text: "Checked out, tap to return", color: .systemBlue)
        default:
            cell.accessoryView = statusLabel(text: "Unavailable", color: .systemRed)
        }

        return cell
    }

    func statusLabel(text: String, color: UIColor) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = color
        label.sizeToFit()
        return label
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let book = books[indexPath.row]

        switch book.borrower {
        case "":
            book.borrower = loggedInUsername
        case loggedInUsername:
            book.borrower = ""
        default:
            showAlert(title: "Not allowed", message: "This book is borrowed by another user.")
            return
        }

        try? context.save()
        fetchBooks()
    }

    @IBAction func logoutPressed(_ sender: UIButton) {
        if let nav = navigationController {
            nav.popToRootViewController(animated: true)
        } else {
            dismiss(animated: true)
        }
    }

    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

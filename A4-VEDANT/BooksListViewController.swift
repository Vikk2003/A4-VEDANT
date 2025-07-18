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
        tableView.dataSource = self
        tableView.delegate = self
        welcomeLabel.text = "Welcome, \(loggedInUsername ?? "")"
        fetchBooks()
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

        let cell = tableView.dequeueReusableCell(withIdentifier: "BookCell", for: indexPath)
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
        navigationController?.popViewController(animated: true)
    }

    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

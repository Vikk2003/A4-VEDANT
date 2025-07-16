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

    // MARK: Table View Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let book = books[indexPath.row]
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)

        cell.textLabel?.text = book.title
        cell.detailTextLabel?.text = "Author: \(book.author ?? "")"

        let statusLabel = UILabel()
        statusLabel.font = UIFont.systemFont(ofSize: 12)
        statusLabel.textColor = .gray

        if book.borrower == "" {
            statusLabel.text = "Available, tap to checkout"
        } else if book.borrower == loggedInUsername {
            statusLabel.text = "Checked out, tap to return"
        } else {
            statusLabel.text = "Unavailable"
        }

        statusLabel.sizeToFit()
        cell.accessoryView = statusLabel

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let book = books[indexPath.row]

        if book.borrower == "" {
            book.borrower = loggedInUsername
        } else if book.borrower == loggedInUsername {
            book.borrower = ""
        } else {
            let alert = UIAlertController(title: "Not allowed", message: "This book is borrowed by another user.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }

        try? context.save()
        fetchBooks()
    }

    @IBAction func logoutPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}

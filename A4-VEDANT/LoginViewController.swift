	
//
//  LoginVIewController.swift
//  A4-VEDANT
//
//  Created by Vedant on 2025-07-14.
//

import Foundation
import UIKit
import CoreData

class LoginViewController: UIViewController {

    @IBOutlet weak var Heading: UILabel!
    
    @IBOutlet weak var UserNameIndicator: UILabel!
    
    
    @IBOutlet weak var PasswordIndicator: UILabel!
    
    
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var users: [User] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        preloadDataIfNeeded()
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

            // Add 3 sample books
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
        let username = usernameField.text ?? ""
        let password = passwordField.text ?? ""

        let request: NSFetchRequest<User> = User.fetchRequest()
        request.predicate = NSPredicate(format: "username == %@ AND password == %@", username, password)

        if let result = try? context.fetch(request), result.count > 0 {
            performSegue(withIdentifier: "toBooksList", sender: username)
        } else {
            let alert = UIAlertController(title: "Login Failed", message: "Invalid credentials", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toBooksList" {
            let dest = segue.destination as! BooksListViewController
            dest.loggedInUsername = sender as? String
        }
    }
}

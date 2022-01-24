//
//  TaskerProfileViewController.swift
//  taskify-app
//
//  Created by Jignesh Kumavat
//

import UIKit
import CoreData

class TaskerProfileViewController: UIViewController {

    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userType: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var userContact: UILabel!
    @IBOutlet weak var userGender: UILabel!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUserData()
    }
    
    @IBAction func logout(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchUserData()
    }
    
    // Fetch user data from core data
    private func fetchUserData() {
        let email = Configs.loggedInUserEmail
        
        let request: NSFetchRequest<User> = User.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "email == %@", email)

        do {
            let user = try context.fetch(request)
            populateData(user: user.first!)
        } catch {
            print ("Error getting user")
        }
        
    }
    
    // Populate user data on UI from core data
    private func populateData(user: User) {
        userName.text = user.name
        userEmail.text = user.email
        userContact.text = user.contact
        userGender.text = user.gender
        userType.text = user.type
    }

}

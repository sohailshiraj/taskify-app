//
//  ProfileViewController.swift
//  taskify-app
//
//  Created by Niraj Sutariya.
//

import UIKit
import CoreData

class ProfileViewController: UIViewController {
    
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
    
    //fetchning user details with email from coredata
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
    
    //populate labels with user data
    private func populateData(user: User) {
        userName.text = user.name
        userEmail.text = user.email
        userContact.text = user.contact
        userGender.text = user.gender
        userType.text = user.type
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

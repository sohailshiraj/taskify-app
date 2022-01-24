//
//  TaskerProfileEditViewController.swift
//  taskify-app
//
//  Created by Jignesh Kumavat
//

import UIKit
import CoreData

class TaskerProfileEditViewController: UIViewController {

    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var userEmail: UITextField!
    @IBOutlet weak var userPassword: UITextField!
    @IBOutlet weak var userContact: UITextField!
    
    @IBOutlet weak var userNameErrorLabel: UILabel!
    @IBOutlet weak var userEmailErrorLabel: UILabel!
    @IBOutlet weak var userPasswordErrorLabel: UILabel!
    @IBOutlet weak var userContactErrorLabel: UILabel!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
        initialize()
        fetchUserData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initialize()
        fetchUserData()
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    // Initialize the form
    func initialize() {
        resetForm();
    }
    
    // Fetch loggedin user data from core data
    private func fetchUserData() {
        let email = Configs.loggedInUserEmail
        
        let request: NSFetchRequest<User> = User.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "email == %@", email)

        do {
            let user = try context.fetch(request)
            populateData(user: user[0])
        } catch {
            print ("Error getting user")
        }
        
    }
    
    // Populate data on UI from core data
    private func populateData(user: User) {
        if(user != nil){
            userName.text = user.name
            userEmail.text = user.email
            userContact.text = user.contact
            userPassword.text = user.password
        }
        
    }
    
    // Event handler for update user profile
    @IBAction func updateProfile(_ sender: Any) {
        if(validate()){
            let email = Configs.loggedInUserEmail
            
            let request: NSFetchRequest<User> = User.fetchRequest()
            request.fetchLimit = 1
            request.predicate = NSPredicate(format: "email == %@", email)
            
            do {
                let user = try context.fetch(request)
                let objUpdate = user[0] as! NSManagedObject
                objUpdate.setValue(userName.text, forKey: "name")
                objUpdate.setValue(userEmail.text, forKey: "email")
                objUpdate.setValue(userContact.text, forKey: "contact")
                objUpdate.setValue(userPassword.text, forKey: "password")
                try context.save()
                self.view.showToast(toastMessage: "Profile update successfully", duration: 2.0)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
//                    self.dismiss(animated: true, completion: nil)
                    self.navigationController?.popViewController(animated: true)
                }
                
            } catch {
                self.view.showToast(toastMessage: "Something went wrong!", duration: 2.0)
                print ("Error while saving")
            }
        }
        
    }
    
    private func resetForm() {
        resetErrors()
    }
    
    // Reset errors on form
    private func resetErrors() {
        userNameErrorLabel.text = ""
        userNameErrorLabel.isHidden = true
        
        userEmailErrorLabel.text = ""
        userEmailErrorLabel.isHidden = true
        
        userPasswordErrorLabel.text = ""
        userPasswordErrorLabel.isHidden = true
        
        userContactErrorLabel.text = ""
        userContactErrorLabel.isHidden = true
    }
    
    // Validate user input
    private func validate() -> Bool {
        resetErrors()
        
        var isValid = true;
        
        if (userName.text == "") {
            userNameErrorLabel.text = "*User name is required"
            userNameErrorLabel.isHidden = false
            isValid = false
        }
        
        if (userEmail.text == "") {
            userEmailErrorLabel.text = "*User email is required"
            userEmailErrorLabel.isHidden = false
            isValid = false
        }
        
        if (userEmail.text != "" && !validateEmail()) {
            userEmailErrorLabel.text = "*Invalid email"
            userEmailErrorLabel.isHidden = false
            userEmail.text = ""
            isValid = false
        }
        
        if (userPassword.text == "") {
            userPasswordErrorLabel.text = "*User password is required"
            userPasswordErrorLabel.isHidden = false
            isValid = false
        }
        
        if (userContact.text == "") {
            userContactErrorLabel.text = "*User contact is required"
            userContactErrorLabel.isHidden = false
            isValid = false
        }
        
        if (userContact.text != "" && !validateContact()) {
            userContactErrorLabel.text = "*Invalid contact"
            userContactErrorLabel.isHidden = false
            userContact.text = ""
            isValid = false
        }
        
        return isValid
    }
    
    // Validate user email
    private func validateEmail() -> Bool {
        let emailPattern = #"^\S+@\S+\.\S+$"#
        
        let result = userEmail.text!.range(
            of: emailPattern,
            options: .regularExpression
        )
        
        return (result != nil)
    }
    
    // Validate user contact
    private func validateContact() -> Bool {
        let contactPattern = #"^\(?\d{3}\)?[ -]?\d{3}[ -]?\d{4}$"#
        
        let result = userContact.text!.range(
            of: contactPattern,
            options: .regularExpression
        )
        
        return (result != nil)
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

}

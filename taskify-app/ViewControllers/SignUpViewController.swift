//
//  SignUpViewController.swift
//  taskify-app
//
//  Created by Niraj Sutariya
//

import UIKit
import CoreData

class SignUpViewController: UIViewController {

    @IBOutlet weak var userType: UISegmentedControl!
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var userEmail: UITextField!
    @IBOutlet weak var userPassword: UITextField!
    @IBOutlet weak var userContact: UITextField!
    @IBOutlet weak var userGender: UISegmentedControl!
    
    @IBOutlet weak var userNameErrorLabel: UILabel!
    @IBOutlet weak var userEmailErrorLabel: UILabel!
    @IBOutlet weak var userPasswordErrorLabel: UILabel!
    @IBOutlet weak var userContactErrorLabel: UILabel!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        initialize();
    }
    //Initialize the form
    func initialize() {
        resetForm();
    }
    //Event handler for register button
    @IBAction func registerUser(_ sender: Any) {
        if (validate()) {
            let user = User(context: self.context)
            user.name = userName.text!
            user.email = userEmail.text!
            user.contact = userContact.text!
            user.password = userPassword.text!
            user.gender = (userGender.selectedSegmentIndex == 0) ? Gender.Male.rawValue : Gender.Female.rawValue
            user.type = (userType.selectedSegmentIndex == 0) ? UserType.Tasker.rawValue : UserType.Requester.rawValue
            
            do {
                try context.save()
                self.view.showToast(toastMessage: "Registration successful, please login", duration: 2.0)
                initialize()
            } catch {
                print("Error whle saving user")
            }
        }
    }
    //Resetting form fields
    private func resetForm() {
        userName.text = ""
        userEmail.text = ""
        userPassword.text = ""
        userContact.text = ""
        
        resetErrors()
    }
    //Resetting all the errors
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
    
    //Validate inputs
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
    
    //validate email via regex
    private func validateEmail() -> Bool {
        let emailPattern = #"^\S+@\S+\.\S+$"#
        
        let result = userEmail.text!.range(
            of: emailPattern,
            options: .regularExpression
        )
        
        return (result != nil)
    }
    
    //validate contact via regex
    private func validateContact() -> Bool {
        let contactPattern = #"^\(?\d{3}\)?[ -]?\d{3}[ -]?\d{4}$"#
        
        let result = userContact.text!.range(
            of: contactPattern,
            options: .regularExpression
        )
        
        return (result != nil)
    }
    
    //dismiss keyboard
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
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

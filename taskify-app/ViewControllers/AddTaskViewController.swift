//
//  AddTaskViewController.swift
//  taskify-app
//
//  Created by Sohail Shiraj.
//

import UIKit
import CoreData

class AddTaskViewController: UIViewController {

    @IBOutlet weak var taskTitle: UITextField!
    @IBOutlet weak var taskDetail: UITextField!
    @IBOutlet weak var taskHours: UITextField!
    @IBOutlet weak var taskPayPerHour: UITextField!
    @IBOutlet weak var taskStartDate: UIDatePicker!
    @IBOutlet weak var taskTitleErrorLabel: UILabel!
    @IBOutlet weak var taskDetailErrorLabel: UILabel!
    @IBOutlet weak var taskHoursErrorLabel: UILabel!
    @IBOutlet weak var taskPayPerHourErrorLabel: UILabel!
    @IBOutlet weak var taskStartDateErrorLabel: UILabel!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        initialize();
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    func initialize() {
        resetForm();
    }
    
    // Event handler for adding a task
    @IBAction func addTask(_ sender: Any) {
        if (validate()) {
            let task = Task(context: self.context)
            task.title = taskTitle.text
            task.detail = taskDetail.text
            task.hours = Int16(taskHours.text!)!
            task.ratePerHour = Int16(taskPayPerHour.text!)!
            task.startDate = taskStartDate.date ?? Date()
            task.creationDate = Date()
            task.status = "CREATED"
            //task.location = Location()
            //task.feeback = TaskFeedback()
            let user: User? = fetchUser()
            
            if(user != nil){
                task.requester = user
            }
            
            do {
                try context.save()
                self.view.showToast(toastMessage: "Task added successfully", duration: 2.0)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    self.navigationController?.popViewController(animated: true)
                }
                
            } catch {
                print("Error whle saving user \(error)")
            }
        }
    
    }
    
    // Fetching logged in user data
    private func fetchUser() -> User? {
        let email = Configs.loggedInUserEmail
        
        let request: NSFetchRequest<User> = User.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "email == %@", email)

        var user: User
        do {
            let userList = try context.fetch(request)
            user = userList[0]
            return user
        } catch {
            print ("Error getting user")
            return nil
        }
    }
    
    // Reset form
    private func resetForm() {
        taskTitle.text = ""
        taskDetail.text = ""
        taskHours.text = ""
        taskPayPerHour.text = ""
        
        resetErrors()
    }
    
    // Reset errors on form
    private func resetErrors() {
        taskDetailErrorLabel.text = ""
        taskDetailErrorLabel.isHidden = true
        
        taskTitleErrorLabel.text = ""
        taskTitleErrorLabel.isHidden = true
        
        taskHoursErrorLabel.text = ""
        taskHoursErrorLabel.isHidden = true
        
        taskPayPerHourErrorLabel.text = ""
        taskPayPerHourErrorLabel.isHidden = true
        
        taskStartDateErrorLabel.text = ""
        taskStartDateErrorLabel.isHidden = true
    }
    
    // Validate form inputs
    private func validate() -> Bool {
        resetErrors()
        
        var isValid = true;
        
        if (taskTitle.text == "") {
            taskTitleErrorLabel.text = "*Title is required"
            taskTitleErrorLabel.isHidden = false
            isValid = false
        }
        
        if (taskDetail.text == "") {
            taskDetailErrorLabel.text = "*Details are required"
            taskDetailErrorLabel.isHidden = false
            isValid = false
        }
        
        if(taskHours.text == "") {
            taskHoursErrorLabel.text = "*Hours are required"
            taskHoursErrorLabel.isHidden = false
            isValid = false
        }
        
        if (taskHours.text != "" && !ValidateHour()) {
            taskHoursErrorLabel.text = "*Invalid Hours"
            taskHoursErrorLabel.isHidden = false
            isValid = false
        }
        
        if(taskPayPerHour.text == "") {
            taskPayPerHourErrorLabel.text = "*Pay per hour is required"
            taskPayPerHourErrorLabel.isHidden = false
            isValid = false
        }
        
        if (taskPayPerHour.text != "" && !ValidatePay()) {
            taskPayPerHourErrorLabel.text = "*Invalid Pay per hour"
            taskPayPerHourErrorLabel.isHidden = false
            isValid = false
        }
        
        return isValid
    }
    
    // Validate number of hours input
    private func ValidateHour() -> Bool {
        let pattern = #"^\d+$"#
        
        let result = taskHours.text!.range(
            of: pattern,
            options: .regularExpression
        )
        
        return (result != nil)
    }
    
    // Validate pay per hour input
    private func ValidatePay() -> Bool {
        let pattern = #"^\d+$"#
        
        let result = taskPayPerHour.text!.range(
            of: pattern,
            options: .regularExpression
        )
        
        return (result != nil)
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

}

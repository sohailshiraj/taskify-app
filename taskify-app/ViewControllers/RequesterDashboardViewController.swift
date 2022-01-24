//
//  RequesterDashboardViewController.swift
//  taskify-app
//
//  Created by Sohail Shiraj.
//

import UIKit
import CoreData

class RequesterDashboardViewController: UIViewController {

    @IBOutlet weak var createdTasksCount: UILabel!
    @IBOutlet weak var pendingTasksCount: UILabel!
    @IBOutlet weak var inProgressTasksCount: UILabel!
    @IBOutlet weak var completedTasksCount: UILabel!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        createdTasksCount.text = fetchTasksCount(status: "CREATED")
        pendingTasksCount.text = fetchTasksCount(status: "PENDING")
        inProgressTasksCount.text = fetchTasksCount(status: "IN_PROGRESS")
        completedTasksCount.text = fetchTasksCount(status: "COMPLETED")
    }
    
    //Getting tasks with respect to status
    private func fetchTasksCount(status: String) -> String {
        let request: NSFetchRequest<Task> = Task.fetchRequest()
        request.predicate = NSPredicate(format: "status == %@ AND requester.email = %@", status, Configs.loggedInUserEmail)
        
        do {
            let user = try context.fetch(request)
            return String(user.count)
        } catch {
            print("Error while fetching tasks")
        }
        
        return "0"
    }

}

//
//  TaskerTaskViewController.swift
//  taskify-app
//
//  Created by Ali Ahad
//

import UIKit
import CoreData

class TaskerTaskViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var taskFilterControl: UISegmentedControl!
    @IBOutlet weak var taskTableView: UITableView!
    
    var taskList: [Task] = [];
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "TaskerTaskViewCell", bundle: nil)
        taskTableView.register(nib, forCellReuseIdentifier: "TaskerTaskViewCell")
        taskTableView.delegate = self
        taskTableView.dataSource = self
        
        fetchTaskData(status: "CREATED")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchTaskData(status: "CREATED")
    }
    
    // Fetch task data from core data
    private func fetchTaskData(status: String? = nil, useEmail: Bool = false) {
        let request: NSFetchRequest<Task> = Task.fetchRequest()
        
        if (status != nil && useEmail) {
            request.predicate = NSPredicate(format: "status == %@ AND tasker.email == %@", status!, Configs.loggedInUserEmail)
        } else if (status != nil) {
            request.predicate = NSPredicate(format: "status == %@", status!)
        }
        
        do {
            self.taskList = try context.fetch(request)
            self.taskTableView.reloadData()
        } catch {
            print ("Error getting user")
        }
        
    }
    
    // Event handler for value change in segmented control
    @IBAction func taskFilterChanged(_ sender: UISegmentedControl) {
        let selectedIndex = taskFilterControl.selectedSegmentIndex
        
        switch selectedIndex {
        case 0:
            fetchTaskData(status: "CREATED")
        case 1:
            fetchTaskData(status: "PENDING")
        case 2:
            fetchTaskData(status: "IN_PROGRESS", useEmail: true)
        case 3:
            fetchTaskData(status: "COMPLETED", useEmail: true)
        default:
            fetchTaskData(status: "CREATED")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskList.count
    }
    
    // Update values of each cell in table view
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = taskTableView.dequeueReusableCell(withIdentifier: "TaskerTaskViewCell",
                                                     for: indexPath) as! TaskerTaskViewCell
        
        //GetData and place it in xib file
        
        let task = self.taskList[indexPath.row]
        
        cell.taskTitle.text = task.title
        cell.taskDescription.text = task.detail
        cell.taskHourRate.text = "$\(String(task.ratePerHour))/hour"
        cell.taskNumOfHours.text = "\(String(task.hours)) hours"
        cell.taskPostedBy.text = "Posted by \(task.requester!.name!)"
        cell.taskLocation.text = "Waterloo"//task.location?.city
        cell.taskDate.text = "Start date: \(formatDate(date: task.startDate!))"
        
        //add styling
        self.taskTableView.rowHeight = 110.0
        return cell
    }
    
    // Event handler for on click on cell of table
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (self.taskList[indexPath.row].status == "CREATED") {
            if let viewController = storyboard?.instantiateViewController(identifier: "ApplyTaskViewController") as?
                ApplyTaskViewController{
                    viewController.task = self.taskList[indexPath.row]
                
                    self.navigationController?.pushViewController(viewController, animated: true)
                }
        }
    }
    
    // Format date to string
    private func formatDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        
        return formatter.string(from: date)
    }

}

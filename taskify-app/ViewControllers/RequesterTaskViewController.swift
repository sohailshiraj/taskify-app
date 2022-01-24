//
//  RequesterTaskViewController.swift
//  taskify-app
//
//  Created by Sohail Shiraj.
//

import UIKit
import CoreData

class RequesterTaskViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var taskTableView: UITableView!
    @IBOutlet weak var taskFilterControl: UISegmentedControl!
    
    //task and proposal List
    var taskList: [Task] = []
    var proposalList: [TaskProposal] = []
    
    //context for coredata
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //registring NIB for table view cell
        let nib = UINib(nibName: "RequesterTaskViewCell", bundle: nil)
        taskTableView.register(nib, forCellReuseIdentifier: "RequesterTaskViewCell")
        taskTableView.delegate = self
        taskTableView.dataSource = self
        
        //fetching tasks based on status
        fetchTaskData(status: "CREATED")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchTaskData(status: "CREATED")
    }
    
    //getting tasks based on status
    private func fetchTaskData(status: String? = nil) {
        let request: NSFetchRequest<Task> = Task.fetchRequest()
        
        if (status != nil) {
            request.predicate = NSPredicate(format: "status == %@ AND requester.email == %@", status!, Configs.loggedInUserEmail)
        }
        
        do {
            self.taskList = try context.fetch(request)
            self.taskTableView.reloadData()
        } catch {
            print ("Error getting user")
        }
    }
    
    //getting proposals based on status
    private func fetchProposalData(status: String? = nil) {
        let request: NSFetchRequest<TaskProposal> = TaskProposal.fetchRequest()
        
        if (status != nil) {
            request.predicate = NSPredicate(format: "status == %@ AND task.status == %@ AND task.requester.email == %@", "PENDING", "PENDING", Configs.loggedInUserEmail)
        }
        
        do {
            self.proposalList = try context.fetch(request)
            self.taskTableView.reloadData()
        } catch {
            print ("Error getting user")
        }
    }
    
    //Event handler for detecing change in filer selection
    @IBAction func taskFilterChanged(_ sender: UISegmentedControl) {
        let selectedIndex = taskFilterControl.selectedSegmentIndex
        
        switch selectedIndex {
        case 0:
            fetchTaskData(status: "CREATED")
        case 1:
            fetchProposalData(status: "PENDING")
        case 2:
            fetchTaskData(status: "IN_PROGRESS")
        case 3:
            fetchTaskData(status: "COMPLETED")
        default:
            fetchTaskData(status: "CREATED")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if taskFilterControl.selectedSegmentIndex == 1 {
            return proposalList.count
        } else {
            return taskList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = taskTableView.dequeueReusableCell(withIdentifier: "RequesterTaskViewCell",
                                                     for: indexPath) as! RequesterTaskViewCell
        
        var task: Task? = nil
        if taskFilterControl.selectedSegmentIndex == 1 {
            task = proposalList[indexPath.row].task
        } else {
            task = taskList[indexPath.row]
        }
        
        cell.taskTitle.text = task?.title
        cell.taskDescription.text = task?.detail
        cell.taskHourRate.text = "$\(String(task!.ratePerHour))/hour"
        cell.taskNumOfHours.text = "\(String(task!.hours)) hours"
        cell.taskDate.text = "Start date: \(formatDate(date: (task?.startDate!)!))"
        
        //add styling
        self.taskTableView.rowHeight = 85.0
        return cell
    }
    
    //event for clicking on cell row on table
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (taskFilterControl.selectedSegmentIndex == 1) {
            if let viewController = storyboard?.instantiateViewController(identifier: "ProposalViewController") as?
                ProposalViewController{
                    viewController.taskProposal = self.proposalList[indexPath.row]
                
                    self.navigationController?.pushViewController(viewController, animated: true)
                }
        } else if (self.taskList[indexPath.row].status == "IN_PROGRESS") {
            if let viewController = storyboard?.instantiateViewController(identifier: "CompleteTaskViewController") as?
                CompleteTaskViewController{
                    viewController.task = self.taskList[indexPath.row]
                
                    self.navigationController?.pushViewController(viewController, animated: true)
                }
        }
    }
    
    private func formatDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        
        return formatter.string(from: date)
    }

}

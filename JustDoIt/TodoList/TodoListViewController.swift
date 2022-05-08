//
//  TodoListViewController.swift
//  JustDoIt
//
//  Created by Guillian Daguplo on 4/2/22.
//

import Foundation
import UIKit

class ToDoViewController: UIViewController, DataEnteredDelegate, CalendarDelegate{
    var currentDate:Date?
    var formatter:DateFormatter?
    @IBOutlet var tableView: UITableView!
    @IBOutlet var dateLabel: UILabel!
    var delegate:NotifDelegate? = nil

    
    
    var unsortedAsgnmntList: [Assignment]=[]
    var asgnmntList: [Assignment] = []
    
    //  Protocol to update table when new assignment is created
    func userDidEnterNewAsgnmnt(assignment: Assignment) {
//        let newIndexPath = IndexPath(row: asgnmntList.count, section: 0)
//        tableView.beginUpdates()
        unsortedAsgnmntList.append(assignment)
        print(unsortedAsgnmntList)
        reloadList()
//        tableView.insertRows(at: [newIndexPath], with: .fade)
//        tableView.reloadData()
//        tableView.endUpdates()
        //push assignment into a user's unsortedassignmentlist
    }
    //  Protocol to get user selected date
    func userDidEnterNewDate(date: Date) {
        self.dateLabel.text = formatter?.string(from: date)
        currentDate = date
        print(currentDate?.formatted() as Any)
        reloadList()
    }
    func reloadList() {
        asgnmntList.removeAll()
        for asgnmnt in unsortedAsgnmntList {
            let order = Calendar.current.compare(asgnmnt.getDueDate()!, to: currentDate!, toGranularity: .day)
            
                switch order {
                case .orderedAscending:
                    print("date is after")
                    break
                case .orderedDescending:
                    print("date is before")
                    break
                case .orderedSame:
                    print("date is equal")
                    asgnmntList.append(asgnmnt)
                    break
                default:
                    print("contact developer")
                    break
                }
        }
        tableView.reloadData()
    }
    
    func initList() {
        unsortedAsgnmntList.append(Assignment("Project Checkin 1", dueBy: Date(), details: "Create Structures", status: .finished))
        unsortedAsgnmntList.append(Assignment("Project Checkin 2", dueBy: Date(), details: nil, status: .finished))
        unsortedAsgnmntList.append(Assignment("Project Checkin 3", dueBy: Date(), details: "Working UI", status: .finished))
        unsortedAsgnmntList.append(Assignment("Project Checkin 4", dueBy: Date(), details: "Merged and ready 2 go", status: .inPrgrs))

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        currentDate  = Date()
        formatter = DateFormatter()
        formatter?.dateFormat = "MM/dd"
        dateLabel.text = formatter?.string(from: currentDate!)
        if unsortedAsgnmntList.count == 0 {
            print("Initializing List")
            initList()
        }
        reloadList()
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "YourAsgnmts2AddAsgnmnts" {
            let secondVC:AddAssignmentViewController = segue.destination as! AddAssignmentViewController
            secondVC.delegate = self
        }
        if segue.identifier == "DateSelection" {
            let calendarVC:CalendarVC = segue.destination as! CalendarVC
            calendarVC.delegate = self
        }
    }

    
    @IBAction func AddAssignment(_ sender: Any) {
    }
    @IBAction func OpenSettings(_ sender: Any) {
    }
    @IBAction func selectDate(_ sender: Any) {
    }
}

extension ToDoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("you tapped me!")
    }
}

extension ToDoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return asgnmntList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = asgnmntList[indexPath.row].getName()
        return cell
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            asgnmntList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    }
    
    
}

protocol NotifDelegate {
    func getAssignmentList(list:[Assignment]) -> [Assignment]
}

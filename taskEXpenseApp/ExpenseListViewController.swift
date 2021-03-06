//
//  ViewController.swift
//  taskEXpenseApp
//
//  Created by Raj Shekhar on 4/17/17.
//  Copyright © 2017 Raj Shekhar. All rights reserved.
//

import UIKit
import RealmSwift

class ExpenseListViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var btnMenu: UIBarButtonItem!
    @IBOutlet weak var tblView: UITableView!
    
    
    var results = [NewExpense]()
    var expenselists : Results<NewExpense>!
    var currentCreateAction:UIAlertAction!
    var firstTime: Bool? = true
    var selectedIndexPath:IndexPath? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblView.dataSource = self
        tblView.delegate = self
        expenselists = readTasksAndUpdateUI()
        tblView.rowHeight = UITableViewAutomaticDimension
        tblView.estimatedRowHeight = 140
        navigationItem.backBarButtonItem?.tintColor = UIColor.green
        print("dir","\(NewExpense.DocumentsDirectory)")
        
        //reveal
        if self.revealViewController() != nil {
            btnMenu.target = self.revealViewController()
            btnMenu.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        

        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        NotificationCenter.default.addObserver(forName: .UIContentSizeCategoryDidChange, object: .none, queue: OperationQueue.main) { [weak self] _ in
            self?.tblView.reloadData()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tblView.reloadData()
        //hide back button here
        navigationItem.hidesBackButton = true

    }
    
    func readTasksAndUpdateUI() -> Results<NewExpense>{
        
        return   dbRealm.objects(NewExpense.self)
        //        self.tblView.setEditing(false, animated: true)
    }
    //segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ExpenseDetailViewController ,
            let indexPath = tblView.indexPathForSelectedRow {
            destination.selectedExpense = expenselists[indexPath.row]
        }
    }
}

extension ExpenseListViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("count",expenselists.count)
        return expenselists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblView.dequeueReusableCell(withIdentifier: "Cell") as! NewExpenseTableViewCell
        let list = expenselists[indexPath.row]
//        print("this is list",list)
//        cell?.textLabel?.text = String(list.moneySpent)
        
//        if firstTime!  {
//            cell.accessoryType = .checkmark
//            //            cell.accessoryType = UITableViewCellAccessoryCheckmark
//        }
//        cell.textLabel?.text = String(describing: list.tempList)
        cell.lblTitle.text = list.eventTitle
        cell.lblTotalMoneySpent.text = String(list.totalMoneySpent)
        
//        cell.selectionStyle = .none
//        if let _ = selectedIndexPath {
//            if (indexPath.compare(selectedIndexPath!) == .orderedSame) {
//                if cell.accessoryType == .checkmark {
//                    cell.accessoryType = .none
//                } else {
//                    cell.accessoryType = .checkmark
//                }
//            }
//        }
        
        return cell
    }
}

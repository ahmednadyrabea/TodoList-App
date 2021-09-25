//
//  NavigationBarBorderColor.swift
//  ToDoListApp
//
//  Created by Ahmed Nady Rabea on 11/8/21.
//

import UIKit
import DGElasticPullToRefresh

protocol addOrderToDoList {
    func addObject(text:String)
}

class ViewController: UIViewController {
    
    var toDoListArray = ["Eat","Sleep","School","play","iOS","Swift","Developer","home"]
    //var toDoListArray = [String]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        pullToRefreshTable()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        
        //self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationController?.navigationBar.backgroundColor = #colorLiteral(red: 0.3242165446, green: 0.8114417791, blue: 0.4445466995, alpha: 1)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add Item", style: .plain, target: self, action: #selector(self.addItemPressed))
        
        
        //self.navigationController?.setNavigationBarBorderColor(.clear)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        tableView.dg_removePullToRefresh()
    }
    
    //MARK: IBAction
    
    @objc func addItemPressed(){
        
        let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "AddItemVC") as! AddItemVC
        VC.delegate = self
        VC.modalPresentationStyle = .fullScreen
        present(VC, animated: true, completion: nil)
    }
    
    @objc func upBtnPressed(sender: UIButton){
        
        if sender.tag != 0{
            
            toDoListArray.swapAt(sender.tag, (sender.tag - 1))
            tableView.reloadData()
        }
    }
    
    @objc func downBtnPressed(sender: UIButton){
        
        if sender.tag != (toDoListArray.count - 1){
            
            toDoListArray.swapAt(sender.tag, (sender.tag + 1))
            tableView.reloadData()
        }
    }
    
    //MARK: Helper Functions
    
    func pullToRefreshTable(){
        
        // Initialize tableView
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = #colorLiteral(red: 0.1799096763, green: 0.2272781134, blue: 0.296102792, alpha: 1)
        tableView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            // Add your logic here
            // Do not forget to call dg_stopLoading() at the end
            self?.tableView.dg_stopLoading()
        }, loadingView: loadingView)
        tableView.dg_setPullToRefreshFillColor(#colorLiteral(red: 0.3242165446, green: 0.8114417791, blue: 0.4445466995, alpha: 1))
        tableView.dg_setPullToRefreshBackgroundColor(tableView.backgroundColor!)
    }
}

extension ViewController: UITableViewDelegate , UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ToDoListTVC
        
        cell.orderlistLbl.text = toDoListArray[indexPath.row]
        
        cell.upBtnOutLet.tag = indexPath.row
        cell.upBtnOutLet.addTarget(self, action: #selector(self.upBtnPressed(sender:)), for: .touchUpInside)
        
        
        cell.downBtnOutLet.tag = indexPath.row
        cell.downBtnOutLet.addTarget(self, action: #selector(self.downBtnPressed(sender:)), for: .touchUpInside)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteCell = UIContextualAction(style: .normal, title: "Delete") { (action, view, nil) in
            
            self.toDoListArray.remove(at: indexPath.row)
            self.tableView.reloadData()
        }
        
        deleteCell.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        deleteCell.image = #imageLiteral(resourceName: "pin")
        
        let perform = UISwipeActionsConfiguration(actions: [deleteCell])
        //to prevent first action when we hard swip
        //perform.performsFirstActionWithFullSwipe = false
        return perform
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cellAnimation(cell: cell, index: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}


extension ViewController : addOrderToDoList{
    
    func addObject(text: String) {
        toDoListArray.append(text)
        tableView.reloadData()
    }
}


// MARK:- TableViewCell Animation
extension ViewController {
    
    
    func cellAnimation(cell: UITableViewCell, index: Int) {
        
        for _ in 0...index{
            let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, 0, 1000, 0)
            cell.layer.transform = rotationTransform
            cell.alpha = 0
            
            UIView.animate(withDuration: 0.7, delay: 0.3 ,animations: {
                cell.layer.transform = CATransform3DIdentity
                cell.alpha = 1.0
            }, completion: nil)
        }
    }
    
}


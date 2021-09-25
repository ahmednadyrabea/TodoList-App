//
//  NavigationBarBorderColor.swift
//  ToDoListApp
//
//  Created by Ahmed Nady Rabea on 11/8/21.
//

import UIKit

class AddItemVC: UIViewController {

    var delegate: addOrderToDoList?
    @IBOutlet weak var addItemTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Add ToDo Item"
    }
    
    
    @IBAction func addItemBtnPressed(_ sender: UIButton) {
        
        dismiss(animated: true) {
            
            if let text = self.addItemTF.text{
                self.delegate?.addObject(text: text)
            }
        }
    }
    

}

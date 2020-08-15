//
//  GlobalSelectorViewController.swift
//  C-19
//
//  Created by Pranjal Rathore on 01/08/20.
//  Copyright © 2020 Pranjal Rathore. All rights reserved.
//

import UIKit

protocol selectArea {
    func didTapChoice(name : String)
}

class GlobalSelectorViewController: UIViewController {
    
    var selectionDelegate : selectArea!
    
    @IBOutlet weak var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        containerView.layer.masksToBounds=true
        containerView.layer.cornerRadius = 20
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.black.cgColor
    }
    
    @IBAction func selectButton(_ sender: UIButton) {
        if sender.tag == 0{//global
            selectionDelegate.didTapChoice(name: "Global")
        }
        if sender.tag == 1{//africa
            selectionDelegate.didTapChoice(name: "Africa")
        }
        if sender.tag == 2{//asia
            selectionDelegate.didTapChoice(name: "Asia")
        }
        if sender.tag == 3{//aus
            selectionDelegate.didTapChoice(name: "Australia/Oceania")
        }
        if sender.tag == 4{//eur
            selectionDelegate.didTapChoice(name: "Europe")
        }
        if sender.tag == 5{//n ame
            selectionDelegate.didTapChoice(name: "North America")
        }
        if sender.tag == 6{//s ame
            selectionDelegate.didTapChoice(name: "South America")
        }
        dismiss(animated: true, completion: nil)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss(animated: true, completion: nil)
    }
    

}

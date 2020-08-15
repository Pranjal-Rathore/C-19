//
//  StateListViewController.swift
//  C-19
//
//  Created by Pranjal Rathore on 03/08/20.
//  Copyright © 2020 Pranjal Rathore. All rights reserved.
//

import UIKit

class StateListViewController: UIViewController , UITableViewDataSource , UITableViewDelegate {
    
    var cnf = 0
    var act=0
    var rec=0
    var dea=0
    var st = ""

    @IBOutlet weak var stateTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stateTable.delegate = self
        stateTable.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stateArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReIdentifier", for: indexPath)
        cell.textLabel?.text = stateArray[indexPath.row].state
        cell.detailTextLabel?.text = numberFormatterInt(i: stateArray[indexPath.row].confirmed)
        cell.detailTextLabel?.backgroundColor = .green
        cell.detailTextLabel?.layer.masksToBounds = true
        cell.detailTextLabel?.layer.cornerRadius = 10
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cnf = stateArray[indexPath.row].confirmed
        act = stateArray[indexPath.row].active
        rec = stateArray[indexPath.row].recovered
        dea = stateArray[indexPath.row].deaths
        st = stateArray[indexPath.row].state
        performSegue(withIdentifier: "goToDetailsState", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToDetailsState"{
            let destVC = segue.destination as! StateDetailsViewController
            destVC.c = cnf
            destVC.a = act
            destVC.r = rec
            destVC.d = dea
            destVC.st = st
        }
    }


}


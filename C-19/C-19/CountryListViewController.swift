//
//  CountryListViewController.swift
//  C-19
//
//  Created by Pranjal Rathore on 01/08/20.
//  Copyright © 2020 Pranjal Rathore. All rights reserved.
//

import UIKit

class CountryListViewController: UIViewController , UITableViewDelegate , UITableViewDataSource , UISearchBarDelegate{
    
//    let numeberFormatter = NumberFormatter()
//    numeberFormatter.numberStyle = .decimal
//    numeberFormatter.groupingSize = 3
//    numeberFormatter.secondaryGroupingSize = 2
    
    var cnf = 0
    var act = 0
    var rec = 0
    var dea = 0
    var co = ""
    var isSearchBar = false
    var searchArray : [country] = []

    @IBOutlet weak var myTable: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        myTable.delegate = self
        myTable.dataSource = self
        searchBar.delegate = self
        myTable.keyboardDismissMode = .onDrag
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearchBar{
            return searchArray.count
        }else{
            return countryArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reusableIdentifier", for: indexPath)
        if isSearchBar{
            cell.textLabel?.text = String(searchArray[indexPath.row].country)
            cell.detailTextLabel?.text = numberFormatterInt(i:searchArray[indexPath.row].cases)
        }
        else{
            cell.textLabel?.text = String(countryArray[indexPath.row].country)
            cell.detailTextLabel?.text = numberFormatterInt(i: countryArray[indexPath.row].cases)
        }
        cell.detailTextLabel?.backgroundColor = .red
        cell.detailTextLabel?.layer.masksToBounds = true
        cell.detailTextLabel?.layer.cornerRadius = 10
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isSearchBar{
            cnf = searchArray[indexPath.row].cases + searchArray[indexPath.row].todayCases
            act = searchArray[indexPath.row].active
            rec = searchArray[indexPath.row].recovered + searchArray[indexPath.row].todayRecovered
            dea = searchArray[indexPath.row].deaths + searchArray[indexPath.row].todayDeaths
            co = searchArray[indexPath.row].country
        }
        else{
            cnf = countryArray[indexPath.row].cases + countryArray[indexPath.row].todayCases
            act = countryArray[indexPath.row].active
            rec = countryArray[indexPath.row].recovered + countryArray[indexPath.row].todayRecovered
            dea = countryArray[indexPath.row].deaths + countryArray[indexPath.row].todayDeaths
            co = countryArray[indexPath.row].country
        }
        
        
        if isSearching == true{
            isSearching = false
            if isSearchBar{
                countryName = searchArray[indexPath.row].country
            }
            else{
                countryName = countryArray[indexPath.row].country
            }
            
            navigationController?.popViewController(animated: true)
        }
        else{
            performSegue(withIdentifier: "goToDetails", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToDetails"{
            let destVC = segue.destination as! DetailsViewController
            destVC.cont = co
            destVC.c = cnf
            destVC.a = act
            destVC.r = rec
            destVC.d = dea
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchArray=[]
        isSearchBar = true
        for t in countryArray{
            if t.country.contains(searchText){
                searchArray.append(t)
            }
        }
        if searchText.count<1{
            isSearchBar = false
        }
        DispatchQueue.main.async {
            self.myTable.reloadData()
        }
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearchBar = false
        searchBar.text = nil
        DispatchQueue.main.async {
            self.myTable.reloadData()
        }
        searchBar.endEditing(true)
    }
}

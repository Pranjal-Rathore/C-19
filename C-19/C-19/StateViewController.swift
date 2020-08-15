//
//  StateViewController.swift
//  C-19
//
//  Created by Pranjal Rathore on 03/08/20.
//  Copyright © 2020 Pranjal Rathore. All rights reserved.
//

import UIKit
import CoreLocation
import Network

var stateArray:[states]=[]
var stateName = "Maharashtra"
var isSearchingStates = false

class StateViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate  {

    @IBOutlet weak var infView: UIView!
    
    @IBOutlet weak var cLabel: UILabel!
    @IBOutlet weak var rLabel: UILabel!
    @IBOutlet weak var aLabel: UILabel!
    @IBOutlet weak var dLabel: UILabel!
    
    @IBOutlet weak var districtTable: UITableView!
    
    let locationManager = CLLocationManager()
    var area = ""
    var locality = ""
    var districtCount = 0
    var stateIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        infView.layer.masksToBounds = true
        infView.layer.cornerRadius = 10
        districtTable.layer.masksToBounds = true
        districtTable.layer.cornerRadius = 10
        districtTable.delegate=self
        districtTable.dataSource=self
        locationManager.delegate=self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.startUpdatingLocation()
        districtTable.allowsSelection = false
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            CLGeocoder().reverseGeocodeLocation(location) { (placemark, err) in
                if err != nil{
                    print(err)
                }else{
                    if let place = placemark?.last{
                        self.area = place.administrativeArea!
                        self.locality = place.locality!
                    }
                }
            }
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        monitorInternet()
    }
    
    func monitorInternet(){
        let monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied{
                self.getData()
            }
            else{
                print("No internet")
            }
        }
        let queue = DispatchQueue(label: "Network")
        monitor.start(queue: queue)
    }
    
    func getData(){
        stateArray = []
        if let url = URL(string: "https://api.covidindiatracker.com/state_data.json"){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, resp, err) in
                    if let inf = data{
                        let decoder = JSONDecoder()
                        do {
                            let decodableData = try decoder.decode([states].self, from: inf)
                            for d in decodableData{
                                stateArray.append(d)
                            }
                            for i in 0..<stateArray.count{
                                if stateArray[i].state == stateName{
                                    self.stateIndex = i
                                    self.districtCount = stateArray[i].districtData.count
                                    DispatchQueue.main.async {
                                        self.cLabel.text = numberFormatterInt(i: stateArray[i].confirmed)
                                        self.aLabel.text = numberFormatterInt(i: stateArray[i].active)
                                        self.rLabel.text = numberFormatterInt(i: stateArray[i].recovered)
                                        self.dLabel.text = numberFormatterInt(i: stateArray[i].deaths)
                                        self.navigationItem.title = stateName
                                        self.districtTable.reloadData()
                                    }

                                }
                            }
                        }catch{
                            print(error)
                        }
                    }
                }
            task.resume()
        }
    }
    
    @IBAction func unwindToStateView(_ unwindSegue: UIStoryboardSegue) {
        let sourceViewController = unwindSegue.source
        // Use data from the view controller which initiated the unwind segue
    }
    
    
    @IBAction func listButton(_ sender: UIBarButtonItem) {
    }
    

    @IBAction func locationButton(_ sender: UIBarButtonItem) {
        for s in stateArray{
            if s.id.contains(area){
                stateName = s.state
                getData()
            }
        }
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return districtCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RIdentifier", for: indexPath)
        
        if stateArray[stateIndex].districtData[indexPath.row].name == locality{
            cell.layer.masksToBounds = true
            cell.layer.cornerRadius = 10
            cell.backgroundColor = .systemGray2
        }
        else{
            cell.backgroundColor = .white
        }
        cell.textLabel?.text = stateArray[stateIndex].districtData[indexPath.row].name
        cell.detailTextLabel?.text = numberFormatterInt(i: stateArray[stateIndex].districtData[indexPath.row].confirmed)
        cell.detailTextLabel?.backgroundColor = .green
        cell.detailTextLabel?.layer.masksToBounds = true
        cell.detailTextLabel?.layer.cornerRadius = 10
        return cell
    }
    
    
}

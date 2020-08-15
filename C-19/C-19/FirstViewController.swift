//
//  FirstViewController.swift
//  C-19
//
//  Created by Pranjal Rathore on 28/07/20.
//  Copyright © 2020 Pranjal Rathore. All rights reserved.
//

import UIKit
import Charts
import Network

class FirstViewController: UIViewController {
    
    @IBOutlet weak var cLabel: UILabel!
    @IBOutlet weak var dcLabel: UILabel!
    @IBOutlet weak var rLabel: UILabel!
    @IBOutlet weak var drLabel: UILabel!
    @IBOutlet weak var dLabel: UILabel!
    @IBOutlet weak var ddLabel: UILabel!
    
    @IBOutlet weak var aLabel: UILabel!
    @IBOutlet weak var tLabel: UILabel!
    @IBOutlet weak var sLabel: UILabel!
    @IBOutlet weak var pLabel: UILabel!
    
    @IBOutlet weak var cpmLabel: UILabel!
    @IBOutlet weak var apmLabel: UILabel!
    @IBOutlet weak var rpmLabel: UILabel!
    @IBOutlet weak var dpmLabel: UILabel!
    @IBOutlet weak var spmLabel: UILabel!
    @IBOutlet weak var tpmLabel: UILabel!
    
    @IBOutlet weak var recoveryRateLabel: UILabel!
    
    
    @IBOutlet weak var confrimedView: UIView!
    @IBOutlet weak var recoveredView: UIView!
    @IBOutlet weak var deathView: UIView!
    @IBOutlet weak var recoveryRateView: UIView!
    @IBOutlet weak var pieChart: PieChartView!
    @IBOutlet weak var infView: UIView!
    @IBOutlet weak var perMilView: UIView!
    
    let u = "https://corona.lmao.ninja/v2/all?yesterday"
    let u2 = "https://disease.sh/v2/continents?yesterday=true&allowNull=true"
    var continentName = "Global"
    let cr:CGFloat = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        confrimedView.layer.masksToBounds=true
        confrimedView.layer.cornerRadius = cr
        recoveredView.layer.masksToBounds=true
        recoveredView.layer.cornerRadius = cr
        deathView.layer.masksToBounds=true
        deathView.layer.cornerRadius = cr
        recoveryRateView.layer.masksToBounds=true
        recoveryRateView.layer.cornerRadius = cr
        pieChart.layer.masksToBounds=true
        pieChart.layer.cornerRadius = cr
        infView.layer.masksToBounds=true
        infView.layer.cornerRadius = cr
        perMilView.layer.masksToBounds=true
        perMilView.layer.cornerRadius = cr
        monitorInternet()
        navigationItem.title = "Global"
        getDataGlobal(url: u)
    }
        func monitorInternet(){
            let monitor = NWPathMonitor()
            monitor.pathUpdateHandler = { path in
                if path.status == .unsatisfied{
                    print("NO INTERNET")
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "noInternet", sender: self)
                    }
                }
            }
            let queue = DispatchQueue(label: "Network")
            monitor.start(queue: queue)
        }
    
    @IBAction func changeButton(_ sender: Any) {
        performSegue(withIdentifier: "selectGlobalSegue", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selectGlobalSegue"{
            let destVC = segue.destination as! GlobalSelectorViewController
            destVC.selectionDelegate = self
        }
    }
    
    
    
    func getDataGlobal(url : String){
        if let url = URL(string: url){
        let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, resp, err) in
                if err != nil{
                    print(err)
                }
                else{
                    if let inf = data{
                        let decoder = JSONDecoder()
                        do{
                            let decodedData = try decoder.decode(global.self, from: inf)
                            DispatchQueue.main.async {
                                self.display(c: decodedData.cases, dc: decodedData.todayCases, r: decodedData.recovered, dr: decodedData.todayRecovered, d: decodedData.deaths, dd: decodedData.todayDeaths, a: decodedData.active, t: decodedData.tests, s: decodedData.critical, p: decodedData.population, cpm: decodedData.casesPerOneMillion, rpm: decodedData.recoveredPerOneMillion, apm: decodedData.activePerOneMillion, dpm: decodedData.deathsPerOneMillion, spm: decodedData.criticalPerOneMillion, tpm: decodedData.testsPerOneMillion)
                                self.createPieChart(cnf: decodedData.cases+decodedData.todayCases, rec: decodedData.recovered+decodedData.todayRecovered, dea: decodedData.deaths+decodedData.todayDeaths)
                            }
                        }catch{
                            print(error)
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
    func getDataContinent(url : String){
        if let url = URL(string: url){
        let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, resp, err) in
                if err != nil{
                    print(err)
                }
                else{
                    if let inf = data{
                        let decoder = JSONDecoder()
                        do{
                            let decodedData = try decoder.decode([continent].self, from: inf)
                            for d in decodedData{
                                if d.continent == self.continentName{
                                    DispatchQueue.main.async {
                                        self.display(c: d.cases, dc: d.todayCases, r: d.recovered, dr: d.todayRecovered, d: d.deaths, dd: d.todayDeaths, a: d.active, t: d.tests, s: d.critical, p: d.population, cpm: d.casesPerOneMillion, rpm: d.recoveredPerOneMillion, apm: d.activePerOneMillion, dpm: d.deathsPerOneMillion, spm: d.criticalPerOneMillion, tpm: d.testsPerOneMillion)
                                        self.createPieChart(cnf: d.cases+d.todayCases, rec: d.recovered+d.todayRecovered, dea: d.deaths+d.todayDeaths)
                                    }
                                }
                            }
                        }catch{
                            print(error)
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
    func display(c:Int,dc:Int,r:Int,dr:Int,d:Int,dd:Int,a:Int,t:Int,s:Int,p:Int,cpm:Double,rpm:Double,apm:Double,dpm:Double,spm:Double,tpm:Double){
        
        cLabel.text = numberFormatterInt(i: c)
        dcLabel.text = "daily increment: "+"+" + numberFormatterInt(i: dc)
        rLabel.text = numberFormatterInt(i: r)
        drLabel.text = "+" + numberFormatterInt(i: dr)
        dLabel.text = numberFormatterInt(i: d)
        ddLabel.text = "+" + numberFormatterInt(i: dd)
        aLabel.text = numberFormatterInt(i: a) 
        tLabel.text = numberFormatterInt(i: t)
        sLabel.text = numberFormatterInt(i: s)
        pLabel.text = numberFormatterInt(i: p)
        cpmLabel.text = numberFormatterDouble(d: cpm)
        rpmLabel.text = numberFormatterDouble(d: rpm)
        apmLabel.text = numberFormatterDouble(d: apm)
        dpmLabel.text = numberFormatterDouble(d: dpm)
        spmLabel.text = numberFormatterDouble(d: spm)
        tpmLabel.text = numberFormatterDouble(d: tpm)
        
        recoveryRateLabel.text = String((r+dr)*100/(c+dc)) + "%"
    }
    
    func createPieChart(cnf:Int,rec:Int,dea:Int){
        pieChart.backgroundColor = .white
        let a = PieChartDataEntry(value: Double(cnf))
        a.label = "confirmed"
        let b = PieChartDataEntry(value: Double(rec))
        b.label = "recovered"
        let c = PieChartDataEntry(value: Double(dea))
        c.label = "deaths"
        
        let pieChartEntries : [PieChartDataEntry] = [a,b,c]
        let pieChartSet = PieChartDataSet(entries: pieChartEntries, label: nil)
        pieChartSet.colors = [NSUIColor.blue,NSUIColor.green,NSUIColor.red]
        let pieChartData = PieChartData(dataSet: pieChartSet)
        pieChart.data = pieChartData
    }


}
extension FirstViewController : selectArea{
    func didTapChoice(name: String) {
        monitorInternet()
        navigationItem.title = name
        if name == "Global"{
            getDataGlobal(url: u)
        }
        else{
            continentName = name
            getDataContinent(url: u2)
        }
    }
}

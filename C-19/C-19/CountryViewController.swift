//
//  CountryViewController.swift
//  C-19
//
//  Created by Pranjal Rathore on 01/08/20.
//  Copyright © 2020 Pranjal Rathore. All rights reserved.
//

import UIKit
import Network
import Charts

var countryName = "India"
var countryArray : [country] = []
var isSearching : Bool = false

class CountryViewController: UIViewController, IAxisValueFormatter {
    
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
    
    
    var countryID = "IND"
    var dayArray:[countryGraph]=[]
    let calender = Calendar.current
    var dayCount = 7
    let cr : CGFloat = 10
    
    @IBOutlet weak var recoveryRateLabel: UILabel!
    @IBOutlet weak var confrimedView: UIView!
    @IBOutlet weak var recoveredView: UIView!
    @IBOutlet weak var deathView: UIView!
    @IBOutlet weak var recoveryRateView: UIView!
    @IBOutlet weak var infView: UIView!
    @IBOutlet weak var perMilView: UIView!
    
    
    @IBOutlet weak var StatsLabel: UILabel!
    @IBOutlet weak var lineChart: LineChartView!
    
    @IBOutlet weak var recDecLabel: UILabel!
    @IBOutlet weak var lineChart2: LineChartView!
    
    @IBOutlet weak var pieChart: PieChartView!
    
    @IBOutlet weak var lastUpdateLabel: UILabel!
    
    @IBAction func daysCount(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0{
            dayCount = 7
        }
        if sender.selectedSegmentIndex == 1{
            dayCount = 30
        }
        if sender.selectedSegmentIndex == 2{
            dayCount = 90
        }
        if sender.selectedSegmentIndex == 3{
            dayCount = dayArray.count
        }
        drawChart()
    }
    
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
        
        StatsLabel.layer.masksToBounds=true
        StatsLabel.layer.cornerRadius = cr
        StatsLabel.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMinYCorner]
        recDecLabel.layer.masksToBounds=true
        recDecLabel.layer.cornerRadius = cr
        recDecLabel.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMinYCorner]
        
        lineChart.layer.masksToBounds=true
        lineChart.layer.cornerRadius = cr
        lineChart.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMinXMaxYCorner]
        lineChart2.layer.masksToBounds=true
        lineChart2.layer.cornerRadius = cr
        lineChart2.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMinXMaxYCorner]
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
//        getData(url: "https://corona.lmao.ninja/v2/countries?yesterday=true&sort")
//        let loadingAlert = UIAlertController(title: nil, message: "loading..", preferredStyle: .alert)
//        present(loadingAlert, animated: true, completion: nil)
        monitorInternet()
    }
    func monitorInternet(){
        let monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied{
                self.getData(url: "https://corona.lmao.ninja/v2/countries?yesterday=true&sort")
//                let loadingAlert = UIAlertController(title: nil, message: "loading..", preferredStyle: .alert)
//                self.present(loadingAlert, animated: true, completion: nil)
            }
            else{
                print("No internet")
            }
        }
        let queue = DispatchQueue(label: "Network")
        monitor.start(queue: queue)
    }
    
    @IBAction func changeButton(_ sender: UIBarButtonItem) {
        isSearching = true
        performSegue(withIdentifier: "goToList", sender: self)
    }
    
    @IBAction func unwindToCountry(_ unwindSegue: UIStoryboardSegue) {
        let sourceViewController = unwindSegue.source
        // Use data from the view controller which initiated the unwind segue
    }
    

    func getData(url:String){
        countryArray = []
        if let url = URL(string: url){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, resp, err) in
                if let inf = data{
                    let decoder = JSONDecoder()
                    do{
                        let decodedData = try decoder.decode([country].self, from: inf)
                        for d in decodedData{
                            countryArray.append(d)
                        }
                        for d in decodedData{
                            if d.country == countryName{
                                DispatchQueue.main.async {
                                    self.display(c: d.cases, dc: d.todayCases, r: d.recovered, dr: d.todayRecovered, d: d.deaths, dd: d.todayDeaths, a: d.active, t: d.tests, s: d.critical, p: d.population, cpm: d.casesPerOneMillion, rpm: d.recoveredPerOneMillion, apm: d.activePerOneMillion, dpm: d.deathsPerOneMillion, spm: d.criticalPerOneMillion, tpm: d.testsPerOneMillion)
                                    self.navigationItem.title = countryName
                                    self.createPieChart(cnf: d.cases+d.todayCases, rec: d.recovered+d.todayRecovered, dea: d.deaths+d.todayDeaths)
                                    self.getGraphData(country: countryName)
                                }
                            }
                        }
                    }catch{
                        print(error)
                        print("no internet")
                    }
                }
            }
            task.resume()
        }
    }
    
    func getCountryID(name:String){
        for i in 0..<countryArray.count{
            if countryArray[i].country == name{
                countryID = countryArray[i].countryInfo.iso3 ?? "NULL"
            }
        }
    }
    
    func getGraphData(country:String){
        getCountryID(name: country)
        var url = "https://api.covid19api.com/total/country/" + countryID
        url = url.replacingOccurrences(of: " ", with: "%20")
        print(url)
        if let url = URL(string: url){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, resp, err) in
                if let inf = data{
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601
                    do {
                        let decodedData = try decoder.decode([countryGraph].self, from: inf)
                        for d in decodedData{
                            self.dayArray.append(d)
                        }
                        self.drawChart()
                        DispatchQueue.main.async {
                            self.showLastUpdate()
                            //self.dismiss(animated: true, completion: nil)
                        }
                    } catch {
                        print("error")
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
    
    func showLastUpdate(){
        let f = DateFormatter()
        f.dateFormat = "EEEE,MMM d-yyyy"
        lastUpdateLabel.text = "Last updated:" + f.string(from: dayArray.last!.Date)
    }
    
    func drawChart(){
        DispatchQueue.main.async {
            self.createChart()
        }
    }
        
    func createChart(){
        lineChart.xAxis.valueFormatter = self
        lineChart2.xAxis.valueFormatter = self
        
        var entriesConfirmed : [ChartDataEntry] = []
        var entriesDeaths : [ChartDataEntry] = []
        var entriesRecovered : [ChartDataEntry] = []
        var entriesActive : [ChartDataEntry] = []
        
        for i in dayArray.count-dayCount..<dayArray.count{
            entriesConfirmed.append(ChartDataEntry(x: Double(i),y: Double(dayArray[i].Confirmed)))
            entriesDeaths.append(ChartDataEntry(x: Double(i),y: Double(dayArray[i].Deaths)))
            entriesRecovered.append(ChartDataEntry(x: Double(i),y: Double(dayArray[i].Recovered)))
            entriesActive.append(ChartDataEntry(x: Double(i), y: Double(dayArray[i].Active)))
        }
        let setConfirmed = LineChartDataSet(entries: entriesConfirmed, label: "Confirmed")
        setConfirmed.drawCirclesEnabled = false
        setConfirmed.mode = .cubicBezier
        setConfirmed.setColor(.blue)
        setConfirmed.lineWidth = 4.0
        setConfirmed.fill = Fill(color: .blue)
        setConfirmed.fillAlpha = 0.2
        setConfirmed.drawFilledEnabled = true
        setConfirmed.setDrawHighlightIndicators(false)
        
        let setDeaths = LineChartDataSet(entries: entriesDeaths, label: "Deaths")
        setDeaths.drawCirclesEnabled=false
        setDeaths.mode = .cubicBezier
        setDeaths.setColor(.red)
        setDeaths.lineWidth = 4.0
        setDeaths.fill = Fill(color: .red)
        setDeaths.fillAlpha = 0.2
        setDeaths.drawFilledEnabled = true
        setDeaths.setDrawHighlightIndicators(false)
        
        let setRecovered = LineChartDataSet(entries: entriesRecovered, label: "Recovered")
        setRecovered.drawCirclesEnabled=false
        setRecovered.mode = .cubicBezier
        setRecovered.setColor(.green)
        setRecovered.lineWidth = 4.0
        setRecovered.fill = Fill(color: .green)
        setRecovered.fillAlpha = 0.2
        setRecovered.drawFilledEnabled = true
        setRecovered.setDrawHighlightIndicators(false)
        
        let setAcive = LineChartDataSet(entries: entriesActive, label: "Active")
        setAcive.drawCirclesEnabled=false
        setAcive.mode = .cubicBezier
        setAcive.setColor(.systemPurple)
        setAcive.lineWidth = 4.0
        setAcive.fill = Fill(color: .systemPurple)
        setAcive.fillAlpha = 0.2
        setAcive.drawFilledEnabled = true
        setAcive.setDrawHighlightIndicators(false)
        
        let set1 = [setConfirmed,setDeaths,setRecovered,setAcive]
        let data1 = LineChartData(dataSets: set1)
        lineChart.data = data1
        data1.setDrawValues(false)
        lineChart.xAxis.labelCount = 6
        lineChart.animate(xAxisDuration: 1)
        lineChart.xAxis.labelRotatedWidth = 50
        lineChart.xAxis.labelRotationAngle = -45
        lineChart.rightAxis.enabled = false
        lineChart.xAxis.labelPosition = .bottom
        lineChart.backgroundColor = .white
        
        let set2 = [setDeaths,setRecovered]
        lineChart2.data = LineChartData(dataSets: set2)
        lineChart2.xAxis.labelCount = 6
        lineChart2.animate(xAxisDuration: 1)
        lineChart2.xAxis.labelRotatedWidth = 50
        lineChart2.xAxis.labelRotationAngle = -45
        lineChart2.rightAxis.enabled = false
        lineChart2.xAxis.labelPosition = .bottom
        lineChart2.backgroundColor = .white
        
    }
    
    func createPieChart(cnf:Int,rec:Int,dea:Int){
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
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        var startDate = Date()
        startDate = DateComponents(calendar: calender, year: 2020, month: 1, day: 22).date!
        let formatter = DateFormatter()
        if dayCount == 7 || dayCount == 30{
            formatter.dateFormat = "dd/MM"
        }else{
            formatter.dateFormat = "MMMM"
        }
        var finalDate = calender.date(byAdding: .day, value: Int(value), to: startDate)!
        return formatter.string(from: finalDate)
    }
    
    
    
}

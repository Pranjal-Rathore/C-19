//
//  dataResponse.swift
//  C-19
//
//  Created by Pranjal Rathore on 31/07/20.
//  Copyright © 2020 Pranjal Rathore. All rights reserved.
//

import Foundation
//import Network

//func monitorInternet() -> Bool{
//    let monitor = NWPathMonitor()
//    var internetConnection = false
//    monitor.pathUpdateHandler = { path in
//        if path.status == .satisfied{
//            internetConnection = true
//            print(internetConnection)
//            print("aa")
//        }
//        else{
//            internetConnection = false
//            print(internetConnection)
//            print("bb")
//        }
//    }
//    let queue = DispatchQueue(label: "Network")
//    monitor.start(queue: queue)
//    //print(internetConnection)
//    return internetConnection
//}

func numberFormatterInt(i:Int) -> String {
    let numeberFormatter = NumberFormatter()
    numeberFormatter.numberStyle = .decimal
    numeberFormatter.groupingSize = 3
    numeberFormatter.secondaryGroupingSize = 2
    
    return numeberFormatter.string(from: NSNumber(value: i))!
}
func numberFormatterDouble(d:Double) -> String {
    let numeberFormatter = NumberFormatter()
    numeberFormatter.numberStyle = .decimal
    numeberFormatter.groupingSize = 3
    numeberFormatter.secondaryGroupingSize = 2
    
    return numeberFormatter.string(from: NSNumber(value: d))!
}

struct global : Decodable {
    
    let cases:Int
    let todayCases: Int
    let deaths: Int
    let todayDeaths: Int
    let recovered: Int
    let todayRecovered: Int
    let active: Int
    let critical: Int
    let casesPerOneMillion: Double
    let deathsPerOneMillion: Double
    let tests: Int
    let testsPerOneMillion: Double
    let population: Int
    let activePerOneMillion: Double
    let recoveredPerOneMillion: Double
    let criticalPerOneMillion: Double
    
}

struct continent : Decodable {
    
    let continent:String
    let cases:Int
    let todayCases: Int
    let deaths: Int
    let todayDeaths: Int
    let recovered: Int
    let todayRecovered: Int
    let active: Int
    let critical: Int
    let casesPerOneMillion: Double
    let deathsPerOneMillion: Double
    let tests: Int
    let testsPerOneMillion: Double
    let population: Int
    let activePerOneMillion: Double
    let recoveredPerOneMillion: Double
    let criticalPerOneMillion: Double
    
}


struct country : Decodable {
    
    let country:String
    let countryInfo:countryInfor
    let cases:Int
    let todayCases: Int
    let deaths: Int
    let todayDeaths: Int
    let recovered: Int
    let todayRecovered: Int
    let active: Int
    let critical: Int
    let casesPerOneMillion: Double
    let deathsPerOneMillion: Double
    let tests: Int
    let testsPerOneMillion: Double
    let population: Int
    let activePerOneMillion: Double
    let recoveredPerOneMillion: Double
    let criticalPerOneMillion: Double
    
}
struct countryInfor:Decodable {
    let iso3:String?
}

struct countryGraph : Decodable{
    let Country : String
    let Confirmed: Int
    let Deaths:Int
    let Active:Int
    let Recovered:Int
    let Date:Date
}


struct states:Decodable{
    let state : String
    let id : String
    let active:Int
    let recovered:Int
    let confirmed:Int
    let deaths:Int
    let districtData:[districts]
    
}

struct districts:Decodable{
    let name:String
    let confirmed:Int
}

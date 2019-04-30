//
//  Locations.swift
//  Swollmeights
//
//  Created by Matthew Reid on 7/29/18.
//  Copyright © 2018 Matthew Reid. All rights reserved.
//

import Foundation

class Locations {
    
    static var arrData = [[String]]()
    //static var dict = [[String: String]()]
    static var cityNames = [String]()
    static var counties = [String]()
    
    static func readDataFromCSV(fileName:String, fileType: String)-> String!{
        guard let filepath = Bundle.main.path(forResource: fileName, ofType: fileType)
            else {
                return nil
        }
        do {
            var contents = try String(contentsOfFile: filepath, encoding: .utf8)
            contents = cleanRows(file: contents)
            return contents
        } catch {
            print("File Read Error for file \(filepath)")
            return nil
        }
    }
    
    
    static func cleanRows(file:String)->String{
        var cleanFile = file
        cleanFile = cleanFile.replacingOccurrences(of: "\r", with: "\n")
        cleanFile = cleanFile.replacingOccurrences(of: "\n\n", with: "\n")
        //        cleanFile = cleanFile.replacingOccurrences(of: ";;", with: "")
        //        cleanFile = cleanFile.replacingOccurrences(of: ";\n", with: "")
        return cleanFile
    }

    static func csv(data: String) -> [[String]] {
        var result: [[String]] = []
//        let rows = data.components(separatedBy: "\n")
//        for row in rows {
//            let columns = row.components(separatedBy: ";")
//            result.append(columns)
//        }
        //return result
        let parsedCSV: [[String]] = data.components(separatedBy: "\n").map{ $0.components(separatedBy: ",") }

        return parsedCSV
    }
    
    static func getLocationData() {
        
        var data = readDataFromCSV(fileName: "locations", fileType: ".txt")
        data = cleanRows(file: data!)
        arrData = csv(data: data!)
    }
    
    static func getCityNames() {
        getLocationData()
        
        cityNames.removeAll()
        counties.removeAll()
        
        let defaults = UserDefaults.standard
        
        
        
        for i in 1...arrData.count-2 {
            cityNames.append("\(arrData[i][0]), \(arrData[i][1])")
            counties.append("\(arrData[i][2])")
        }
        defaults.set(cityNames, forKey: "cities")
        defaults.set(counties, forKey: "counties")
        defaults.synchronize()
    }
    
    static func retrieveData() {
        let defaults = UserDefaults.standard
        
        if (defaults.array(forKey: "counties") != nil || defaults.array(forKey: "cities") != nil) {
            Locations.getCityNames()
        }
        else {
            if (defaults.array(forKey: "counties") != nil && defaults.array(forKey: "cities") != nil) {
            self.counties = defaults.array(forKey: "counties") as! [String]
            self.cityNames = defaults.array(forKey: "cities") as! [String]
            }
        }
    }
}





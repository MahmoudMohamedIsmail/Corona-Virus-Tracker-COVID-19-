//
//  HelperFunctions.swift
//  Corona Virus Tracker (COVID-19)
//
//  Created by macboock pro on 5/9/20.
//  Copyright © 2020 macboock pro. All rights reserved.
//

import Foundation
struct HelperFunctions {
    //MARK: - Methods
    static func findSubString(string:String,subString:String) -> Bool {
        
        for inx in 0..<subString.count {
            if subString[subString.index(subString.startIndex, offsetBy: inx)] != string[string.index(string.startIndex, offsetBy: inx)]
            {
                return false
            }
            
        }
        return true
    }
    static func getMatchedCountries(cases:[Case],countryName:String) -> [Case] {
        var newCases:[Case]=[]
        
        for item in cases {
            
            if findSubString(string: item.country!, subString: countryName)
            {
                newCases.append(item)
            }
        }
        
        
        return newCases
    }
    
    static func getPrefixString(ForAllCountries cases:[Case]) -> [String:[Case]] {
        
        var prefix:[String:[Case]]=[:]
        
        for nCase in cases {
            if let countryName=nCase.country
            {
                var prefixString=""
                
                for index in 0..<countryName.count {
                    prefixString += [countryName[countryName.index(countryName.startIndex, offsetBy: index)]]
                    
                    var flag=true
                    if let _=prefix[prefixString]?.append(nCase)
                    {
                        flag=false
                    }
                    if flag
                    {
                        prefix[prefixString]=[]
                        prefix[prefixString]?.append(nCase)
                    }
                    
                }
                
            }
            
        }
        return prefix
    }
   static func findCountryByLocation(cases:[Case],lat:Double,long:Double) -> Case? {
        
        for foundedCase in cases {
            if foundedCase.countryInfo?.lat==lat && foundedCase.countryInfo?.long==long
            {
                return foundedCase
            }
        }
        return nil
    }
   static func dateFormat(date:Double) -> String {
         
         let newDate = Date(timeIntervalSince1970: date/1000.0)
         let dateFormat = DateFormatter()
         dateFormat.dateFormat = "MMMM dd, yyyy HH:mm:ss a"
         return dateFormat.string(from: newDate)
     }
   static func numberFormatToThousand(number:Int) -> String {
        
        let numberFormatter = NumberFormatter()
       // numberFormatter.numberStyle = .decimal         // Set defaults to the formatter that are common for showing decimal numbers
        numberFormatter.usesGroupingSeparator = true    // Enabled separator
        numberFormatter.groupingSeparator = ","         // Set the separator to "," (e.g. 1000000 = 1,000,000)
        numberFormatter.groupingSize = 3                // Set the digits between each separator
        
        return numberFormatter.string(for: number)!
    }
    
}

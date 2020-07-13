//
//  CoronaData.swift
//  Corona Virus Tracker (COVID-19)
//
//  Created by macboock pro on 5/6/20.
//  Copyright © 2020 macboock pro. All rights reserved.
//

import Foundation
import UIKit
//MARK: - CoronaDataDelegate
protocol CoronaDataDelegate {
    func didUpdateCoronaData( coronaCase: [Case])
    func didFailWithError(error: Error)
}

//MARK: - CoronaData (fetch data from server with URLSession)
struct CoronaData {
    
    let coronaDataURL="https://corona.lmao.ninja/v2/"
    var delegate:CoronaDataDelegate?
    var chek=true
    
    mutating func feachCoronaData(_ url:String) {
        if url == Constants.forCountries{
            chek=false
        }
        let newURL=coronaDataURL+url
        preformRequest(with: newURL)
    }

    func preformRequest(with url:String) {
        if let url=URL(string: url)
        {
            let session=URLSession(configuration: .default)
            let task=session.dataTask(with: url) { (data, response, error) in
                if let error=error
                {
                    self.delegate?.didFailWithError(error: error)
                    return
                }
                if let data=data
                {
                    
                    if let globalData=self.parseJSON(data: data)
                    {
                        
                        self.delegate?.didUpdateCoronaData(coronaCase: globalData)
                    }
                }
            }
            task.resume()
        }
        
    }
    
    func parseJSON(data:Data) -> [Case]? {
        do {
            //chek to handel given json data (for one case globl data)
            if chek{
                let decodedData=try JSONDecoder().decode(Case.self, from: data)
                var cases:[Case]=[]
                let newGlobalData=Case(todayCases: decodedData.todayCases, todayDeaths: decodedData.todayDeaths,updated: decodedData.updated, cases: decodedData.cases, deaths: decodedData.deaths, recovered: decodedData.recovered, active: decodedData.active, country: decodedData.country, countryInfo:decodedData.countryInfo)
                    cases.append(newGlobalData)
            
                return cases
                
            }
                //All countries
            else{
                let decodedData:[Case]=try JSONDecoder().decode([Case].self, from: data)
                var cases:[Case]=[]
                for eachCase in decodedData {
                    let newGlobalData=Case(todayCases: eachCase.todayCases, todayDeaths: eachCase.todayDeaths,updated: eachCase.updated, cases: eachCase.cases, deaths: eachCase.deaths, recovered: eachCase.recovered,active:eachCase.active, country: eachCase.country, countryInfo:eachCase.countryInfo)
                    cases.append(newGlobalData)
                }
                return cases
            }
            
        } catch let error{
            self.delegate?.didFailWithError(error: error)
            return nil
        }
        
    }
    
 

}

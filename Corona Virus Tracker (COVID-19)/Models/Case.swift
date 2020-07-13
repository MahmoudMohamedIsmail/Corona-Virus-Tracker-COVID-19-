//
//  Case.swift
//  Corona Virus Tracker (COVID-19)
//
//  Created by macboock pro on 5/6/20.
//  Copyright © 2020 macboock pro. All rights reserved.
//

import Foundation
//MARK: - Case
struct Case:Decodable {
    let todayCases:Int?
    let todayDeaths:Int?
    let updated:Double?
    let cases:Int?
    let deaths:Int?
    let recovered:Int?
    let active:Int?
    let country:String?
    let countryInfo:CountryInfo?
}

//MARK: - CountryInfo
struct CountryInfo:Decodable {
    let flag:String
    let lat:Double
    let long:Double
}

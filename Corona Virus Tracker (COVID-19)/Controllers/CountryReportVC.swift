//
//  CountryReportVC.swift
//  Corona Virus Tracker (COVID-19)
//
//  Created by macboock pro on 5/14/20.
//  Copyright © 2020 macboock pro. All rights reserved.
//

import UIKit
class CountryReportVC: UIViewController {
    //MARK: - Properties
    var countryCase:Case?
    @IBOutlet weak var titleName: UINavigationBar!
    @IBOutlet weak var circle1V: UIView!
    @IBOutlet weak var circle2V: UIView!
    @IBOutlet weak var circle3V: UIView!
    @IBOutlet weak var circle4V: UIView!
    @IBOutlet weak var circle5V: UIView!
    @IBOutlet weak var circle6V: UIView!
    @IBOutlet weak var lastUpdateLable: UILabel!
    @IBOutlet weak var casesLabel: UILabel!
    @IBOutlet weak var todayCasesLabel: UILabel!
    @IBOutlet weak var deathLabel: UILabel!
    @IBOutlet weak var todayDeathLabel: UILabel!
    @IBOutlet weak var activeLabel: UILabel!
    @IBOutlet weak var recoverdLabel: UILabel!
   //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        setRadiusForAllCircle()
        
    }
    //MARK: - Methods
    func setRadiusForAllCircle(){
        circle1V.layer.cornerRadius=circle1V.frame.size.height/2
        circle2V.layer.cornerRadius=circle2V.frame.size.height/2
        circle3V.layer.cornerRadius=circle3V.frame.size.height/2
        circle4V.layer.cornerRadius=circle4V.frame.size.height/2
        circle5V.layer.cornerRadius=circle5V.frame.size.height/2
        circle6V.layer.cornerRadius=circle6V.frame.size.height/2
        
    }
    func setCountryReport()
    {
        if let cases=countryCase?.cases
            ,let active=countryCase?.active
            ,let recoverd=countryCase?.recovered
            ,let death=countryCase?.deaths
            ,let countryName=countryCase?.country
            ,let todayCases=countryCase?.todayCases
            ,let todayDeaths=countryCase?.todayDeaths
            ,let updated=countryCase?.updated
        {
       lastUpdateLable.text=HelperFunctions.dateFormat(date:updated)
        casesLabel.text=HelperFunctions.numberFormatToThousand(number: cases)
        todayCasesLabel.text=HelperFunctions.numberFormatToThousand(number:todayCases)
        deathLabel.text=HelperFunctions.numberFormatToThousand(number: death)
        todayDeathLabel.text=HelperFunctions.numberFormatToThousand(number:todayDeaths)
        activeLabel.text=HelperFunctions.numberFormatToThousand(number: active)
        recoverdLabel.text=HelperFunctions.numberFormatToThousand(number:recoverd)
        titleName.topItem?.title=countryName
        }
       
    }
    //MARK: - Actions
    @IBAction func closeThisView(_ sender: Any) {
        self.removeFromParent()
        self.view.removeFromSuperview()
    }
}

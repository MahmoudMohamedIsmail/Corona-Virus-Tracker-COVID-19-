//
//  FirstViewController.swift
//  Corona Virus Tracker (COVID-19)
//
//  Created by macboock pro on 5/6/20.
//  Copyright © 2020 macboock pro. All rights reserved.
//

import UIKit

class GlobalDataViewController: UIViewController {
    
    //MARK: - Properties
    var coronaData = CoronaData()
    var timer=Timer()
    var imageNumber=1
    @IBOutlet weak var shakeVideo: UIImageView!
    @IBOutlet weak var loadingActivityIndView: UIActivityIndicatorView!
    @IBOutlet weak var updatedLable: UILabel!
    @IBOutlet weak var deathLable: UILabel!
    @IBOutlet weak var recoverdLable: UILabel!
    @IBOutlet weak var casesLable: UILabel!
   
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        coronaData.delegate = self
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        startLoadingActivityIndeView()
        coronaData.feachCoronaData(Constants.forWorld)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        imageNumber=1
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector:#selector(loadShakeVideo), userInfo: nil, repeats: true)
        
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        timer.invalidate()
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
           if motion == .motionShake
           {
               startLoadingActivityIndeView()
               coronaData.feachCoronaData(Constants.forWorld)
               
           }
       }
    //MARK: - Methods
    @objc func loadShakeVideo() {
        
        shakeVideo.image=UIImage(named: "shake\(imageNumber).png")
        //cycle
        imageNumber += 1
        imageNumber %= 7
        
    }
   
    func startLoadingActivityIndeView() {
        //loadingActivityIndView.hidesWhenStopped=false
        loadingActivityIndView.alpha=1
        loadingActivityIndView.startAnimating()
        updatedLable.text="----"
        casesLable.text="----"
        deathLable.text="----"
        recoverdLable.text="----"
        
    }
    func stopLoadingActivityIndeView(){
        loadingActivityIndView.stopAnimating()
        //loadingActivityIndView.hidesWhenStopped=true
         loadingActivityIndView.alpha=0
    }
}
//MARK: - CoronaDataDelegate
extension GlobalDataViewController :CoronaDataDelegate
{
    func didUpdateCoronaData( coronaCase: [Case])
    {
        DispatchQueue.main.async {
            if let cases=coronaCase[0].cases,let death=coronaCase[0].deaths,let recovered=coronaCase[0].recovered,let updated = coronaCase[0].updated
            {
                self.stopLoadingActivityIndeView()
               
                self.casesLable.text=HelperFunctions.numberFormatToThousand(number: cases)
                self.deathLable.text=HelperFunctions.numberFormatToThousand(number: death)
                self.recoverdLable.text=HelperFunctions.numberFormatToThousand(number: recovered)
                self.updatedLable.text=HelperFunctions.dateFormat(date: updated)
                
                
            }
            
        }
    }
    func didFailWithError(error: Error)
    {
        print(error.localizedDescription)
    }
}

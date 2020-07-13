//
//  CountriesCoronaCasesViewController.swift
//  Corona Virus Tracker (COVID-19)
//
//  Created by macboock pro on 5/12/20.
//  Copyright © 2020 macboock pro. All rights reserved.
//

import UIKit
import CoreLocation

class CountriesCoronaCasesViewController: UIViewController {
    //MARK: - Properties
    var coronaData = CoronaData()
    var countriesCases:[Case]=[]
    var tempCountriesCases:[Case]=[]
    let locationManger=CLLocationManager()
    @IBOutlet weak var countryCasesTable: UITableView!
    @IBOutlet weak var notFoundedLabel: UILabel!
    @IBOutlet weak var loadingActivityIndView: UIActivityIndicatorView!
    @IBOutlet weak var searchCountryNameText: UISearchBar!
   
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setDeldgates()
        locationManger.requestWhenInUseAuthorization()
        countryCasesTable.register(UINib(nibName: "dataCell", bundle: nil), forCellReuseIdentifier: Constants.identifier)
    }
    override func viewWillAppear(_ animated: Bool) {
           clearEditting()
           startLoadingActivityIndeView()
           coronaData.feachCoronaData(Constants.forCountries)
       }
       
     //MARK: - Actions
    @IBAction func locationPressed(_ sender: Any) {
        clearEditting()
        searchCountryNameText.isUserInteractionEnabled=false
        countriesCases=[]
        countryCasesTable.reloadData()
        startLoadingActivityIndeView()
        locationManger.requestLocation()
    }
   override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            view.endEditing(true)
        }
     
    //MARK: - Methods
    func setDeldgates() {
        searchCountryNameText.searchTextField.delegate=self
        locationManger.delegate=self
        coronaData.delegate = self
        searchCountryNameText.delegate=self
        countryCasesTable.delegate=self
        countryCasesTable.dataSource=self
    }
    func startLoadingActivityIndeView() {
        loadingActivityIndView.hidesWhenStopped=false
        loadingActivityIndView.startAnimating()
        
    }
    func stopLoadingActivityIndeView(){
        loadingActivityIndView.stopAnimating()
        loadingActivityIndView.hidesWhenStopped=true
    }
    func clearEditting(){
        searchCountryNameText.text=""
        notFoundedLabel.text=""
    }
}
//MARK: - tableView dataSource and delegte
extension   CountriesCoronaCasesViewController:UITableViewDataSource,UITableViewDelegate
{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countriesCases.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: Constants.identifier, for: indexPath) as! dataCell
        
        if let cases=countriesCases[indexPath.row].cases
            ,let active=countriesCases[indexPath.row].active
            ,let recoverd=countriesCases[indexPath.row].recovered
            ,let death=countriesCases[indexPath.row].deaths
            ,let countryName=countriesCases[indexPath.row].country
        {
            cell.activeLabel.text="Active: \(HelperFunctions.numberFormatToThousand(number: active))"
            cell.casesLabel.text="Cases: \(HelperFunctions.numberFormatToThousand(number: cases))"
            cell.recoverdLabel.text="Recovered: \(HelperFunctions.numberFormatToThousand(number: recoverd))"
            cell.deathLabel.text="Deaths: \(HelperFunctions.numberFormatToThousand(number: death))"
            cell.countryNameLabel.text="\(countryName)"
            cell.setImage(url: countriesCases[indexPath.row].countryInfo!.flag)
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        view.endEditing(true)
        showCountryReportAsSubView(index:indexPath.row)
    }
    func showCountryReportAsSubView(index:Int){
        let countryReportVC = storyboard!.instantiateViewController(withIdentifier:Constants.toCountryReportStoryboardID) as! CountryReportVC
        
        addChild(countryReportVC)
        view.addSubview(countryReportVC.view)
        countryReportVC.countryCase=countriesCases[index]
        countryReportVC.setCountryReport()
        countryReportVC.didMove(toParent: self)
    }
    
}
//MARK: - coronaData Delegate to trriger tableView to update its data
extension CountriesCoronaCasesViewController :CoronaDataDelegate
{
    func didUpdateCoronaData( coronaCase: [Case])
    {
        //To Help me to preform quick searsh
        //allPrefixCountriesName=F.getPrefixString(ForAllCountries: coronaCase)
        DispatchQueue.main.async {
            
            self.countriesCases=coronaCase.sorted(by: { (lhs, rhs) -> Bool in
                if let newLHS = lhs.cases,let newRHS = rhs.cases{
                    return newLHS > newRHS
                }
                else{
                    return false
                }
            })
            
            self.tempCountriesCases = self.countriesCases
            self.stopLoadingActivityIndeView()
            self.countryCasesTable.reloadData()
        }
    }
    func didFailWithError(error: Error)
    {
        print(error.localizedDescription)
    }
}
//MARK: - CllocationManagerDelegate (Get location)
extension CountriesCoronaCasesViewController:CLLocationManagerDelegate
{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location=locations.last
        {
            locationManger.stopUpdatingLocation()
            //let lat=location.coordinate.latitude as Double
            //let long=location.coordinate.longitude as Double
            
            let geocoder=CLGeocoder()
            geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
                if error != nil
                {
                    print("error in reverseGeocodeLocation")
                }
                let placemark=placemarks?.last
               
                if let country=placemark?.country
                {
                    self.stopLoadingActivityIndeView()
                    self.searchCountryNameText.isUserInteractionEnabled=true
                    self.searchCountryNameText.text=country
                    self.searchBar(self.searchCountryNameText, textDidChange:country)
                }
            }
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
}
//MARK: - searchBar delegate (Search and get country data)
extension CountriesCoronaCasesViewController:UISearchBarDelegate,UITextFieldDelegate
{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        countriesCases=tempCountriesCases.filter {
            ($0.country?
                .lowercased()
                .hasPrefix(searchText.lowercased()))!}
        countryCasesTable.reloadData()
        
        if countriesCases.count == 0
        {
            notFoundedLabel.text="Not founded"
        }
        else{
            notFoundedLabel.text=""
        }
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchCountryNameText.endEditing(true)
        clearEditting()
        countriesCases=tempCountriesCases
        countryCasesTable.reloadData()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        searchCountryNameText.endEditing(true)
        return true
    }
}

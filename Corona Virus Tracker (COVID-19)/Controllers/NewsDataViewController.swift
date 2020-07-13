//
//  NewsDataViewController.swift
//  Corona Virus Tracker (COVID-19)
//
//  Created by macboock pro on 5/11/20.
//  Copyright © 2020 macboock pro. All rights reserved.
//

import UIKit
import iOSDropDown
import SafariServices
class NewsDataViewController: UIViewController {
    //MARK: - Properties
    var start = NewsData()
    var news = News(articles: [])
    var queueNotCancelled = false
    var loadingImageOfNews:DispatchWorkItem?
    @IBOutlet weak var newsTable: UITableView!
    @IBOutlet weak var searchCountriesNameDropDown: DropDown!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        start.delegate=self
        newsTable.register(UINib(nibName: "newsCell", bundle: nil), forCellReuseIdentifier: Constants.identifier)
        loadCountryListInSearchBar()
        searchCountriesNameDropDown.didSelect { (countryName, index, id) in
            self.queueNotCancelled=true
            self.start.feachNewsData(Constants.countriesCode[countryName] ?? Constants.defultCountryName)
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        if searchCountriesNameDropDown.text != ""
        {
            start.feachNewsData(Constants.countriesCode[searchCountriesNameDropDown.text!] ?? Constants.defultCountryName)
        }
        else{
            start.feachNewsData(Constants.defultCountryName)
        }
        
    }
    
    func loadCountryListInSearchBar(){
        
        // The list of countries to display
        for key in Constants.countriesCode.keys {
            searchCountriesNameDropDown.optionArray.append(key)
        }
        
    }
}
//MARK: - tableView dataSource and delegte
extension   NewsDataViewController:UITableViewDataSource,UITableViewDelegate
{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.articles.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: Constants.identifier, for: indexPath) as! newsCell
        
        if let title=news.articles[indexPath.row].title,let date=news.articles[indexPath.row].publishedAt
        {
            //If url image not equal nil show Frist view with image
            if  let image=news.articles[indexPath.row].urlToImage
            {
                if queueNotCancelled
                {
                    if loadingImageOfNews?.isCancelled ?? true != true
                    {
                        loadingImageOfNews?.cancel()
                        queueNotCancelled=false
                    }
                    
                }
                loadingImageOfNews=DispatchWorkItem{
                    cell.setImage(url:image )
                    
                }
                loadingImageOfNews?.perform()
                
                cell.newsViewWithoutImage.isHidden=true
                cell.newsTitle.text=title
                cell.newsPublishedAt.text=String(date.prefix(10))
                let name=news.articles[indexPath.row].source.name ?? ""
                let author=news.articles[indexPath.row].author ?? name
                cell.newsAuthor.text=author
            }
            else
            {
                //If image url is nil show second view without image
                let name=news.articles[indexPath.row].source.name ?? ""
                let author=news.articles[indexPath.row].author ?? name
                cell.newsAuthorWithoutImage.text=author
                cell.newsTitleWithoutImage.text=title
                cell.newsPublishedAtWithoutImage.text=String(date.prefix(10))
                
            }
        }
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let url=news.articles[indexPath.row].url
        {
            if let newURL = URL(string:url)
            {
                let newsPage=SFSafariViewController(url:newURL)
                present(newsPage, animated: true)
            }else
            {
                makeAlert()
            }
            
        }else{
            makeAlert()
        }
    }
    func makeAlert() {
        let alert = UIAlertController(title: "Sorry!", message: "There is a problem in server.", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
//MARK: - NewsData Delegate to trriger tableView to update its data
extension NewsDataViewController:NewsDataDelegate
{
    func didUpdateNewsData(news: News) {
        
        DispatchQueue.main.async {
            
            self.news.articles=[]
            self.news.articles=news.articles
            self.newsTable.reloadData()
        }
    }
    func didFailWithError(error: Error)
    {
        print(error.localizedDescription)
    }
}

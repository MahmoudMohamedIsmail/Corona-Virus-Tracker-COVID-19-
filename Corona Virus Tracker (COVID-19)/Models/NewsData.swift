//
//  NewsData.swift
//  Corona Virus Tracker (COVID-19)
//
//  Created by macboock pro on 5/12/20.
//  Copyright © 2020 macboock pro. All rights reserved.
//

import Foundation
//MARK: - NewsDataDelegate
protocol NewsDataDelegate {
    func didUpdateNewsData( news: News)
    func didFailWithError(error: Error)
}

//MARK: - NewsData (fetch data from server with URLSession)
struct NewsData {
    
    var delegate:NewsDataDelegate?
    
    mutating func feachNewsData(_ url:String) {
        
        let newURL="http://newsapi.org/v2/top-headlines?country=\(url)&category=health&apiKey=c01288420fad4713925da9c27d8be21c"
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
                    
                    if let news=self.parseJSON(data: data)
                    {
                        
                        self.delegate?.didUpdateNewsData( news: news)
                    }
                }
            }
            task.resume()
        }
        
    }
    
    func parseJSON(data:Data) -> News? {
        do {
            
           
            let decodedData = try JSONDecoder().decode(News.self, from: data)
            var newData=News(articles: [])
            for article in decodedData.articles {
                newData.articles.append(article)
            }

            return newData
            
        } catch let error{
            self.delegate?.didFailWithError(error: error)
            return nil
        }
        
    }
    
    
}

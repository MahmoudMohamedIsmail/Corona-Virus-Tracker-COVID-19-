//
//  News.swift
//  Corona Virus Tracker (COVID-19)
//
//  Created by macboock pro on 5/12/20.
//  Copyright © 2020 macboock pro. All rights reserved.
//

import Foundation
//MARK: - News
struct News:Decodable {
    var articles:[Articles]
}
//MARK: - Articles
struct Articles:Decodable{
    var source:Source
    var author:String?
    var title:String?
    var description:String?
    var url:String?
    var urlToImage:String?
    var publishedAt:String?
}
//MARK: -   Source
struct Source:Decodable {
    var name:String?
}

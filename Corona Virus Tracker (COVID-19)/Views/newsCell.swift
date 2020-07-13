//
//  newsCell.swift
//  Corona Virus Tracker (COVID-19)
//
//  Created by macboock pro on 5/12/20.
//  Copyright © 2020 macboock pro. All rights reserved.
//

import UIKit

class newsCell: UITableViewCell {
    
    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var newsViewWithoutImage: UIView!
    @IBOutlet weak var newsPublishedAtWithoutImage: UILabel!
    @IBOutlet weak var newsTitle: UILabel!
    @IBOutlet weak var newsAuthorWithoutImage: UILabel!
    @IBOutlet weak var newsTitleWithoutImage: UILabel!
    @IBOutlet weak var newsAuthor: UILabel!
    @IBOutlet weak var newsPublishedAt: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    func setImage(url:String){
        
        DispatchQueue.global().async {
            if let newURL = URL(string: url)
            {
                if let data = try? Data(contentsOf: newURL)
                {
                    DispatchQueue.main.async {
                        self.newsImage.image=UIImage(data: data)
                    }
                }
            }
            
        }
        
    }
}

//
//  dataCell.swift
//  Corona Virus Tracker (COVID-19)
//
//  Created by macboock pro on 5/9/20.
//  Copyright © 2020 macboock pro. All rights reserved.
//

import UIKit

class dataCell: UITableViewCell {

    @IBOutlet weak var backgroundCell: UIView!
    @IBOutlet weak var flagImage: UIImageView!
    @IBOutlet weak var casesLabel: UILabel!
    @IBOutlet weak var recoverdLabel: UILabel!
    @IBOutlet weak var deathLabel: UILabel!
    @IBOutlet weak var activeLabel: UILabel!
    @IBOutlet weak var countryNameLabel: UILabel!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        backgroundCell.layer.cornerRadius=backgroundCell.frame.size.height/5
        flagImage.layer.cornerRadius=flagImage.frame.size.height/3
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setImage(url:String){
           
           DispatchQueue.global().async {
               let newURL = URL(string: url)
               let data = try? Data(contentsOf: newURL!)
          
            DispatchQueue.main.async {
                self.flagImage.image=UIImage(data: data!)
            }
            
           }
           
       }
}

//
//  ItemCell.swift
//  Passember
//
//  Created by Raghav Vashisht on 28/06/17.
//  Copyright © 2017 Raghav Vashisht. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {
    @IBOutlet weak var websiteLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var thumbImg: UIImageView!
    
    func configureCell(item: Item) {
        websiteLabel.text = item.websiteName
        usernameLabel.text = item.username
        //thumbImg.image = UIImage(named: "imagePick")
        
        
    }
    func getImage(path: String){
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: path){
            self.thumbImg.image = UIImage(contentsOfFile: path)
        }else{
            thumbImg.image = UIImage(named: "imagePick")
        }
    }
    
}

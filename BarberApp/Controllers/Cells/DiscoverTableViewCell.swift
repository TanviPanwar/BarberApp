//
//  DiscoverTableViewCell.swift
//  BarberApp
//
//  Created by iOS8 on 09/03/20.
//  Copyright © 2020 iOS8. All rights reserved.
//

import UIKit

class DiscoverTableViewCell: UITableViewCell {
    @IBOutlet weak var coverImgViw: UIImageView!
    @IBOutlet weak var ratingViw: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        coverImgViw.roundCorners(corners: [.topLeft, .topRight], radius: 15)
        ratingViw.roundCorners(corners: [.topRight, .bottomLeft], radius: 15)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
class ServiceCell: UICollectionViewCell {

    @IBOutlet weak var serviceNameLbl: UILabel!
    

}

class TimeSlotCell: UICollectionViewCell {
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var slotViw: UIView!
}

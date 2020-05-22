//
//  MyBarbersTableCell.swift
//  BarberApp
//
//  Created by iOS8 on 06/03/20.
//  Copyright © 2020 iOS8. All rights reserved.
//

import UIKit

class MyBarbersTableCell: UITableViewCell {
    
    @IBOutlet weak var seeAllBtn: UIButton!
    @IBOutlet weak var sectionLbl: UILabel!
    @IBOutlet weak var mybarbersCollectionViw: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

class MyBarbersCollectionCell: UICollectionViewCell {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var heightConstarint: NSLayoutConstraint!
    @IBOutlet weak var userImgViw: RoundedImageView!
    

}

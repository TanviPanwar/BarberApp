//
//  NearbyBarbersCell.swift
//  BarberApp
//
//  Created by iOS8 on 09/03/20.
//  Copyright © 2020 iOS8. All rights reserved.
//



import UIKit

class NearbyBarbersCell: UITableViewCell {
    
    @IBOutlet weak var userImgViw: RoundedImageView!
    @IBOutlet weak var ratingViw: UIView!
    @IBOutlet weak var barberNameLabel: UILabel!
    @IBOutlet weak var barberAddressLabel: UILabel!
    @IBOutlet weak var barberNationalityLabel: UILabel!
    @IBOutlet weak var openStatusLabel: UILabel!
    @IBOutlet weak var closeStatusLabel: UILabel!
    @IBOutlet weak var priceRangeLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ratingViw.roundCorners(corners: [.topRight,.bottomLeft], radius: 7)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

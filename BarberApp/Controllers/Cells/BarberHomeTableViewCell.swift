//
//  DriverHomeTableViewCell.swift
//  BarberApp
//
//  Created by iOS8 on 23/03/20.
//  Copyright © 2020 iOS8. All rights reserved.
//

import UIKit

class BarberHomeTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
class BarberBookingsTableViewCell: UITableViewCell {

    @IBOutlet weak var bookingStatusView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
class ButtonCollectionViewCell: UICollectionViewCell {


    @IBOutlet weak var buttonOutlet: UIButton!
}

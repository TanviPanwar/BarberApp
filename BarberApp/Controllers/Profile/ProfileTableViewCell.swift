//
//  ProfileTableViewCell.swift
//  BarberApp
//
//  Created by iOS6 on 21/05/20.
//  Copyright © 2020 iOS8. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var cellTitleBtn: UIButton!
    @IBOutlet weak var availabilityBtn: UISwitch!
    

    public var onTitleButtonTapped: (() ->Void)? = nil
    public var onAvailabilityButtonTapped: (() ->Void)? = nil

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func cellTitleBtnAction(_ sender: Any) {
        
        onTitleButtonTapped!()
    }
    
    @IBAction func availabilityBtnAction(_ sender: Any) {
        
        onAvailabilityButtonTapped!()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

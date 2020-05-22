//
//  AdditionalInfoTableViewCell.swift
//  BarberApp
//
//  Created by iOS6 on 14/05/20.
//  Copyright © 2020 iOS8. All rights reserved.
//

import UIKit

class AdditionalInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var deleteBtn: UIButton!
    
     public var onDeleteButtonTapped: (() ->Void)? = nil
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    @IBAction func deleteBtnAction(_ sender: Any) {
        
        onDeleteButtonTapped!()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//
//  AdditionalInfoCollectionViewCell.swift
//  BarberApp
//
//  Created by iOS6 on 19/03/20.
//  Copyright © 2020 iOS8. All rights reserved.
//

import UIKit

class AdditionalInfoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cellView: UIView!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var addBtn: UIButton!
    
    public var onAddButtonTapped: (() ->Void)? = nil
    
    
    
    @IBAction func addBtnAction(_ sender: Any) {
        
        onAddButtonTapped!()
        
    }
    
}

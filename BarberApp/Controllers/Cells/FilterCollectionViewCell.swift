//
//  FilterCollectionViewCell.swift
//  BarberApp
//
//  Created by iOS8 on 09/03/20.
//  Copyright © 2020 iOS8. All rights reserved.
//

import UIKit
import RangeSeekSlider
class FilterCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var outerViw: UIView!
    
    @IBOutlet weak var serviceNameLbl: UILabel!
}

class OptionsCollectionViewCell: UICollectionViewCell {
    
}

class PriceCollectionViewCell: UICollectionViewCell {
    
}
class DistanceCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var rangeSlider: RangeSeekSlider!
    
}
class SortCollectionViewCell: UICollectionViewCell {
    
}

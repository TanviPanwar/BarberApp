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
    
    @IBOutlet weak var serviceAtHomeSwitchBtn: UISwitch!
    
    @IBOutlet weak var openNowSwitchBtn: UISwitch!
    @IBOutlet weak var hasCreditCardSwitchBtn: UISwitch!
}

class PriceCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var maxPriceBtn: RoundedButton!
    @IBOutlet weak var mediumPriceBtn: RoundedButton!
    @IBOutlet weak var cheapPriceBtn: RoundedButton!
}
class DistanceCollectionViewCell: UICollectionViewCell {
 
    
    @IBOutlet weak var rangeSlider: RangeSeekSlider!
    
}
class SortCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var popularitySwitchBtn: UISwitch!
    @IBOutlet weak var ratingSwitchBtn: UISwitch!
    @IBOutlet weak var priceSwitchBtn: UISwitch!
}



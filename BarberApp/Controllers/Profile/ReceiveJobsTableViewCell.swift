//
//  ReceiveJobsTableViewCell.swift
//  BarberApp
//
//  Created by iOS6 on 23/03/20.
//  Copyright © 2020 iOS8. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class ReceiveJobsTableViewCell: UITableViewCell {

    @IBOutlet weak var serviceView: UIView!
    @IBOutlet weak var priceView: UIView!
    @IBOutlet weak var descView: UIView!
    @IBOutlet weak var serviceViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var priceViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var descreptionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var switchBtn: UISwitch!
    @IBOutlet weak var timeRangeTextField: UITextField!
    
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var serviceDescTextView: IQTextView!
    @IBOutlet weak var addDeleteBtn: UIButton!
    
    @IBOutlet weak var weekDayBtn: UIButton!
    
    public var onSwitchButtonTapped: (() ->Void)? = nil
    
     public var onAddDeleteButtonTapped: (() ->Void)? = nil
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    @IBAction func switchBtnAction(_ sender: Any) {
        
        onSwitchButtonTapped!()
    }
    
    
    
    @IBAction func addDeleteBtnAction(_ sender: Any) {
        
        onAddDeleteButtonTapped!()
    }
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//
//  BookingsTableViewCell.swift
//  BarberApp
//
//  Created by iOS6 on 17/03/20.
//  Copyright © 2020 iOS8. All rights reserved.
//

import UIKit

class BookingsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cellView: UIView!
    
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var monthDayLabel: UILabel!
    @IBOutlet weak var serviceTypeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var mainAddressLabel: UILabel!
    @IBOutlet weak var directionBtn: UIButton!
    @IBOutlet weak var payBtn: UIButton!
    @IBOutlet weak var delayBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var confirmedStatusStackView: UIStackView!
    @IBOutlet weak var doneStatusStackView: UIStackView!
    
    @IBOutlet weak var cancelStatusStackView: UIStackView!
    
    public var onDirectionButtonTapped: (() ->Void)? = nil
    public var onPayButtonTapped: (() ->Void)? = nil
    public var onDelayButtonTapped: (() ->Void)? = nil
    public var onCancelButtonTapped: (() ->Void)? = nil
    public var onReviewedButtonTapped: (() ->Void)? = nil
    public var onComplainButtonTapped: (() ->Void)? = nil
    public var onBookAgainButtonTapped: (() ->Void)? = nil
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        cellView.setBorder(width: 2, color: #colorLiteral(red: 0.9254090786, green: 0.9255421162, blue: 0.9253799319, alpha: 1))
        
        cellView.roundCorners(corners: [.allCorners], radius: 12)
        
        statusView.roundCorners(corners: [.bottomLeft], radius: 8)
        
    }
    
    @IBAction func directionBtnAction(_ sender: Any) {
        
        onDirectionButtonTapped!()
    }
    
    @IBAction func payBtnAction(_ sender: Any) {
        
        onPayButtonTapped!()
    }
    
    @IBAction func delayBtnAction(_ sender: Any) {
        
        onDelayButtonTapped!()
    }
    
    @IBAction func cancelBtnAction(_ sender: Any) {
        
        onCancelButtonTapped!()
    }
    
    @IBAction func reviewedBtnAction(_ sender: Any) {
        
        onReviewedButtonTapped!()
        
    }
    

    @IBAction func complainBtnAction(_ sender: Any) {
        
        onComplainButtonTapped!()
        
    }
    
    @IBAction func bookAgainBtnAction(_ sender: Any) {
        
        onBookAgainButtonTapped!()
        
    }
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
           super.setSelected(selected, animated: animated)

           // Configure the view for the selected state
       }
}


extension UIView {
    
    func setBorder(width:CGFloat , color :UIColor) {
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
        
    }
}

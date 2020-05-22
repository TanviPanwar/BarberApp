//
//  ComplainBookingViewController.swift
//  BarberApp
//
//  Created by iOS6 on 26/03/20.
//  Copyright © 2020 iOS8. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class ComplainBookingViewController: UIViewController {
    
    @IBOutlet weak var saloonDetailsLabel: UILabel!
      @IBOutlet weak var experienceTextView: IQTextView!
      @IBOutlet weak var submitBtn: RoundedButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - IB Actions
       
       @IBAction func submitBtnAction(_ sender: Any) {
           
           
       }

}

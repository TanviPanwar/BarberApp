//
//  ProfileNotificationsViewController.swift
//  BarberApp
//
//  Created by iOS6 on 19/03/20.
//  Copyright © 2020 iOS8. All rights reserved.
//

import UIKit

class ProfileNotificationsViewController: UIViewController {
    
    
    @IBOutlet weak var reminderPushNotificationSwitchBtn: UISwitch!
      @IBOutlet weak var reminderEmailNotificationSwitchBtn: UISwitch!
      @IBOutlet weak var promosPushNotificationSwitchBtn: UISwitch!
    @IBOutlet weak var promosEmailNotificationSwitchBtn: UISwitch!
    @IBOutlet weak var promosTextMsgNotificationSwitchBtn: UISwitch!
    @IBOutlet weak var promosPhoneCallsNotificationSwitchBtn: UISwitch!
    
    
    
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
       
       @IBAction func backBtnAction(_ sender: Any) {
           
         //  self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)

       }
       
       @IBAction func saveNtnAction(_ sender: Any) {
        
        
       }
       
    
    @IBAction func reminderPushNotificationBtnAction(_ sender: Any) {
    }
    
    
    @IBAction func reminderEmailNotificationBtnAction(_ sender: Any) {
      }
      
    @IBAction func promosPushNotificationBtnAction(_ sender: Any) {
      }
      

    @IBAction func promosEmailNotificationBtnAction(_ sender: Any) {
      }
    
    @IBAction func promosTextMsgNotificationBtnAction(_ sender: Any) {
         }
      
    
    @IBAction func promosPhoneCallsNotificationBtnAction(_ sender: Any) {
         }
}

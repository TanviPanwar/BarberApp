//
//  HelpViewController.swift
//  BarberApp
//
//  Created by iOS8 on 19/03/20.
//  Copyright © 2020 iOS8. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import Alamofire

class HelpViewController: UIViewController, UITextViewDelegate {
    
    
    @IBOutlet weak var reservationSwtchBtn: UISwitch!
    @IBOutlet weak var barberSwtchBtn: UISwitch!
    @IBOutlet weak var accountSwtchBtn: UISwitch!
    @IBOutlet weak var paymentsSwtchBtn: UISwitch!
    @IBOutlet weak var somethingElseSwtchBtn: UISwitch!
    @IBOutlet weak var helpTextView: IQTextView!
    
    var contactReason = String()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    // MARK: - TextView Delegates

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {

           if textView == helpTextView {
               let maxLength = 500
               let currentString: NSString = textView.text! as NSString
               let newString: NSString =
                   currentString.replacingCharacters(in: range, with: text) as NSString
               return newString.length <= maxLength

           }

           return true


       }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func reservationSwitchBtnAction(_ sender: Any) {
        
        if reservationSwtchBtn.isOn {
            
            reservationSwtchBtn.isOn = true
            barberSwtchBtn.isOn = false
            accountSwtchBtn.isOn = false
            paymentsSwtchBtn.isOn = false
            somethingElseSwtchBtn.isOn = false
            contactReason = "Reservations"
            
            
        } else {
            
            reservationSwtchBtn.isOn = false
            
            
        }
        
    }
    
    @IBAction func becomingBarberSwitchBtnAction(_ sender: Any) {
        
        if barberSwtchBtn.isOn {
            
            reservationSwtchBtn.isOn = false
            barberSwtchBtn.isOn = true
            accountSwtchBtn.isOn = false
            paymentsSwtchBtn.isOn = false
            somethingElseSwtchBtn.isOn = false
            contactReason = "Becoming a Barber"

            
            
        } else {
            
            barberSwtchBtn.isOn = false
            
            
        }
        
        
        
    }
    
    @IBAction func accountSwitchBtnAction(_ sender: Any) {
        
        if accountSwtchBtn.isOn {
            
            reservationSwtchBtn.isOn = false
            barberSwtchBtn.isOn = false
            accountSwtchBtn.isOn = true
            paymentsSwtchBtn.isOn = false
            somethingElseSwtchBtn.isOn = false
            contactReason = "My Ihlaq Account"

            
            
        } else {
            
            accountSwtchBtn.isOn = false
            
            
        }
        
    }
    
    @IBAction func paymentSwitchBtnAction(_ sender: Any) {
        
        if paymentsSwtchBtn.isOn {
            
            reservationSwtchBtn.isOn = false
            barberSwtchBtn.isOn = false
            accountSwtchBtn.isOn = false
            paymentsSwtchBtn.isOn = true
            somethingElseSwtchBtn.isOn = false
            contactReason = "Payments and Refunds"

            
            
        } else {
            
            paymentsSwtchBtn.isOn = false
            
            
        }
        
    }
    
    @IBAction func somethingElseSwitchBtnAction(_ sender: Any) {
        
        if somethingElseSwtchBtn.isOn {
            
            reservationSwtchBtn.isOn = false
            barberSwtchBtn.isOn = false
            accountSwtchBtn.isOn = false
            paymentsSwtchBtn.isOn = false
            somethingElseSwtchBtn.isOn = true
            contactReason = "It's something else"

            
            
        } else {
            
            somethingElseSwtchBtn.isOn = false
            
            
        }
        
    }
    
    @IBAction func submitBtnAction(_ sender: Any) {
        
        helpApi()
        
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK:- Api Methods
    
    
    func helpApi()
    {
        if ProjectManager.sharedInstance.isInternetAvailable()
        {
            if let apiToken = UserDefaults.standard.value(forKey: DefaultsIdentifier.apiToken) as? String {
                
                // if apiToken != nil {
                
                let help = (helpTextView.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
                
                DispatchQueue.main.async {
                    ProjectManager.sharedInstance.showLoader(vc: self)
                }
                
                let params = ["contact_reason":contactReason,
                              "message":help,
                              "ip_address":"192.168.25.202"] as [String: Any]
                
                let headers = [
                    "Authorization": "Bearer " + apiToken]
                
                //"Accept": "application/json"
                print(headers)
                
                Alamofire.request(Base_Url+HelpUrl , method: .post,  parameters: params, encoding: URLEncoding.default, headers:headers)
                    .responseJSON { response in
                        
                        ProjectManager.sharedInstance.stopLoader()
                        // check for errors
                        guard response.result.error == nil else {
                            // got an error in getting the data, need to handle it
                            print("error calling GET on /todos/1")
                            print(response.result.error!)
                            return
                        }
                        print(response.result.value!)
                        // make sure we got some JSON since that's what we expect
                        guard let json = response.result.value as? [String: Any] else {
                            print("didn't get todo object as JSON from API")
                            if let error = response.result.error {
                                print("Error: \(error)")
                            }
                            return
                        }
                        print(json)
                        let status = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"status", dict: json as NSDictionary)
                        let msg = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"message", dict: json as NSDictionary)
                        if status.boolValue {
                            
                            self.navigationController?.popViewController(animated: true)

                            
                            
                        } else {
                            
                            DispatchQueue.main.async {
                                ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc: msg as String, vc: self)
                                
                                
                            }
                        }
                }
                
            }
            
        }
            
        else {
            DispatchQueue.main.async(execute: {
                
                ProjectManager.sharedInstance.showAlertwithTitle(title: "Internet connection lost", desc: "Please check your internet connection.", vc: self)
            })
        }
        
    }
    
}

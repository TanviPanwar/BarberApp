//
//  MobileViewController.swift
//  BarberApp
//
//  Created by iOS8 on 06/03/20.
//  Copyright © 2020 iOS8. All rights reserved.
//

import UIKit
import MRCountryPicker
import Alamofire


class MobileViewController: UIViewController {
    @IBOutlet weak var flag_ImgViw: UIImageView!
    
    @IBOutlet weak var mobile_TxtFld: UITextField!
    @IBOutlet weak var countrycode_Lbl: UILabel!
    @IBOutlet weak var countryPicker: MRCountryPicker!
    @IBOutlet weak var pickerContainerView: UIView!
    
    var countryCode = String()
    var flagImg = UIImage()
    var launchBool = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        countryPicker.tintColor = .black
        countryPicker.countryPickerDelegate = self
        countryPicker.showPhoneNumbers = true
        countryPicker.setCountry("SI")
        countryPicker.setCountryByName("Canada")
        countrycode_Lbl.text =  "+1"
        flag_ImgViw.image = #imageLiteral(resourceName: "CA")
        // Do any additional setup after loading the view.
    }
    
    //MARK:-
    //MARK:- IBAction Methods
    
    @IBAction func goTonextScreenBtnAction(_ sender: Any) {
        
        otpApi()
        
    }
    
    
    @IBAction func toolbar_Actions(_ sender: UIButton) {
        self.view.endEditing(true)
        UIView.animate(withDuration: 0.3, animations: {
            self.pickerContainerView.isHidden = !self.pickerContainerView.isHidden
            
            if sender.tag == 1 {
                self.countrycode_Lbl.text = self.countryCode
                self.flag_ImgViw.image = self.flagImg
            }
        })
        
        
    }
    @IBAction func back_Action(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    @IBAction func country_dropdown_Action(_ sender: Any) {
        
        UIView.animate(withDuration: 0.3, animations: {
            self.pickerContainerView.isHidden = !self.pickerContainerView.isHidden
        })
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    // MARK: - Api Methods
    
    
    func otpApi()
    {
        if ProjectManager.sharedInstance.isInternetAvailable()
        {
            
            let mobile = (mobile_TxtFld.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
            let countryCode = (countrycode_Lbl.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
            
            
            if mobile.isEmpty {
                
                ProjectManager.sharedInstance.showAlertwithTitle(title: "Alert!", desc: "Please enter phone number.", vc: self)
                //
                
                //                let alertController =  UIAlertController(title:"Alert!" , message: "Please enter phone number.", preferredStyle: .alert)
                //                let okAction = UIAlertAction(title:"Ok", style: .cancel)
                //
                //
                //                alertController.addAction(okAction)
                //                self.present(alertController, animated: true, completion:nil)
                
                
            } else if mobile.count < 8 {
                
                ProjectManager.sharedInstance.showAlertwithTitle(title: "Alert!", desc: "Phone number should be atleast 8 characters minimum.", vc: self)
                
                //                let alertController =  UIAlertController(title:"Alert!" , message: "Phone number should be atleast 8 characters minimum.", preferredStyle: .alert)
                //                               let okAction = UIAlertAction(title:"Ok", style: .cancel)
                //
                //
                //                               alertController.addAction(okAction)
                //                               self.present(alertController, animated: true, completion:nil)
                
                
            }
                //            else if mobile.count >= 9 {
                //
                //                    let alertController =  UIAlertController(title:"Alert!" , message: "Phone number should be  8 characters .", preferredStyle: .alert)
                //                                   let okAction = UIAlertAction(title:"Ok", style: .cancel)
//
//
//                                   alertController.addAction(okAction)
//                                   self.present(alertController, animated: true, completion:nil)
//
//
//                }
            
            
            else {

            let params = ["phone_number":mobile , "country_code":countryCode] as [String: Any]
            print(params)
            DispatchQueue.main.async {
                
                      ProjectManager.sharedInstance.showLoader(vc: self)
                      
                
            }
            
            Alamofire.request(Base_Url+otpUrl, method: .post,  parameters: params, encoding: URLEncoding.default, headers:nil)
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
                        
                        if let response = json["data"] as? [String: Any]  {
                            
                            let objc = ProjectManager.sharedInstance.GetLoginObjects(dict: response)
                            
                            let mainStoryBoard =  UIStoryboard(name:"Main", bundle: nil)
                            if #available(iOS 13.0, *) {
                                
                                let vc = mainStoryBoard.instantiateViewController(identifier: "OtpVerificationController") as! OtpVerificationController
                                
                                vc.objc = objc
                                vc.launchBool = true
                                self.navigationController?.pushViewController(vc, animated: true)
                                
                            } else {
                                // Fallback on earlier versions
                                
                                let vc = mainStoryBoard.instantiateViewController(withIdentifier: "OtpVerificationController") as! OtpVerificationController
                                
                                vc.objc = objc
                                vc.launchBool = true

                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                            
                            
                        }
   
                    }
                    else {
                        
                        DispatchQueue.main.async {
                            ProjectManager.sharedInstance.showServerError(viewController: self)
                            
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


extension MobileViewController:MRCountryPickerDelegate
{
    
    func countryPhoneCodePicker(_ picker: MRCountryPicker, didSelectCountryWithName name: String, countryCode: String, phoneCode: String, flag: UIImage) {
        //self.countryCode.text = countryCode
        self.countryCode = phoneCode
        self.flagImg = flag
    }
}

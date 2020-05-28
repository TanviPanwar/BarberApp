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


class MobileViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var flag_ImgViw: UIImageView!
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var mobile_TxtFld: UITextField!
    @IBOutlet weak var countrycode_Lbl: UILabel!
    @IBOutlet weak var countryPicker: MRCountryPicker!
    @IBOutlet weak var pickerContainerView: UIView!
    @IBOutlet weak var countryDropdownBtn: UIButton!
    @IBOutlet weak var lineLabel: UILabel!
    @IBOutlet weak var alertLabel: UILabel!
    var charset = CharacterSet()
    
    
    var countryCode = String()
    var flagImg = UIImage()
    var launchBool = Bool()
    var LogoutBool = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if LogoutBool {
            
            backBtn.isHidden = true
            
        } else {
            
            backBtn.isHidden = true
            

        }
        
         charset = CharacterSet(charactersIn: "3, 5 ,6 ,7")
         
        
        countryPicker.tintColor = .black
        countryPicker.countryPickerDelegate = self
        countryPicker.showPhoneNumbers = true
        countryPicker.setCountry("SI")
        countryPicker.setCountryByName("Qatar")
        countrycode_Lbl.text =  "+974"
        flag_ImgViw.image = #imageLiteral(resourceName: "qatar-flag-round-small")
        countryDropdownBtn.isEnabled = false
        // Do any additional setup after loading the view.
    }
    
    
    // MARK: - TextField Delegates

      func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
          
        lineLabel.backgroundColor = #colorLiteral(red: 0.05882352941, green: 0.2980392157, blue: 0.5058823529, alpha: 1)
        alertLabel.isHidden = true
          if textField == mobile_TxtFld {
              let maxLength = 8
              let currentString: NSString = textField.text! as NSString
              let newString: NSString =
                  currentString.replacingCharacters(in: range, with: string) as NSString
              return newString.length <= maxLength
              
          }
        
        return true
           
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        lineLabel.backgroundColor = #colorLiteral(red: 0.05882352941, green: 0.2980392157, blue: 0.5058823529, alpha: 1)
        alertLabel.isHidden = true
   
        
    }
    
    
    
    //MARK:-
    //MARK:- IBAction Methods
    
    @IBAction func goTonextScreenBtnAction(_ sender: Any) {
        
        let mobile = mobile_TxtFld.text?.prefix(1)
        
        if mobile_TxtFld.text!.isEmpty {
            
            lineLabel.backgroundColor = #colorLiteral(red: 0.8862745098, green: 0.1887762642, blue: 0.1555743321, alpha: 1)
            alertLabel.isHidden = false
            alertLabel.text = "Please enter phone number."
           
            
            
        } else if mobile_TxtFld.text!.count < 8 {
            
            
            lineLabel.backgroundColor = #colorLiteral(red: 0.8862745098, green: 0.1887762642, blue: 0.1555743321, alpha: 1)
            alertLabel.isHidden = false
            alertLabel.text = "Phone number should be atleast 8 characters."
            
            
            
            
        } else if mobile!.rangeOfCharacter(from: charset) == nil {

            lineLabel.backgroundColor = #colorLiteral(red: 0.8862745098, green: 0.1887762642, blue: 0.1555743321, alpha: 1)
            alertLabel.isHidden = false
            alertLabel.text = "Phone number must start with 3,5,6,7 only."
        }
        
        
        else {
        
        
           otpApi()
            
        }
        
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

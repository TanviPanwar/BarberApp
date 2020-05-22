//
//  OtpVerificationController.swift
//  BarberApp
//
//  Created by iOS8 on 06/03/20.
//  Copyright © 2020 iOS8. All rights reserved.
//

import UIKit
import Alamofire

class OtpVerificationController: UIViewController {
    
    @IBOutlet weak var resend_Btn: UIButton!
    @IBOutlet weak var otpTxtFld: PinCodeTextField!
    @IBOutlet weak var resendCountdownLbl: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    var timer :Timer?
    var time:Int = 60
    var objc = LoginObject()
    var launchBool = Bool()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        otpTxtFld.underlineWidth = (UIScreen.main.bounds.size.width - 120)/4
        otpTxtFld.underlineHSpacing = 20
        otpTxtFld.font = UIFont(name:"Avenir-Medium", size: 20)!
        otpTxtFld.keyboardType = .numberPad
        titleLabel.text = "Please enter the 4 digit code sent to you at" + " " + objc.country_code + " " + objc.phone_number
        otpTxtFld.text = objc.otp
        timer = Timer.scheduledTimer(timeInterval:1.0, target: self, selector: #selector(onTick), userInfo: nil, repeats: true)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        timer?.fire()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
    }
    
    
    
    // MARK: - Custom Methods
    
    @objc func onTick()  {
        time =  time - 1
        if time < 0 {
            self.timer?.invalidate()
            self.resend_Btn.isHidden = false
            self.resendCountdownLbl.isHidden = true
            
        } else {
            
            self.resendCountdownLbl.text = "Resend code in 0:\(time)"
        }
        
        
        
    }
    
 // MARK: - IB Actions
    
    
    @IBAction func back_Action(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func gotToNextScreenAction(_ sender: Any) {
        
//        let mainStoryBoard =  UIStoryboard(name:"Main", bundle: nil)
//        let vc = mainStoryBoard.instantiateViewController(identifier: "TabBarVcViewController") as! TabBarVcViewController
//        //vc.objc = objc
//        self.navigationController?.pushViewController(vc, animated: true)
        
        LoginApi()
        
    }
    
    @IBAction func resendBtnAction(_ sender: Any) {
        
        resendOtpApi()
        
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
    
    
    func resendOtpApi()
    {
        if ProjectManager.sharedInstance.isInternetAvailable()
        {
            
            let params = ["phone_number":objc.phone_number , "country_code":objc.country_code] as [String: Any]
            print(params)
            DispatchQueue.main.async {
                
                  ProjectManager.sharedInstance.showLoader(vc: self)
            }
            
            Alamofire.request(Base_Url+otpResendUrl, method: .post,  parameters: params, encoding: URLEncoding.default, headers:nil)
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
                        
                        let obj = ProjectManager.sharedInstance.GetLoginObjects(dict: response)
                        
                        self.otpTxtFld.text = obj.otp
                        
                        self.resend_Btn.isHidden = true
                        self.resendCountdownLbl.isHidden = false

                        self.time = 60
                        self.timer = Timer.scheduledTimer(timeInterval:1.0, target: self, selector: #selector(self.onTick), userInfo: nil, repeats: true)
                        self.timer?.fire()
                            
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
    
    
    func LoginApi()
    {
        if ProjectManager.sharedInstance.isInternetAvailable()
        {
            
            let otp = otpTxtFld.text?.trimmingCharacters(in: CharacterSet.whitespaces)
            
            let params = ["phone_number":objc.phone_number , "country_code":objc.country_code, "device_type":"ios",
                          "device_token":"93845072398454asjhhsdakjfhjasdhfkajsdf368",
                          "otp":otp!,"user_lat":"30.7333","user_lon":"76.7794","ip_address":"192.168.25.202"] as [String: Any]
            print(params)
            DispatchQueue.main.async {
                ProjectManager.sharedInstance.showLoader(vc: self)
            }
            
            Alamofire.request(Base_Url+loginUrl, method: .post,  parameters: params, encoding: URLEncoding.default, headers:nil)
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
                            
                            print(response)
                            let objc = ProjectManager.sharedInstance.GetLoginDataObjects(dict: response)
                            
                            
                            UserDefaults.standard.set(objc.api_token, forKey: DefaultsIdentifier.apiToken)
                            
                            let mainStoryBoard =  UIStoryboard(name:"Main", bundle: nil)
                            if #available(iOS 13.0, *) {
                                let vc = mainStoryBoard.instantiateViewController(identifier: "TabBarVcViewController") as! TabBarVcViewController
                                vc.launchBool = true
                                
                                let homeVC = vc.viewControllers?[0] as! HomeViewController
                                homeVC.objc = objc
                                
                                
                                // vc.objc = objc
                                self.navigationController?.pushViewController(vc, animated: true)
                                
                                
                            } else {
                                // Fallback on earlier versions
                                
                                let vc = mainStoryBoard.instantiateViewController(withIdentifier: "TabBarVcViewController") as! TabBarVcViewController
                                vc.launchBool = true

                                let homeVC = vc.viewControllers?[0] as! HomeViewController
                                homeVC.objc = objc
                                
                                
                                // vc.objc = objc
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                            
                            
                            
                        }
                        
                    }
                    else {
                        
                       
                                                  
//                                                  let mainStoryBoard =  UIStoryboard(name:"Main", bundle: nil)
//                                                  let vc = mainStoryBoard.instantiateViewController(identifier: "TabBarVcViewController") as! TabBarVcViewController
//                                                  //vc.objc = objc
//                                                  self.navigationController?.pushViewController(vc, animated: true)
                        
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

//
//  ThankYouViewController.swift
//  BarberApp
//
//  Created by iOS6 on 27/03/20.
//  Copyright © 2020 iOS8. All rights reserved.
//

import UIKit
import Alamofire

class ThankYouViewController: UIViewController {
    
    var freelanceBool = Bool()


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
    
    
    @IBAction func doneBtnAction(_ sender: Any) {
        
        
//        self.dismiss(animated: true, completion: nil)
        
        
        getStatusApi()
        
       // self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)

    }
    
    // MARK:- Api Methods
    
    
         
    func getStatusApi()
    {
        if ProjectManager.sharedInstance.isInternetAvailable()
        {
            if let apiToken = UserDefaults.standard.value(forKey: DefaultsIdentifier.apiToken) as? String {
                
                // if apiToken != nil {
                
                
                
                DispatchQueue.main.async {
                    ProjectManager.sharedInstance.showLoader(vc: self)
                }
                
                var serviceType = String()
                if freelanceBool {
                    
                    serviceType = "0"
                    
                } else {
                    
                    serviceType = "4"
                }
                
                let param = ["service_type":serviceType] as [String: Any]
                
                let headers = [
                    "Authorization": "Bearer " + apiToken]
                
                //"Accept": "application/json"
                print(headers)
                
                Alamofire.request(Base_Url+UpdateSubmitStatusUrl , method: .post,  parameters: param, encoding: URLEncoding.default, headers:headers)
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
                            
                            self.view.window?.rootViewController?.dismiss(animated: true, completion: {
                                 ProjectManager.sharedInstance.statusDelegate?.getServiceProviderStatus()
                            }
                            
                            )

                            
                            
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

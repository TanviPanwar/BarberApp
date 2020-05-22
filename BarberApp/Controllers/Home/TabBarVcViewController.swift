//
//  TabBarVcViewController.swift
//  BarberApp
//
//  Created by iOS8 on 06/03/20.
//  Copyright © 2020 iOS8. All rights reserved.
//

import UIKit
import SwiftyGif
import Alamofire


class TabBarVcViewController: UITabBarController, UITabBarControllerDelegate {

    var objc = LoginObject()
    let logoAnimationView = LogoAnimationView()
    var launchBool = Bool()


    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self

       self.tabBar.isTranslucent = false
        
        
        if #available(iOS 13.0, *) {
            
            let appearance = self.tabBar.standardAppearance
            appearance.shadowImage = UIImage()
            appearance.shadowColor = nil
            appearance.backgroundColor =  .white
            self.tabBar.standardAppearance = appearance;
            
        } else {
            // Fallback on earlier versions
            
            self.tabBar.shadowImage = UIImage()
            self.tabBar.backgroundImage = UIImage()
            self.tabBar.backgroundColor = .white
           
        }
        
       // let apiToken = UserDefaults.standard.value(forKey: DefaultsIdentifier.apiToken)
        
        if !launchBool {
            
            view.addSubview(logoAnimationView)
            logoAnimationView.pinEdgesToSuperView()
            logoAnimationView.logoGifImageView.delegate = self
            
        }
        
        // Do any additional setup after loading the view.
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //let apiToken = UserDefaults.standard.value(forKey: DefaultsIdentifier.apiToken)
        
        if !launchBool {
            
            logoAnimationView.logoGifImageView.startAnimatingGif()
            
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
           //MARK: UITabbar Delegate
           func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
            
            
            print(tabBarController.selectedIndex)
//            if tabBarController.selectedIndex == 4 {
//                
//                
//            }
            
//            if viewController.isKind(of: ProfileViewController.self) {
//
//                print("Profile")
//                   // let vc =  ProfileViewController()
//                    //vc.modalPresentationStyle = .overFullScreen
//                   // self.present(vc, animated: true, completion: nil)
//                   // return false
//
//                    getStatusApi()
//
//                 }
            
             
             return true
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
                 
                 let headers = [
                     "Authorization": "Bearer " + apiToken]
                 
                 //"Accept": "application/json"
                 print(headers)
                 
                 Alamofire.request(Base_Url+ServiceProviderStatusUrl , method: .post,  parameters: nil, encoding: URLEncoding.default, headers:headers)
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
                             
                               let provider_status = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"provider_status", dict: json as NSDictionary)as String
                                
                            if provider_status == "3" || provider_status == ""   {
                            
//                                 let vc =  ProfileViewController()
//                                 self.present(vc, animated: true, completion: nil)
                                
                            } else {
                                
                                let vc =  BarberSettingsViewController()
                                self.present(vc, animated: true, completion: nil)
                                
                            }
                             
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

extension TabBarVcViewController: SwiftyGifDelegate {
    func gifDidStop(sender: UIImageView) {
        logoAnimationView.isHidden = true
    }
}

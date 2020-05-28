//
//  FeedbackViewController.swift
//  BarberApp
//
//  Created by iOS8 on 19/03/20.
//  Copyright © 2020 iOS8. All rights reserved.
//

import UIKit
import Alamofire
import IQKeyboardManagerSwift

class FeedbackViewController: UIViewController, UITextViewDelegate {
    @IBOutlet weak var giveProductLbl: UILabel!
    @IBOutlet weak var submitBtn: RoundedButton!
    @IBOutlet weak var smileImgViw: UIImageView!
    @IBOutlet weak var feedbackImgViw: UIImageView!
    @IBOutlet weak var reportBugLbl: UILabel!
    @IBOutlet weak var TxtViw: RoundedView!
    @IBOutlet weak var tellUsMoreLbl: UILabel!
    @IBOutlet weak var feedbackTextView: IQTextView!
    
    var reportType = String()
    var reportText = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        giveProductLbl.font = UIFont(name:"HelveticaNeue-Medium", size: 17)
        reportBugLbl.font = UIFont(name:"HelveticaNeue", size: 17)
        giveProductLbl.textColor = #colorLiteral(red: 0.1309883595, green: 0.2987812161, blue: 0.5047755837, alpha: 1)
        feedbackImgViw.image = #imageLiteral(resourceName: "feedback-blue")
        reportBugLbl.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        smileImgViw.image = #imageLiteral(resourceName: "smile-black")
        TxtViw.isHidden = false
        tellUsMoreLbl.isHidden = false
        submitBtn.isHidden = false
        reportType = "1"
        reportText = "Give product feedback"

        // Do any additional setup after loading the view.
    }
    
    
    // MARK: - TextView Delegates

    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {

        if textView == feedbackTextView {
            let maxLength = 500
            let currentString: NSString = textView.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: text) as NSString
            return newString.length <= maxLength

        }

        return true


    }
    
    
    
    @IBAction func giveFeedbackAction(_ sender: Any) {
        giveProductLbl.font = UIFont(name:"HelveticaNeue-Medium", size: 17)
        reportBugLbl.font = UIFont(name:"HelveticaNeue", size: 17)
        giveProductLbl.textColor = #colorLiteral(red: 0.1309883595, green: 0.2987812161, blue: 0.5047755837, alpha: 1)
        feedbackImgViw.image = #imageLiteral(resourceName: "feedback-blue")
        reportBugLbl.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        smileImgViw.image = #imageLiteral(resourceName: "smile-black")
        TxtViw.isHidden = false
        tellUsMoreLbl.isHidden = false
        submitBtn.isHidden = false
        reportType = "1"
        reportText = "Give product feedback"
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func reportBugAction(_ sender: Any) {
        reportBugLbl.font = UIFont(name:"HelveticaNeue-Medium", size: 17)
        giveProductLbl.font = UIFont(name:"HelveticaNeue", size: 17)
        reportBugLbl.textColor = #colorLiteral(red: 0.1309883595, green: 0.2987812161, blue: 0.5047755837, alpha: 1)
        smileImgViw.image = #imageLiteral(resourceName: "smile-blue")
        giveProductLbl.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        feedbackImgViw.image = #imageLiteral(resourceName: "feedback-black")
        TxtViw.isHidden = false
        tellUsMoreLbl.isHidden = false
        submitBtn.isHidden = false
        reportType = "2"
        reportText = "Report a bug"



    }
    
    @IBAction func submitBtnAction(_ sender: Any) {
        
        if feedbackTextView.text.isEmpty {
            
            ProjectManager.sharedInstance.showAlertwithTitle(title: "Alert", desc: "Feedback is required", vc: self)
            
        } else {
        
           feedbackApi()
            
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
    
    // MARK:- Api Methods
    
    
    func feedbackApi()
    {
        if ProjectManager.sharedInstance.isInternetAvailable()
        {
            if let apiToken = UserDefaults.standard.value(forKey: DefaultsIdentifier.apiToken) as? String {
                
                // if apiToken != nil {
                
                let feedback = (feedbackTextView.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
                
                DispatchQueue.main.async {
                    ProjectManager.sharedInstance.showLoader(vc: self)
                }
                
                let params = ["report_type":1,
                              "report_type_text":reportText, "message":feedback,
                "ip_address":"192.168.25.202"] as [String: Any]
                
                let headers = [
                    "Authorization": "Bearer " + apiToken]
                
                //"Accept": "application/json"
                print(headers)
                
                Alamofire.request(Base_Url+SendFeedbackUrl , method: .post,  parameters: params, encoding: URLEncoding.default, headers:headers)
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
                            
                            
                            CATransaction.begin()
                            CATransaction.setCompletionBlock({
                                // handle completion here
                                ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc: msg as String, vc: self)
                                
                                
                            })
                            
                            self.navigationController?.popViewController(animated: true)

                            CATransaction.commit()
                            
//                            self.navigationController?.popViewController(animated: true)
//
//                            ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc: msg as String, vc: self)
                            
                            
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

//
//  ViewController.swift
//  BarberApp
//
//  Created by iOS8 on 05/03/20.
//  Copyright © 2020 iOS8. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
import SwiftyGif


class ViewController: UIViewController {
    
    
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descrptionLabel: UILabel!
    @IBOutlet weak var getStartedBtn: RoundedButton!
    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet weak var privacyBtn: UIButton!
    @IBOutlet weak var servicesBtn: UIButton!
    
    var imageIndex: NSInteger = 0
    var maxImages = 0
    var onBoardingArray = [LoginObject]()
    let logoAnimationView = LogoAnimationView()

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.addSubview(logoAnimationView)
        logoAnimationView.pinEdgesToSuperView()
        logoAnimationView.logoGifImageView.delegate = self
        
        onBoardingDataApi()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
           super.viewDidAppear(animated)
           logoAnimationView.logoGifImageView.startAnimatingGif()
       }
    
    //MARK:- IB Actions
    
    @IBAction func getStartedBtnAction(_ sender: Any) {
        
        if #available(iOS 13.0, *) {
            
            let vc = mainStoryBoard.instantiateViewController(identifier: "MobileViewController") as! MobileViewController
            vc.launchBool = true
            self.navigationController?.pushViewController(vc, animated: true)
            
        } else {
            // Fallback on earlier versions
            
            let vc = mainStoryBoard.instantiateViewController(withIdentifier: "MobileViewController") as! MobileViewController
            vc.launchBool = true

            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        
        
    }
    
    @IBAction func privacyBtnAction(_ sender: Any) {
    
        
        var vc = TermsOfServicesController()
        
        if #available(iOS 13.0, *) {
            
           vc = homeStoryBoard.instantiateViewController(identifier:"TermsOfServicesController" ) as! TermsOfServicesController
            
        } else {
            // Fallback on earlier versions
            
            vc = homeStoryBoard.instantiateViewController(withIdentifier:"TermsOfServicesController" ) as! TermsOfServicesController
            
        }
           self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    @IBAction func servicesBtnAction(_ sender: Any) {
        
        
        var vc = TermsOfServicesController()
        
        if #available(iOS 13.0, *) {
            
           vc = homeStoryBoard.instantiateViewController(identifier:"TermsOfServicesController" ) as! TermsOfServicesController
            
        } else {
            // Fallback on earlier versions
            
            vc = homeStoryBoard.instantiateViewController(withIdentifier:"TermsOfServicesController" ) as! TermsOfServicesController
            
        }
           self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    //MARK:- Custom Methods
    
    @objc func swiped(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            switch swipeGesture.direction {
                
            case UISwipeGestureRecognizer.Direction.right :
                print("User swiped right")
                
                // decrease index first
                
                imageIndex = imageIndex - 1
                
                // check if index is in range
                
                if imageIndex < 0 {
                    
                    imageIndex = maxImages - 1
                    
                }
                
                self.mainImageView.sd_setImage(with: URL(string : self.onBoardingArray[imageIndex].image), placeholderImage:nil, options: [.cacheMemoryOnly]) { (image, error, cache, url) in
                    
                }
                
                self.titleLabel.text = self.onBoardingArray[imageIndex].title
                self.descrptionLabel.text = self.onBoardingArray[imageIndex].long_description
                //self.bottomLabel.text = self.onBoardingArray[imageIndex].short_description
                
                
            case UISwipeGestureRecognizer.Direction.left:
                print("User swiped Left")
                
                // increase index first
                
                imageIndex = imageIndex + 1
                
                // check if index is in range
                
                if imageIndex >= maxImages {
                    
                    imageIndex = 0
                    
                }
                
                self.mainImageView.sd_setImage(with: URL(string : self.onBoardingArray[imageIndex].image), placeholderImage:nil, options: [.cacheMemoryOnly]) { (image, error, cache, url) in
                    
                }
                
                self.titleLabel.text = self.onBoardingArray[imageIndex].title
                self.descrptionLabel.text = self.onBoardingArray[imageIndex].long_description
                //self.bottomLabel.text = self.onBoardingArray[imageIndex].short_description
                
                
                
            default:
                break //stops the code/codes nothing.
                
                
            }
            
        }
        
        
    }
    
    
    
    // MARK: - Api Methods
    
    func onBoardingDataApi()
    {
        if ProjectManager.sharedInstance.isInternetAvailable()
        {
            
            //            let params = ["phone_number":objc.phone_number , "country_code":objc.country_code] as [String: Any]
            //            print(params)
//            DispatchQueue.main.async {
//                ProjectManager.sharedInstance.showLoader(vc: self)
//            }
            
            Alamofire.request(Base_Url+onBoardingUrl, method: .post,  parameters: nil, encoding: URLEncoding.default, headers:nil)
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
                        
                        if let data = json["data"] as? NSArray , data.count > 0 {
                            
                            let array = ProjectManager.sharedInstance.GetOnBoardingObjects(array: data)
                            
                            self.onBoardingArray = array
                            self.maxImages = array.count
       
                            let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.swiped(gesture:))) // put : at the end of method name
                            swipeRight.direction = UISwipeGestureRecognizer.Direction.right
                            self.view.addGestureRecognizer(swipeRight)
                            
                            let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.swiped(gesture:))) // put : at the end of method name
                            swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
                            self.view.addGestureRecognizer(swipeLeft)
                            
                           // self.titleLabel.text = self.onBoardingArray[0].title

                            self.mainImageView.sd_setImage(with: URL(string : self.onBoardingArray[0].image), placeholderImage:nil, options: [.cacheMemoryOnly]) { (image, error, cache, url) in
                                
                            }
                            
                            self.titleLabel.text = self.onBoardingArray[0].title
                            self.descrptionLabel.text = self.onBoardingArray[0].long_description
//                            self.bottomLabel.text = self.onBoardingArray[0].short_description
                            
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

extension ViewController: SwiftyGifDelegate {
    func gifDidStop(sender: UIImageView) {
        logoAnimationView.isHidden = true
    }
}

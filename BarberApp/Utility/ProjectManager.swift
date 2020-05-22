//
//  ProjectManager.swift
//  BarberApp
//
//  Created by iOS8 on 19/03/20.
//  Copyright © 2020 iOS8. All rights reserved.
//

import UIKit
import SystemConfiguration
import AVFoundation
import NVActivityIndicatorView

let homeStoryBoard = UIStoryboard(name:"Home", bundle: nil)
let mainStoryBoard = UIStoryboard(name:"Main", bundle: nil)
var instagramCode = String()

protocol getTokenDelegate {
    func getAccessToken(code: String)
}

protocol getStatusDelegate {
    
    func getServiceProviderStatus()
}

class ProjectManager: NSObject {
    
    static let sharedInstance =  ProjectManager()
    
    private override init() {
        
    }
    
    var tokenDelegate: getTokenDelegate?
    var statusDelegate: getStatusDelegate?


    
    
    
    //MARK:- EMAIL VALIDATION
    func isEmailValid(email : String) -> Bool{
        let emailReg = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,20}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailReg)
        return emailTest.evaluate(with: email)
    }

    //MARK:- PASSWORD VALIDATION
    func isPasswordValid(_ password : String) -> Bool{
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }


    func isPhoneNumValid(phone: String) -> Bool {
        let PHONE_REGEX = "^\\d{3}-\\d{3}-\\d{4}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: phone)
        return result
    }



    func generateBoundaryString() -> String
    {
        return "Boundary-\(NSUUID().uuidString)"
    }





    func checkResponseForString(jsonKey : NSString , dict: NSDictionary) -> NSString{
        if((dict.value(forKey: jsonKey as String)) != nil  &&  !(dict.value(forKey: jsonKey as String) is NSNull)){
            if(dict.value(forKey: jsonKey as String) is String){
                var value  = dict.value(forKey: jsonKey as String) as! NSString
                if(value != "NA"){
                    value = convertUnicodeToEmoji(str: value as String) as NSString
                    return value
                }
            }

            else
                if(dict.value(forKey: jsonKey as String) is Int){
                    let value = String(describing:dict.value(forKey: jsonKey as String) as! Int)
                    return "\(value)" as NSString
                }else if(dict.value(forKey: jsonKey as String) is NSNumber){
                    let value = NumberFormatter().string(from:dict.value(forKey: jsonKey as String) as! NSNumber)
                    return value! as NSString
            }

        }
        return ""
    }



    func checkResponseForDict(jsonKey : NSString , dict: NSDictionary) -> String{
        if((dict.value(forKey: jsonKey as String)) != nil  &&  !(dict.value(forKey: jsonKey as String) is NSNull)){
            if  (dict.value(forKey: jsonKey as String) is [NSDictionary]){
                if let parentDict = (dict.value(forKey: jsonKey as String) as? [NSDictionary]){
                    for item in parentDict{
                        for (key,value) in item{
                            if(item.value(forKey: key as! String) is String){
                                return value as! String
                            }
                        }
                    }
                }

            }


        }
        return ""
    }




    func convertUnicodeToEmoji(str : String) -> String{
        let data : NSData = str.data(using: String.Encoding.utf8)! as NSData
        let convertedStr = NSString(data: data as Data, encoding: String.Encoding.nonLossyASCII.rawValue)
        if(convertedStr != nil ){
            return (convertedStr! as String)
        }
        return str
    }
    
    //MARK:-
       //MARK:- Server Error

       func showServerError(viewController : UIViewController) -> Void {

           let alertController = UIAlertController(title: "Server Error", message: "An error occurred while processing your request.", preferredStyle: .alert)
           alertController.addAction(UIAlertAction(title:"OK", style: UIAlertAction.Style.cancel, handler: nil))
           viewController.present(alertController, animated: true, completion: nil);
       }



       func gradientLayer(rect:CGRect,colors:[CGColor]) -> CAGradientLayer {
           let gradientlayer = CAGradientLayer()
           gradientlayer.frame = rect
           gradientlayer.colors = colors
           return gradientlayer

       }

         func showAlertwithTitle(title:String , desc:String , vc:UIViewController)  {
            
            let alert = UIAlertController(title: title, message: desc, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
             vc.present(alert, animated: true, completion: nil);

         }
    
    
    
    //MARK:- Check Internet Connection
    func isInternetAvailable() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)

        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }

        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }

    //MARK:-
       //MARK:- LOADER
       
//       func showLoader(){
//           let color = UIColor(red: 45/255.0 , green: 211/255.0, blue: 234/255.0, alpha: 1.0)
//           let loader = NVActivityIndicatorView(frame: UIApplication.topViewController()!.view.frame , type:NVActivityIndicatorType.ballSpinFadeLoader , color: color, padding:0.0 )
//           loader.startAnimating()
//           let activityData = ActivityData()
//           NVActivityIndicatorView.DEFAULT_TYPE = .ballSpinFadeLoader
//           NVActivityIndicatorView.DEFAULT_BLOCKER_BACKGROUND_COLOR = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
//           NVActivityIndicatorView.DEFAULT_BLOCKER_MESSAGE_FONT = UIFont.boldSystemFont(ofSize: 20)
//           NVActivityIndicatorView.DEFAULT_TEXT_COLOR = color
//           //        NVActivityIndicatorView.DEFAULT_BLOCKER_MESSAGE = title as String
//           //        NVActivityIndicatorPresenter.sharedInstance.setMessage(title)
//           NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData, NVActivityIndicatorView.DEFAULT_FADE_IN_ANIMATION)
//
//       }
       
       func showLoader(vc: UIViewController){
           let color = UIColor(red: 45/255.0 , green: 211/255.0, blue: 234/255.0, alpha: 1.0)
           let loader = NVActivityIndicatorView(frame: vc.view.frame , type:NVActivityIndicatorType.ballSpinFadeLoader , color: color, padding:0.0 )
           loader.startAnimating()
           let activityData = ActivityData()
           NVActivityIndicatorView.DEFAULT_TYPE = .ballSpinFadeLoader
           NVActivityIndicatorView.DEFAULT_BLOCKER_BACKGROUND_COLOR = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
           NVActivityIndicatorView.DEFAULT_BLOCKER_MESSAGE_FONT = UIFont.boldSystemFont(ofSize: 20)
           NVActivityIndicatorView.DEFAULT_TEXT_COLOR = color
           //        NVActivityIndicatorView.DEFAULT_BLOCKER_MESSAGE = title as String
           //        NVActivityIndicatorPresenter.sharedInstance.setMessage(title)
           NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData, NVActivityIndicatorView.DEFAULT_FADE_IN_ANIMATION)
           
       }
       
       func stopLoader(){
           NVActivityIndicatorPresenter.sharedInstance.stopAnimating(NVActivityIndicatorView.DEFAULT_FADE_OUT_ANIMATION)
       }
       
    
    
    //MARK:-
    //MARK:- Json Objects
    
    func GetLoginObjects(dict:[String: Any]) -> LoginObject {
        
        var obj = LoginObject()
       
        obj.country_code = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "country_code", dict: dict as NSDictionary) as String
        
        obj.id = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "id", dict: dict as NSDictionary) as String

        obj.phone_number = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "phone_number", dict: dict as NSDictionary) as String
        
         obj.otp = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "otp", dict: dict as NSDictionary) as String

         return obj
        
     }
    
    func GetOnBoardingObjects(array:NSArray) -> [LoginObject] {
        
        var searchResultArray = [LoginObject]()
        for item in array {
            
            let dict  = item as!  [String:Any]
            let obj = LoginObject()
            
            obj.status = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "status", dict: dict as NSDictionary) as String
            
            obj.id = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "id", dict: dict as NSDictionary) as String
            
            obj.title = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "title", dict: dict as NSDictionary) as String
            
            obj.long_description = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "long_description", dict: dict as NSDictionary) as String
            
            obj.short_description = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "short_description", dict: dict as NSDictionary) as String
            
            obj.image = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "image", dict: dict as NSDictionary) as String
            
            
            searchResultArray.append(obj)
        }
        
        return searchResultArray
        
    }
    
    func GetLoginDataObjects(dict:[String: Any]) -> LoginObject {
        
        var obj = LoginObject()
        
         obj.api_token = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "api_token", dict: dict as NSDictionary) as String
       
        obj.country_code = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "country_code", dict: dict as NSDictionary) as String
        
         obj.country_id = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "country_id", dict: dict as NSDictionary) as String
        
        obj.dob = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "dob", dict: dict as NSDictionary) as String
        
         obj.email = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "email", dict: dict as NSDictionary) as String
         
          obj.family_name = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "family_name", dict: dict as NSDictionary) as String
        
        obj.first_name = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "first_name", dict: dict as NSDictionary) as String
        
         obj.id = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "id", dict: dict as NSDictionary) as String
        
         obj.ip_address = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "ip_address", dict: dict as NSDictionary) as String
         
          obj.last_name = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "last_name", dict: dict as NSDictionary) as String
        
         obj.otp = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "otp", dict: dict as NSDictionary) as String

        obj.phone_number = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "phone_number", dict: dict as NSDictionary) as String
        
        obj.phone_verified = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "phone_verified", dict: dict as NSDictionary) as String
               
        obj.user_lat = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "user_lat", dict: dict as NSDictionary) as String

        obj.user_lon = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "user_lon", dict: dict as NSDictionary) as String
        
        obj.user_role_id = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "user_role_id", dict: dict as NSDictionary) as String

        obj.user_status = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "user_status", dict: dict as NSDictionary) as String
        
        obj.area = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "area", dict: dict as NSDictionary) as String

        obj.building = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "building", dict: dict as NSDictionary) as String
        
        obj.street = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "street", dict: dict as NSDictionary) as String
        
        
        
         return obj
        
     }
    
    
    func GetHomeDataServiceListObjects(array:NSArray) -> [HomeObject] {
        
        var searchResultArray = [HomeObject]()
        for item in array {
            
            let dict  = item as!  [String:Any]
            let obj = HomeObject()
            
            obj.estimated_time = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "estimated_time", dict: dict as NSDictionary) as String
            
            obj.id = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "id", dict: dict as NSDictionary) as String
            
            obj.image = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "image", dict: dict as NSDictionary) as String
            
            obj.name = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "name", dict: dict as NSDictionary) as String
            
            obj.status = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "status", dict: dict as NSDictionary) as String
            

            searchResultArray.append(obj)
        }
        
        return searchResultArray
        
    }
    
    
    func GetHomeDataTopBarberListObjects(array:NSArray) -> [HomeObject] {
        
        var resultArray = [HomeObject]()
        for item in array {
            
            let dict  = item as!  [String:Any]
            let obj = HomeObject()
            
            obj.about = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "about", dict: dict as NSDictionary) as String
            
            
            
            if  let available_time = dict["available_time"] as? NSArray {
                
                for i in available_time {
                    let subobj = HomeObject()
                    
                    subobj.day = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "day", dict: dict as NSDictionary) as String
                    
                    subobj.day_off_status = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "day_off_status", dict: dict as NSDictionary) as String
                    
                    subobj.id = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "id", dict: dict as NSDictionary) as String
                    
                    subobj.time_from = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "time_from", dict: dict as NSDictionary) as String
                    
                    subobj.time_to = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "time_to", dict: dict as NSDictionary) as String
                     
                     subobj.user_id = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "user_id", dict: dict as NSDictionary) as String
                     
                     subobj.user_ip = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "user_ip", dict: dict as NSDictionary) as String
                   
                    
                    obj.available_time.append(subobj)
                }
                
            }
            
            obj.avg_rating = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "avg_rating", dict: dict as NSDictionary) as String
            
            obj.barber_address = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "barber_address", dict: dict as NSDictionary) as String
            
            obj.barber_close_time = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "barber_clsoe_time", dict: dict as NSDictionary) as String
            
            obj.barber_name = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "barber_name", dict: dict as NSDictionary) as String
            
            obj.barber_start_time = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "barber_start_time", dict: dict as NSDictionary) as String
            
            obj.distance = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "distance", dict: dict as NSDictionary) as String
            
            obj.home_service_fee = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "home_service_fee", dict: dict as NSDictionary) as String
            
            obj.image = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "image", dict: dict as NSDictionary) as String
            
            obj.language = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "language", dict: dict as NSDictionary) as String
            
            obj.nationality = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "nationality", dict: dict as NSDictionary) as String
            
            obj.preffered_visit_time = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "preffered_visit_time", dict: dict as NSDictionary) as String
            
            obj.price_range = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "price_range", dict: dict as NSDictionary) as String
            
            obj.provide_home_service = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "provide_home_service", dict: dict as NSDictionary) as String
            
            obj.saloon_lat = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "saloon_lat", dict: dict as NSDictionary) as String
            
            obj.saloon_location = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "saloon_location", dict: dict as NSDictionary) as String
            
            obj.saloon_lon = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "saloon_lon", dict: dict as NSDictionary) as String
            
            obj.saloon_name = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "saloon_name", dict: dict as NSDictionary) as String
            
              obj.service_type = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "service_type", dict: dict as NSDictionary) as String
            
            obj.total_customer = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "total_customer", dict: dict as NSDictionary) as String

            resultArray.append(obj)
            
        }
        
        return resultArray
        
    }
    
    
    func GetCountriesIDObjects(array:NSArray) -> [CountryObject] {
        
        var searchResultArray = [CountryObject]()
        for item in array {
            
            let dict  = item as!  [String:Any]
            let obj = CountryObject()
          
            obj.id = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "id", dict: dict as NSDictionary) as String
            
            obj.countryName = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "name", dict: dict as NSDictionary) as String
            
                obj.code = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "code", dict: dict as NSDictionary) as String
            
            searchResultArray.append(obj)
        }
        
        return searchResultArray
        
    }
    
    func GetServiceObjects(array:NSArray) -> [ServiceObject] {
        
        var searchResultArray = [ServiceObject]()
        for item in array {
            
            let dict  = item as!  [String:Any]
            let obj = ServiceObject()
            
            obj.dscription = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "description", dict: dict as NSDictionary) as String
            
            
            if obj.dscription.isEmpty {
                
                obj.addDescription = ""
                
            } else {
                
                obj.addDescription = "1"

            }
            
            
            obj.estimated_time = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "estimated_time", dict: dict as NSDictionary) as String
            
            obj.image = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "image", dict: dict as NSDictionary) as String
            
            obj.price = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "price", dict: dict as NSDictionary) as String
            
            obj.service_category = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "service_category", dict: dict as NSDictionary) as String
            
            obj.service_id = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "service_id", dict: dict as NSDictionary) as String
            
            obj.service_name = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "service_name", dict: dict as NSDictionary) as String
            
            obj.user_service_status = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "user_service_status", dict: dict as NSDictionary) as String
            
            if obj.user_service_status == "0" {
                
                obj.switchBool = false

            } else {
                
                obj.switchBool = true

            }
            
            
            obj.addDesc = "1"
          //obj.switchBool = true
            
            
            searchResultArray.append(obj)
        }
        
        return searchResultArray
        
    }
    
    func GetHomeServiceObjects(dict:[String: Any]) -> ServiceObject {
        
        var obj = ServiceObject()
        
        obj.home_service_fee = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "home_service_fee", dict: dict as NSDictionary) as String
        
        obj.home_service_status = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "home_service_status", dict: dict as NSDictionary) as String
        
        
        return obj
        
    }
    
    
    func GetScheduleObjects(array:NSArray) -> [ScheduleObject] {
        
        var searchResultArray = [ScheduleObject]()
        for item in array {
            
            
            let dict  = item as!  [String:Any]
            let obj = ScheduleObject()
            
            if  let time_slots = dict["time_slots"] as? NSArray, time_slots.count > 0 {
                
                obj.day = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "day", dict: dict as NSDictionary) as String
                
                obj.day_off_status = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "day_off_status", dict: dict as NSDictionary) as String
                
                obj.day_time_id = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "day_time_id", dict: dict as NSDictionary) as String
                
                if obj.day == "Sunday" && obj.day_off_status == "1"{
                    
                    obj.mainIdentify = 1
                }
                if obj.day == "Monday" && obj.day_off_status == "1"{
                    
                    obj.mainIdentify = 3
                }
                if obj.day == "Tuesday" && obj.day_off_status == "1"{
                    
                    obj.mainIdentify = 5
                }
                if obj.day == "Wednesday" && obj.day_off_status == "1"{
                    
                    obj.mainIdentify = 7
                }
                if obj.day == "Thursday" && obj.day_off_status == "1"{
                    
                    obj.mainIdentify = 9
                }
                if obj.day == "Friday" && obj.day_off_status == "1"{
                    
                    obj.mainIdentify = 11
                }
                if obj.day == "Saturday" && obj.day_off_status == "1"{
                    
                    obj.mainIdentify = 13
                }
                
                
                if  let time_slots = dict["time_slots"] as? NSArray, time_slots.count > 0 {
                    
                    for i in 0...time_slots.count - 1 {
                        
                        let subobj = ScheduleObject()
                        let item = time_slots[i]
                        
                        if i == 0 &&  obj.day == "Sunday"  {
                            
                            subobj.identify = 1
                        }
                        
                        if i == 1 &&  obj.day == "Sunday"  {
                            
                            subobj.identify = 2
                        }
                        
                        if i == 0 &&  obj.day == "Monday"  {
                            
                            subobj.identify = 3
                        }
                        
                        if i == 1 &&  obj.day == "Monday"  {
                            
                            subobj.identify = 4
                        }
                        
                        if i == 0 &&  obj.day == "Tuesday"  {
                            
                            subobj.identify = 5
                        }
                        
                        if i == 1 &&  obj.day == "Tuesday"  {
                            
                            subobj.identify = 6
                        }
                        
                        if i == 0 &&  obj.day == "Wednesday"  {
                            
                            subobj.identify = 7
                        }
                        
                        if i == 1 &&  obj.day == "Wednesday"  {
                            
                            subobj.identify = 8
                        }
                        
                        if i == 0 &&  obj.day == "Thursday"  {
                            
                            subobj.identify = 9
                        }
                        
                        if i == 1 &&  obj.day == "Thursday"  {
                            
                            subobj.identify = 10
                        }
                        
                        if i == 0 &&  obj.day == "Friday"  {
                            
                            subobj.identify = 11
                        }
                        
                        if i == 1 &&  obj.day == "Friday"  {
                            
                            subobj.identify = 12
                        }
                        
                        if i == 0 &&  obj.day == "Saturday"  {
                            
                            subobj.identify = 13
                        }
                        
                        if i == 1 &&  obj.day == "Saturday"  {
                            
                            subobj.identify = 14
                        }
                        
                       
                        
                        subobj.day_time_id = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "day_time_id", dict: item as! NSDictionary) as String
                        
                        subobj.id = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "id", dict: item as! NSDictionary) as String
                        
                        subobj.time_from = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "time_from", dict: item as! NSDictionary) as String
                        
                        subobj.time_to = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "time_to", dict: item as! NSDictionary) as String
                        
                        
                        obj.time_slots.append(subobj)
                        
                    }
                    
                }
                
                
                searchResultArray.append(obj)
                
            }
        }
        
        return searchResultArray
        
    }
    
    
    
    
    
    
    func GetAdditionalInfoObjects(dict:[String: Any]) -> AdditionalInfoObject {
        
        var obj = AdditionalInfoObject()
        
         obj.about = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "about", dict: dict as NSDictionary) as String
        
        
        if let addinfoArray = dict["additional_info"] as? NSArray , addinfoArray.count > 0 {
            
            obj.additional_info = addinfoArray as! [String]
            
        }
        
       
        obj.instagram_token = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "instagram_token", dict: dict as NSDictionary) as String
        
         obj.passport = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "passport", dict: dict as NSDictionary) as String
        
        if obj.passport != "" {
            
            obj.passID = "2"
        }

        
        obj.provider_status = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "provider_status", dict: dict as NSDictionary) as String
        
         obj.qtr_back_id = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "qtr_back_id", dict: dict as NSDictionary) as String
        
        if obj.qtr_back_id != "" {
            
            obj.backID = "1"
        }
         
          obj.qtr_front_id = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "qtr_front_id", dict: dict as NSDictionary) as String
        
        if obj.qtr_front_id != "" {
                  
                  obj.frontID = "0"
              }
        
        obj.second_language = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "second_language", dict: dict as NSDictionary) as String
        
         obj.service_type = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "service_type", dict: dict as NSDictionary) as String
        
         obj.third_language = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "third_language", dict: dict as NSDictionary) as String
         
          obj.user_id = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "user_id", dict: dict as NSDictionary) as String
        
         obj.user_language = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "user_language", dict: dict as NSDictionary) as String

         return obj
        
        
     }
    
    func GetSearchBarberShopListObjects(array:NSArray) -> [HomeObject] {
        
        var searchResultArray = [HomeObject]()
        for item in array {
            
            let dict  = item as!  [String:Any]
            let obj = HomeObject()
            
            obj.id = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "id", dict: dict as NSDictionary) as String
            
            obj.preffered_visit_time = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "preffered_visit_time", dict: dict as NSDictionary) as String
            
            obj.saloon_lat = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "saloon_lat", dict: dict as NSDictionary) as String
            
            obj.saloon_location = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "saloon_location", dict: dict as NSDictionary) as String
            
            obj.saloon_lon = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "saloon_lon", dict: dict as NSDictionary) as String
            
            obj.saloon_name = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "saloon_name", dict: dict as NSDictionary) as String
            

            searchResultArray.append(obj)
        }
        
        return searchResultArray
        
    }
    
    
    func GetTermsServicesObjects(dict:[String: Any]) -> TermsObject {
        
        let obj = TermsObject()
        
        obj.created_at = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "created_at", dict: dict as NSDictionary) as String
        
        obj.dscription = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "description", dict: dict as NSDictionary) as String
        
        obj.id = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "id", dict: dict as NSDictionary) as String
        
        obj.title = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "title", dict: dict as NSDictionary) as String
        obj.updated_at = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "updated_at", dict: dict as NSDictionary) as String
        
        obj.url = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "url", dict: dict as NSDictionary) as String
        
        
        return obj
        
    }
    
    
  

}

extension UIApplication {
    class func topViewController(_ base: UIViewController? = (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(presented)
        }
        return base
    }
}

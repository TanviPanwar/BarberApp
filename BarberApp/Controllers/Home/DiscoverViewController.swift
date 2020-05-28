//
//  DiscoverViewController.swift
//  BarberApp
//
//  Created by iOS8 on 09/03/20.
//  Copyright © 2020 iOS8. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
class DiscoverViewController: UIViewController {
    @IBOutlet weak var listBtn: UIButton!
    @IBOutlet weak var mapBtn: UIButton!
    
    @IBOutlet weak var noDataFoundLbl: UILabel!
    @IBOutlet weak var searchTxtField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var serviceCollectionViw: UICollectionView!
    var servicesArray = [ServiceListObject]()
    var availableTimeSlots = ["01 AM", "02 AM", "03 AM" ,"10 AM" ,"11 AM", "12 PM" , "03 PM" , "04 PM", "07 PM",]
    var discoverObjectArray = [BarbarDiscoverObject]()
     var selectedServiceType = ""
    var filter_param = [String:Any]()
    var userLocation: (Double,Double) = (lat : 0.0,long : 0.0)
    var selectedServiceIndex = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        listBtn.roundCorners(corners: [.topLeft, .bottomLeft], radius: 17.5)
        mapBtn.roundCorners(corners: [.topRight, .bottomRight], radius: 17.5)
        if !selectedServiceType.isEmpty {
            getServiceListFilterDataAPI(service_id: selectedServiceType)
        }
        else
        {
              getBarbarDiscoverDataAPI()
        }
     userLocation =  LocationService.sharedInstance.getCurrentLatitudeAnfLongitude()
        getServiceListDataAPI()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func filterBtn(_ sender: UIButton) {
        var rangeMinValue: CGFloat = 0, rangeMaxValue : CGFloat = 30
        if filter_param.count > 0 {
           if let  rangeSliderValue = filter_param["distance"] as? String
           {
            if rangeSliderValue.count > 0
                       {
                        let valueArray = rangeSliderValue.split(separator: "-")
                           rangeMinValue = CGFloat(Double(valueArray[0]) ?? 1)
                           rangeMaxValue = CGFloat(Double(valueArray[1]) ?? 30)
                           
                       }
            }
           
        }
        
        
        if #available(iOS 13.0, *) {
            
            let vc = homeStoryBoard.instantiateViewController(identifier:"FilterViewController") as! FilterViewController
            vc.filterVCDelegate = self
            vc.selectedFilterParam =   self.filter_param
            vc.rangeMinValue = rangeMinValue
            vc.rangeMaxValue = rangeMaxValue
            self.navigationController?.pushViewController(vc, animated: true)
            
        } else {
            // Fallback on earlier versions
            
            let vc = homeStoryBoard.instantiateViewController(withIdentifier:"FilterViewController") as! FilterViewController
            vc.filterVCDelegate = self
            vc.selectedFilterParam =   self.filter_param
            vc.rangeMinValue = rangeMinValue
            vc.rangeMaxValue = rangeMaxValue
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    
    @IBAction func mapBtnClick(_ sender: Any) {
            self.mapBtn.backgroundColor = #colorLiteral(red: 0.05763856322, green: 0.2982799113, blue: 0.5071055889, alpha: 1)
            self.mapBtn.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
            self.listBtn.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.listBtn.setTitleColor(#colorLiteral(red: 0.05763856322, green: 0.2982799113, blue: 0.5071055889, alpha: 1), for: .normal)
//        if #available(iOS 13.0, *) {
//
//                  let vc = mainStoryBoard.instantiateViewController(identifier:"MapViewController") as! MapViewController
//
//            self.navigationController?.pushViewController(vc, animated: true)
//
//              } else {
//                  // Fallback on earlier versions
//
//                  let vc = mainStoryBoard.instantiateViewController(withIdentifier:"MapViewController") as! MapViewController
//             self.navigationController?.pushViewController(vc, animated: true)
//        }
        
    }
    @IBAction func listBtnClick(_ sender: Any) {
            self.listBtn.backgroundColor = #colorLiteral(red: 0.05763856322, green: 0.2982799113, blue: 0.5071055889, alpha: 1)
            self.listBtn.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
            self.mapBtn.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.mapBtn.setTitleColor(#colorLiteral(red: 0.05763856322, green: 0.2982799113, blue: 0.5071055889, alpha: 1), for: .normal)
    }
    
    //        func getAvailabeSlots()  -> [String]{
    //            var array: [String] = []
    //
    //            let formatter = DateFormatter()
    //            formatter.dateFormat = "hh:mm a"
    //
    //            let formatter2 = DateFormatter()
    //            formatter2.dateFormat = "hh a"
    //
    //            guard let startDate = self.StartTimeTxtFld.text else { return [String]() }
    //            guard let endDate = self.endTimeTXtFld.text else { return [String]() }
    //
    //            let date1 = formatter.date(from: startDate)
    //            let date2 = formatter.date(from: endDate)
    //
    //            var i = 1
    //            while true {
    //                let date = date1?.addingTimeInterval(TimeInterval(i*30*60))
    //                let string = formatter2.string(from: date!)
    //                if date! >= date2! {
    //                    break;
    //                }
    //                i += 1
    //                array.append(string)
    //            }
    //            print(array)
    //            return array
    //        }
    //
    
    
    
    func scrollToSelectedService( )    {
        if !self.selectedServiceType.isEmpty
                                  {
                                      for (index,service) in self.servicesArray.enumerated() {
                                          if service.service_id == self.selectedServiceType {
                                              self.selectedServiceIndex = index
                                            break
                                          }
                                      }
                                    
                                    serviceCollectionViw.scrollToItem(at: IndexPath(item: selectedServiceIndex, section: 0), at: .centeredHorizontally, animated: true)
                                  }
        else
        {
             serviceCollectionViw.scrollToItem(at: IndexPath(item: selectedServiceIndex, section: 0), at: .centeredHorizontally, animated: true)
        }
        
    }
    
    
    func getTimeSlots()  -> [TimeObj] {
        
        var array: [TimeObj] = []
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy hh:mm a"
        let formatter2 = DateFormatter()
        formatter2.dateFormat = "hh a"
        let startDate = "20-08-2018 08:00 AM"
        let endDate = "21-08-2018 01:00 AM"
        let date1 = formatter.date(from: startDate)
        let date2 = formatter.date(from: endDate)
        
        var i = 1
        
        while true {
            let obj = TimeObj()
            let date = date1?.addingTimeInterval(TimeInterval(i*60*60))
            let string = formatter2.string(from: date!)
            if date! > date2! {
                break;
            }
            i += 1
            obj.time = string
            array.append(obj)
        }
        
        //print(array.map{$0.time})
        return array
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func addTimeSlots()  {
        discoverObjectArray.map { (obj:BarbarDiscoverObject) -> BarbarDiscoverObject in
            obj.timeSlots = getTimeSlots()
            return obj
        }
    }
    
    
    // MARK: - Api Methods
        
        func getBarbarDiscoverDataAPI()
        {
            if ProjectManager.sharedInstance.isInternetAvailable()
            {
                
                 if let apiToken = UserDefaults.standard.value(forKey: DefaultsIdentifier.apiToken) as? String {
                
                //            let params = ["phone_number":objc.phone_number , "country_code":objc.country_code] as [String: Any]
                //            print(params)
    //            DispatchQueue.main.async {
                    ProjectManager.sharedInstance.showLoader(vc: self)
    //            }
                
                let headers = [
                    "Authorization": "Bearer " + apiToken]
                
                //"Accept": "application/json"
               print(headers)
                
                Alamofire.request(Base_Url+discover_barber_listing_url, method: .post,  parameters: nil, encoding: URLEncoding.default, headers:headers)
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
                            
                            if let dataArray = json["data"] as? NSArray , dataArray.count > 0 {
                                
                                let array = ProjectManager2.sharedInstance.getBarbarDiscoverObjectData(array: dataArray)
                                self.discoverObjectArray = array
                                self.addTimeSlots()
                            }
                            
                            self.noDataFoundLbl.isHidden = true
                          
                            self.tableView.reloadData()
                              self.serviceCollectionViw.reloadData()
                            
                            
                        } else {
                            
                            DispatchQueue.main.async {
                                self.discoverObjectArray.removeAll()
                                self.tableView.reloadData()
                                  self.serviceCollectionViw.reloadData()
                                 self.noDataFoundLbl.isHidden = false
                               // ProjectManager.sharedInstance.showServerError(viewController: self)
                                
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
    

    func getServiceListDataAPI()
           {
               if ProjectManager.sharedInstance.isInternetAvailable()
               {
                   
                    if let apiToken = UserDefaults.standard.value(forKey: DefaultsIdentifier.apiToken) as? String {
                   
                   //            let params = ["phone_number":objc.phone_number , "country_code":objc.country_code] as [String: Any]
                   //            print(params)
       //            DispatchQueue.main.async {
                       ProjectManager.sharedInstance.showLoader(vc: self)
       //            }
                   
                   let headers = [
                       "Authorization": "Bearer " + apiToken]
                   
                   //"Accept": "application/json"
                  print(headers)
                   
                   Alamofire.request(Base_Url+all_services_list_url, method: .post,  parameters: nil, encoding: URLEncoding.default, headers:headers)
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
                               
                               if let dataArray = json["data"] as? NSArray , dataArray.count > 0 {
                                   
                                   let array = ProjectManager2.sharedInstance.getServiceListData(array: dataArray)
                                   self.servicesArray = array
                                let topObj = ServiceListObject()
                                topObj.name = "All*"
                                topObj.service_id = ""
                                self.servicesArray.insert(topObj, at: 0)
                                   
                               }
                          
                               
                               self.serviceCollectionViw.reloadData()
                              self.scrollToSelectedService()
                               
                               
                           } else {
                               
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
    
    
    
    func getServiceListFilterDataAPI(service_id:String)
           {
               if ProjectManager.sharedInstance.isInternetAvailable()
               {
                   
                    if let apiToken = UserDefaults.standard.value(forKey: DefaultsIdentifier.apiToken) as? String {
                   
                        let params = ["service_id":service_id , "user_lon":userLocation.1 == 0.0 ? "76.7794" : "\(userLocation.1)","user_lat":userLocation.0 == 0.0 ? "30.71415" : "\(userLocation.0)"] as [String: Any]
                                print(params)
       //            DispatchQueue.main.async {
                       ProjectManager.sharedInstance.showLoader(vc: self)
       //            }
                   
                   let headers = [
                       "Authorization": "Bearer " + apiToken]
                   
                   //"Accept": "application/json"
                  print(headers)
                   
                   Alamofire.request(Base_Url+filter_services_url, method: .post,  parameters: params, encoding: URLEncoding.default, headers:headers)
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
                               
                               if let dataArray = json["data"] as? NSArray , dataArray.count > 0 {
                                   
                                   let array = ProjectManager2.sharedInstance.getBarbarDiscoverObjectData(array: dataArray)
                                   self.discoverObjectArray = array
                                    self.addTimeSlots()
                               }
                                self.noDataFoundLbl.isHidden = true
                            self.serviceCollectionViw.reloadData()
                               self.tableView.reloadData()
                               
                               
                           } else {
                               
                               DispatchQueue.main.async {
                                self.discoverObjectArray.removeAll()
                                self.serviceCollectionViw.reloadData()
                                self.tableView.reloadData()
                                 self.noDataFoundLbl.isHidden = false
                                   //ProjectManager.sharedInstance.showServerError(viewController: self)
                                   
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

    
    func getSearchFilterDataAPI(search:String)
              {
                  if ProjectManager.sharedInstance.isInternetAvailable()
                  {
                      
                       if let apiToken = UserDefaults.standard.value(forKey: DefaultsIdentifier.apiToken) as? String {
                      
                           let params = ["search":search] as [String: Any]
                                   print(params)
          //            DispatchQueue.main.async {
                          ProjectManager.sharedInstance.showLoader(vc: self)
          //            }
                      
                      let headers = [
                          "Authorization": "Bearer " + apiToken]
                      
                      //"Accept": "application/json"
                     print(headers)
                      
                      Alamofire.request(Base_Url+discover_search_url, method: .post,  parameters: params, encoding: URLEncoding.default, headers:headers)
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
                                  
                                  if let dataArray = json["data"] as? NSArray , dataArray.count > 0 {
                                      
                                      let array = ProjectManager2.sharedInstance.getBarbarDiscoverObjectData(array: dataArray)
                                      self.discoverObjectArray = array
                                       self.addTimeSlots()
                                  }
                                   self.noDataFoundLbl.isHidden = true
                           
                                  self.tableView.reloadData()
                                  
                                  
                              } else {
                                  
                                  DispatchQueue.main.async {
                                    self.discoverObjectArray.removeAll()
                                    self.tableView.reloadData()
                                    self.noDataFoundLbl.isHidden = false
                                   //   ProjectManager.sharedInstance.showServerError(viewController: self)
                                      
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
    
    
    func applyFilterDataAPI(param:[String:Any])
                 {
                     if ProjectManager.sharedInstance.isInternetAvailable()
                     {
                         
                          if let apiToken = UserDefaults.standard.value(forKey: DefaultsIdentifier.apiToken) as? String {
                         
                              let params = param
             //            DispatchQueue.main.async {
                             ProjectManager.sharedInstance.showLoader(vc: self)
             //            }
                         
                         let headers = [
                             "Authorization": "Bearer " + apiToken]
                         
                         //"Accept": "application/json"
                        print(headers)
                        print(params)
                            print(Base_Url+filter_barber_url)
                         Alamofire.request(Base_Url+filter_barber_url, method: .post,  parameters: params, encoding: URLEncoding.default, headers:headers)
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
                                     
                                     if let dataArray = json["data"] as? NSArray , dataArray.count > 0 {
                                         
                                         let array = ProjectManager2.sharedInstance.getBarbarDiscoverObjectData(array: dataArray)
                                         self.discoverObjectArray = array
                                          self.addTimeSlots()
                                     }
                                      self.noDataFoundLbl.isHidden = true
                                    self.selectedServiceType = ""
                                    self.selectedServiceIndex = 0
                                    self.serviceCollectionViw.reloadData()
                                    self.scrollToSelectedService()
                                     self.tableView.reloadData()
                                     
                                     
                                 } else {
                                     
                                     DispatchQueue.main.async {
                                       self.discoverObjectArray.removeAll()
                                        self.selectedServiceType = ""
                                                                           self.selectedServiceIndex = 0
                                                                           self.serviceCollectionViw.reloadData()
                                       self.tableView.reloadData()
                                         self.scrollToSelectedService()
                                       self.noDataFoundLbl.isHidden = false
                                      //   ProjectManager.sharedInstance.showServerError(viewController: self)
                                         
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
        
    
    
    func createBookingTimeSlots(bookingTimeArray:[BookingTimeObject],index:Int)  {
        
        let dateFormatter1 = DateFormatter()
        let dateFormatter2 = DateFormatter()
        dateFormatter1.dateFormat = "HH:mm:ss"
        dateFormatter2.dateFormat = "hh a"
        dateFormatter1.locale = Locale.current
        dateFormatter2.locale = Locale.current
        for bookingTime in bookingTimeArray {
            if let date1 = dateFormatter1.date(from: bookingTime.booking_time_from),let date2 = dateFormatter1.date(from: bookingTime.booking_time_to)
            {
               
               
                if let bookingStartDate = dateFormatter2.date(from: dateFormatter2.string(from: date1)),  let bookingEndDate = dateFormatter2.date(from: dateFormatter2.string(from: date2))
                {
                    
                    var isStartDateMathced = false
                    let tmpData = discoverObjectArray[index]
                    let tmpTimeSlots = tmpData.timeSlots
                    
                    for timeObj in tmpTimeSlots {
                        if let timeSlotDate = dateFormatter2.date(from: timeObj.time)
                        {
                                  print( dateFormatter2.string(from: date2))
                               print( dateFormatter2.string(from: date1))
                            if isStartDateMathced {
                                if  bookingEndDate > timeSlotDate || bookingEndDate == timeSlotDate {
                                
                                    timeObj.isSelected = true
                                 
                                }
                                else
                                {
                                    break
                                }
                            }
                            else
                            {
                                if  bookingStartDate < timeSlotDate || bookingStartDate == timeSlotDate {
                                  
                                    timeObj.isSelected = true
                                    isStartDateMathced = true
                                }
                                
                            }
                        }
                    }
                    tmpData.timeSlots = tmpTimeSlots
                    discoverObjectArray[index] = tmpData
                }
            }
            
        }
        
    }
    
    func compareTime(time:String) -> Bool {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        let todayDate = dateFormatter.string(from: Date())
       
        guard let date1 = dateFormatter.date(from: todayDate) ,let date2 = dateFormatter.date(from: time)  else { return false }
        print(date1)
        print(date2)
         if date1 > date2
         {
            return true
        }
      else
         {
            return false
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
    
}
extension DiscoverViewController:UICollectionViewDelegate , UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView ==  serviceCollectionViw {
            let size = servicesArray[indexPath.item].name.size(withAttributes: [NSAttributedString.Key.font: UIFont(name: "Avenir-Medium", size: 16.0)! ])
            
            return CGSize(width:size.width + 15, height:50)
        } else {
            return CGSize(width:30, height: 60)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView ==  serviceCollectionViw {
            return servicesArray.count
            
        }
        else {
            return discoverObjectArray[collectionView.tag].timeSlots.count
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView ==  serviceCollectionViw {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"ServiceCell", for: indexPath) as? ServiceCell else {return UICollectionViewCell()}
            if indexPath.row == selectedServiceIndex
            {
                cell.bottomLbl.isHidden = false
            }
            else
            {
                cell.bottomLbl.isHidden = true
            }
            
            cell.serviceNameLbl.text = servicesArray[indexPath.item].name
            
            return cell
        } else {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TimeSlotCell", for: indexPath) as! TimeSlotCell
            let tmp =  discoverObjectArray[collectionView.tag]
            createBookingTimeSlots(bookingTimeArray: discoverObjectArray[collectionView.tag].booking_time, index: collectionView.tag)
            let obj = discoverObjectArray[collectionView.tag].timeSlots[indexPath.item]
            if obj.isSelected {
                cell.slotViw.backgroundColor = #colorLiteral(red: 0.2909106016, green: 0.4674310684, blue: 0.6362583041, alpha: 1)
            } else {
                cell.slotViw.backgroundColor = #colorLiteral(red: 0.8134699464, green: 0.8940644264, blue: 0.9693123698, alpha: 1)
            }
            cell.timeLbl.text =  obj.time
            
            
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
          if collectionView ==  serviceCollectionViw {
            if servicesArray[indexPath.row].service_id != "" {
                selectedServiceIndex = indexPath.row
                getServiceListFilterDataAPI(service_id: servicesArray[indexPath.row].service_id)
            }
            else
            {
                selectedServiceType = ""
                 selectedServiceIndex = indexPath.row
                getBarbarDiscoverDataAPI()
                
            }
        }
        else
          {
            return
        }
    }
    
    
    
}

extension DiscoverViewController:UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.discoverObjectArray.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier:"DiscoverTableViewCell", for: indexPath) as? DiscoverTableViewCell else {return UITableViewCell()}
        let discoverObject = self.discoverObjectArray[indexPath.row]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
         var closedDate = ""
        if let date =  dateFormatter.date(from: discoverObject.tomorrow_start_time)
        {
            dateFormatter.dateFormat = "HH:mm a"
            closedDate = dateFormatter.string(from: date)
            if closedDate == "00:00 AM" {
                closedDate = "12:00 AM"
            }
        }
        cell.timerCollectionView.delegate = self
        cell.timerCollectionView.dataSource = self
        cell.timerCollectionView.tag = indexPath.row
        cell.timerCollectionView.reloadData()
        cell.avgRatingLbl.text = discoverObject.avg_rating
        cell.ratingLbl.text = discoverObject.avg_rating
        cell.barbarNameLbl.text = discoverObject.barber_name
        cell.salonAddressLbl.text = discoverObject.saloon_location
        cell.nationalityLbl.text = discoverObject.nationality
        cell.numberOfCustomerLbl.text = discoverObject.total_customer
        cell.shopNameLbl.text = ((discoverObject.service_type == "Freelancer") || (discoverObject.service_type ==  ""))  ? "Freelancer" : discoverObject.saloon_name
        cell.serviceTypeLbl.text = discoverObject.provide_home_service == "1" ? "Home Service" : "Salon Service"
       let result = compareTime(time: discoverObject.barber_clsoe_time)
        cell.salonStatusLbl.text = result ? "CLOSED : Opens at " + closedDate : "OPEN"
        cell.salonStatusLbl.textColor = result ? UIColor(red: 1.00, green: 0.00, blue: 0.00, alpha: 1.00) : UIColor(red: 23/255.0, green: 205/255.0, blue: 151/255.0, alpha: 1.00)
        cell.coverImgViw.sd_setImage(with: URL(string: discoverObject.additional_info), completed: nil)
        return cell
        
        
        
    }
    
    
}


extension DiscoverViewController : UITextFieldDelegate
{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let newString = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        print(newString)
        if newString.count > 1 {
             getSearchFilterDataAPI(search: newString)
        }
        else
        {
            if newString == "" {
                getBarbarDiscoverDataAPI()
            }
        }
       
     return true
    }
    
   
    
}

extension DiscoverViewController : FilterViewControllerProtocol
{
    func updateView(filter_param: [String : Any]) {
        if filter_param.count > 0 {
            print(filter_param)
            applyFilterDataAPI(param: filter_param)
        }
        else
        {
            getBarbarDiscoverDataAPI()
        }
        self.filter_param = filter_param
    }
    
    
}

class TimeObj: NSObject {
    var time:String = ""
    var isSelected:Bool = false
}

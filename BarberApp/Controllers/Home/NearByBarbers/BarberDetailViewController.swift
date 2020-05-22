//
//  BarberDetailViewController.swift
//  BarberApp
//
//  Created by iOS8 on 17/03/20.
//  Copyright © 2020 iOS8. All rights reserved.
//

import UIKit
import GoogleMaps
import Alamofire
import SDWebImage

class BarberDetailViewController: UIViewController , GMSMapViewDelegate {
    @IBOutlet weak var tableViw: UITableView!
    
    @IBOutlet weak var datePickerMainView: UIView!
    @IBOutlet var scheduleAppintmentViw: UIView!
    var barberDetailsObject : BarberDetailsObject?
    var service_provider_id = "85"
    var availableTimeSlots = ["01 AM", "02 AM", "03 AM" ,"10 AM" ,"11 AM", "12 PM" , "03 PM" , "04 PM", "07 PM",]
    var instagramImagesArray = [String]()
    var instagramUserName = ""
    var sliderImages = [UIImage(named:"barberSample"), UIImage(named:"barberSample"), UIImage(named:"barberSample")]
    var totalPrice = 0.0
    override func viewDidLoad() {
        super.viewDidLoad()
        getBarbarDiscoverDataAPI()
        self.scheduleAppintmentViw.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        // Do any additional setup after loading the view.
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
        
        print(array.map{$0.time})
        return array
    }
    
    @IBAction func scheduleViewTapAction(_ sender: UITapGestureRecognizer) {
        //        if sender.view == self.datePickerMainView {
        //            return
        //        }
        //        else{
        //           self.scheduleAppintmentViw.isHidden = true
        //        }
        
    }
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func bookNowAction(_ sender: Any) {
        self.scheduleAppintmentViw.isHidden = false
    }
    @IBAction func continueAction(_ sender: Any) {
        self.scheduleAppintmentViw.isHidden = true
        let alertController =  UIAlertController(title:"Home Service" , message: "This barber offers home services for the selected services you picked. Would you like to receive your service at home or at the Salon?", preferredStyle: .alert)
        let homeAction = UIAlertAction(title:"Home Service", style: .default) { (action) in
            
            
            
            if #available(iOS 13.0, *) {
                let vc = homeStoryBoard.instantiateViewController(identifier:"CustomerAddressViewController") as! CustomerAddressViewController
                self.navigationController?.pushViewController(vc, animated: true)
                
            } else {
                // Fallback on earlier versions
                
                let vc = homeStoryBoard.instantiateViewController(withIdentifier:"CustomerAddressViewController") as! CustomerAddressViewController
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        }
        let saloonAction = UIAlertAction(title:"Salon Service", style: .default) { (action) in
        }
        alertController.addAction(homeAction)
        alertController.addAction(saloonAction)
        self.present(alertController, animated: true, completion:nil)
        
    }
    
    
    // MARK: - Api Methods
    
    func updateLikeStatusAPI()   {
        if ProjectManager.sharedInstance.isInternetAvailable()
        {
            
            if let apiToken = UserDefaults.standard.value(forKey: DefaultsIdentifier.apiToken) as? String {
                
                let params = ["service_provider_id":service_provider_id,"like_status":barberDetailsObject!.like_status, "ip_address":barberDetailsObject!.ip_address] as [String: Any]
                //            print(params)
                //            DispatchQueue.main.async {
                ProjectManager.sharedInstance.showLoader(vc: self)
                //            }
                
                let headers = [
                    "Authorization": "Bearer " + apiToken]
                
                //"Accept": "application/json"
                print(headers)
                
                Alamofire.request(Base_Url+update_like_status_url, method: .post,  parameters: params, encoding: URLEncoding.default, headers:headers)
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
                            
                            self.tableViw.reloadData()
                            
                            
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
    
    
    func getInstagramMediaIdApi() {
        if ProjectManager.sharedInstance.isInternetAvailable()
        {
            print(instagram_media_api + barberDetailsObject!.instagram_token)
            
            Alamofire.request(instagram_media_api + barberDetailsObject!.instagram_token)
                .responseJSON { response in
                    
                    
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
                    
                    
                    if let array = json["data"] as? NSArray , array.count > 0 {
                        self.instagramUserName = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "username", dict: (array[0] as! [String:Any]) as NSDictionary) as String
                        self.instagramImagesArray = ProjectManager2.sharedInstance.getInstagramMediaData(array: array)
                        
                        
                    }
                    
                    self.tableViw.reloadData()
                    
            }
            
        }
        else {
            DispatchQueue.main.async(execute: {
                
                ProjectManager.sharedInstance.showAlertwithTitle(title: "Internet connection lost", desc: "Please check your internet connection.", vc: self)
            })
        }
    }
    
    func getBarbarDiscoverDataAPI()
    {
        if ProjectManager.sharedInstance.isInternetAvailable()
        {
            
            if let apiToken = UserDefaults.standard.value(forKey: DefaultsIdentifier.apiToken) as? String {
                
                let params = ["service_provider_id":service_provider_id ] as [String: Any]
                //            print(params)
                //            DispatchQueue.main.async {
                ProjectManager.sharedInstance.showLoader(vc: self)
                //            }
                
                let headers = [
                    "Authorization": "Bearer " + apiToken]
                
                //"Accept": "application/json"
                print(headers)
                
                Alamofire.request(Base_Url+barber_detail_url, method: .post,  parameters: params, encoding: URLEncoding.default, headers:headers)
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
                            
                            if let dataDict = json["data"] as? [String:Any] , dataDict.count > 0 {
                                
                                let data = ProjectManager2.sharedInstance.getBarberDetailsData(dict: dataDict)
                                self.barberDetailsObject = data
                                //  self.addTimeSlots()
                                self.barberDetailsObject!.timeSlots = self.getTimeSlots()
                            }
                            
                            self.getInstagramMediaIdApi()
                            
                            self.tableViw.reloadData()
                            
                            
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
    
    
    
    
    //MARK: - Selectors
    
    
    func createBookingTimeSlots(bookingTimeArray:[BookingTimeObject])  {
        
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
                    
                    let tmpTimeSlots = barberDetailsObject!.timeSlots
                    
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
                    barberDetailsObject!.timeSlots = tmpTimeSlots
                    
                }
            }
            
        }
        
    }
    
    func navigateToDiscoverBarberVC(provider_id :String = "",distance :String = "",saloon_lat :String = "",saloon_long :String = "",rating :String = "")  {
        
        var vc : DiscoverViewController!
        if #available(iOS 13.0, *) {
            
            vc = (homeStoryBoard.instantiateViewController(identifier:"DiscoverViewController") as! DiscoverViewController)
            
        } else {
            // Fallback on earlier versions
            
            vc = (homeStoryBoard.instantiateViewController(withIdentifier:"DiscoverViewController") as! DiscoverViewController)
        }
        
        
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    @objc func likeStatusBtnAction()
    {
        barberDetailsObject!.like_status = barberDetailsObject!.like_status == "1" ? "0" : "1"
        if let cell = tableViw.cellForRow(at: IndexPath(row: 0, section: 0)) as? TopSliderTableViewCell
        {
            cell.likeStatusBtn.setImage( barberDetailsObject!.like_status == "1" ? #imageLiteral(resourceName: "fav") : #imageLiteral(resourceName: "dislike") , for: .normal)
        }
        updateLikeStatusAPI()
    }
    
    @objc func seeAllBtnAction()
    {
        navigateToDiscoverBarberVC()
    }
    
    @objc func shareBtnAction()
    {
        let text = "This is the text...."
        //           let image = UIImage(named: "Product")
        //           let myWebsite = NSURL(string:"https://stackoverflow.com/users/4600136/mr-javed-multani?tab=profile")
        let shareAll = [text ] as [Any]
        let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @objc func serviceSwitchBtnAction(_ sender: UISwitch)
    {
        print(sender.tag)
        updateServiceListArray(index: sender.tag)
    }
    
    func updateServiceListArray(index:Int)  {
        if let obj = barberDetailsObject
        {
            let serviceObj = obj.service_list_array[index]
            serviceObj.isSelected =  serviceObj.isSelected == "1" ? "0": "1"
            obj.service_list_array[index] = serviceObj
            
            if serviceObj.isSelected == "1" {
                totalPrice +=  serviceObj.price
            }
            else
            {
                totalPrice -=  serviceObj.price
            }
            
            if let timeScheduleCell = tableViw.cellForRow(at: IndexPath(row: 0, section: 3)) as? TimeScheduleCell
            {
                timeScheduleCell.totalPriceLbl.text = "Total: \(totalPrice) QAR"
            }
            
            if let serviceDetailCell = tableViw.cellForRow(at: IndexPath(row: index, section: 4)) as? ServiceDetailCell
            {
                serviceDetailCell.serviceSwitchBtn.isOn = serviceObj.isSelected == "1" ? true : false
                 serviceDetailCell.servicePriceLbl.textColor = serviceObj.isSelected == "1" ?  #colorLiteral(red: 0.8941176471, green: 0.5607843137, blue: 0.1764705882, alpha: 1) : #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            }
            
            // tableViw.reloadData()
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
    
    
    func getAvailableTimeString(array:[ScheduleObject]) -> String {
        var resultStr = ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "hh:mm a"
        
        for time in array {
            if let fromDate = dateFormatter.date(from: time.time_from), let toDate = dateFormatter.date(from: time.time_to)
            {
                if resultStr.isEmpty
                {
                    resultStr = dateFormatter2.string(from: fromDate) + " - " + dateFormatter2.string(from: toDate)
                }
                else
                {
                    resultStr += ", " + dateFormatter2.string(from: fromDate) + " - " + dateFormatter2.string(from: toDate)
                }
            }
        }
        
        return resultStr
    }
    
    func openInstagram()  {
        let appURL = URL(string:  "instagram://user?username=\(instagramUserName)")
        let webURL = URL(string:  "https://instagram.com/\(instagramUserName)")
        
        if UIApplication.shared.canOpenURL(appURL!) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(appURL!, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(appURL!)
            }
        } else {
            //redirect to safari because the user doesn't have Instagram
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(webURL!, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(webURL!)
            }
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
extension BarberDetailViewController:UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 4 {
            return (barberDetailsObject?.service_list_array.count)!
        }
        else if section == 2
        {
            return (barberDetailsObject?.barber_availTime.count)!
        }
            else if section == 6
        {
            return barberDetailsObject!.barber_rating.count > 0 ? 1 : 0
        }
            else if section == 7
               {
                   return barberDetailsObject!.recommendedBarberList.count > 0 ? 1 : 0
               }
        else {
            return 1
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return barberDetailsObject != nil ? 8 : 0
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier:"TopSliderTableViewCell", for: indexPath) as? TopSliderTableViewCell else {return UITableViewCell()}
            if let obj = barberDetailsObject
            {
                cell.slideImgArray = obj.additional_info
                cell.setUpViewInScrollView()
                cell.serviceTypeLbl.text =  "\(obj.home_service == "1" ? "Home" : "Salon") Service"
                cell.barberNameLbl.text = obj.first_name + " " + obj.family_name
                cell.addressLbl.text = obj.saloon_location
                cell.nationalityLbl.text = obj.nationality
                cell.numberOfCustomerLbl.text = obj.total_customer
                cell.avgRatingLbl.text = "\(obj.avg_rating) Rating"
                cell.shopTypeLbl.text = (obj.service_type == "" || obj.service_type == "Freelancer") ? "Freelancer" : obj.saloon_name
              //  cell.likeStatusBtn.setImage( barberDetailsObject!.like_status == "1" ? #imageLiteral(resourceName: "fav") : #imageLiteral(resourceName: "dislike") , for: .normal)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "HH:mm:ss"
                var  openDate = ""
                if let date =  dateFormatter.date(from: obj.tomorrow_start_time)
                {
                    dateFormatter.dateFormat = "HH:mm a"
                    
                    openDate = dateFormatter.string(from: date)
                    if openDate == "00:00 AM" {
                        openDate = "12:00 AM"
                    }
                }
                let result = compareTime(time: obj.recommendedBarberList[indexPath.item].barber_clsoe_time)
                cell.salonOpenStatusLbl.text = result ? "CLOSED : Opens at " + openDate : "OPEN"
                cell.salonOpenStatusLbl.textColor = result ? UIColor(red: 1.00, green: 0.00, blue: 0.00, alpha: 1.00) : UIColor(red: 23/255.0, green: 205/255.0, blue: 151/255.0, alpha: 1.00)
                cell.likeStatusBtn.addTarget(self, action: #selector(likeStatusBtnAction), for: .touchUpInside)
                cell.shareBtn.addTarget(self, action: #selector(shareBtnAction), for: .touchUpInside)
                
            }
            
            
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier:"MiddleInstagramCell", for: indexPath) as? MiddleInstagramCell else {return UITableViewCell()}
            let width = (UIScreen.main.bounds.size.width - 70)/3
            cell.instaCollectionViw.tag = indexPath.section
            if instagramImagesArray.count > 0 {
                 cell.instaPhotoTitleLbl.text = "\(instagramImagesArray.count) Instagram Photos"
                 cell.pageControl.isHidden = false
                cell.collectionHeightConstraint.constant = (width * 2) + 10
            }
            else
            {
                 cell.instaPhotoTitleLbl.text = ""
                cell.pageControl.isHidden = true
                cell.collectionHeightConstraint.constant = 0
            }
           
            if instagramImagesArray.count > 12 {
                cell.pageControl.numberOfPages = 3
            }
            else if instagramImagesArray.count > 6
            {
                cell.pageControl.numberOfPages = 2
            }
            else
            {
                cell.pageControl.numberOfPages = 1
            }
            cell.instaCollectionViw.reloadData()
            
            if let obj = barberDetailsObject
            {
                cell.aboutTitleLbl.text = "About " + obj.first_name
                cell.aboutDescriptionLbl.text = obj.about
                
            }
            cell.selectionStyle = .none
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier:"AvailablityCell", for: indexPath) as? AvailablityCell else {return UITableViewCell()}
            if let obj = barberDetailsObject
            {
                cell.availableTimeLbl.text = "\(obj.barber_availTime[indexPath.row].day) : \(  obj.barber_availTime[indexPath.row].day_off_status == "1" ?  getAvailableTimeString(array: obj.barber_availTime[indexPath.row].time_slots) : "OFF")"
            }
            cell.selectionStyle = .none
            return cell
        case 3:
            guard let cell = tableView.dequeueReusableCell(withIdentifier:"TimeScheduleCell", for: indexPath) as? TimeScheduleCell else {return UITableViewCell()}
            cell.slotsCollectionViw.tag = indexPath.section
            cell.totalPriceLbl.text = "Total: \(totalPrice) QAR"
            return cell
        case 4:
            guard let cell = tableView.dequeueReusableCell(withIdentifier:"ServiceDetailCell", for: indexPath) as? ServiceDetailCell else {return UITableViewCell()}
            if let obj = barberDetailsObject
            {
                cell.serviceNameLbl.text = obj.service_list_array[indexPath.row].name
                cell.servicePriceLbl.text = " / \(obj.service_list_array[indexPath.row].price) QAR"
                cell.serviceSwitchBtn.isOn = obj.service_list_array[indexPath.row].isSelected == "1" ? true : false
                cell.servicePriceLbl.textColor = obj.service_list_array[indexPath.row].isSelected == "1" ?  #colorLiteral(red: 0.8941176471, green: 0.5607843137, blue: 0.1764705882, alpha: 1) : #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                cell.serviceSwitchBtn.tag = indexPath.row
                cell.serviceSwitchBtn.addTarget(self, action: #selector(serviceSwitchBtnAction(_:)), for: .valueChanged)
            }
            cell.selectionStyle = .none
            return cell
        case 5:
            guard let cell = tableView.dequeueReusableCell(withIdentifier:"MapCell", for: indexPath) as? MapCell else {return UITableViewCell()}
            
            let lat = barberDetailsObject!.saloon_lat == "" ? 28.7041 : Double(barberDetailsObject!.saloon_lat)
            let long = barberDetailsObject!.saloon_lon == "" ? 28.7041 : Double(barberDetailsObject!.saloon_lon)
            let camera = GMSCameraPosition.camera(withLatitude: lat!, longitude: long!, zoom: 15.0)
            cell.mainViw?.delegate = self
            // Creates a marker in the center of the map.
            let marker = GMSMarker()
            let markerImage = #imageLiteral(resourceName: "markerMap")
            let markerView = UIImageView(image: markerImage)
            marker.iconView = markerView
            marker.position = CLLocationCoordinate2D(latitude: lat!, longitude: long!)
//            marker.title = "Delhi"
//            marker.snippet = "India’s capital"
            marker.map = cell.mainViw
         
            cell.mainViw.camera = camera
            
            return cell
        case 6:
            guard let cell = tableView.dequeueReusableCell(withIdentifier:"RatingTableViewCell", for: indexPath) as? RatingTableViewCell else {return UITableViewCell()}
            cell.ratingViw.roundCorners(corners: [.topRight, .bottomLeft], radius: 8)
            if let obj = barberDetailsObject
            {
                cell.avgRatingLbl.text = "\(obj.avg_rating)"
                cell.ratingCollectionView.reloadData()
                
            }
            return cell
        case 7:
            guard let cell = tableView.dequeueReusableCell(withIdentifier:"RecommendedTableViewCell", for: indexPath) as? RecommendedTableViewCell else {return UITableViewCell()}
            cell.seeAllBtn.setTitle("See all (\(barberDetailsObject!.recommendedBarberList.count))", for: .normal)
            cell.seeAllBtn.addTarget(self, action: #selector(seeAllBtnAction), for: .touchUpInside)
            return cell
        default:
            return UITableViewCell()
        }
        
    }
}
extension BarberDetailViewController:UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView.tag == 1 {
            let width = (UIScreen.main.bounds.size.width - 70)/3
            return CGSize(width:width, height: width)
        } else   if collectionView.tag == 3{
            return CGSize(width:30, height: 63)
        } else {
            return CGSize(width:UIScreen.main.bounds.size.width - 55, height: 140)
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 1 {
            return instagramImagesArray.count
        } else   if collectionView.tag == 3{
            return getTimeSlots().count
        }
        else if collectionView.tag == 5
        {
            return (barberDetailsObject?.barber_rating.count)!
        }
        else {
            return  (barberDetailsObject?.recommendedBarberList.count)!
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 1 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"InstaCollectionCell", for: indexPath) as? InstaCollectionCell else {return UICollectionViewCell()}
            
            cell.imageView.sd_setImage(with: URL(string: instagramImagesArray[indexPath.item]), completed: nil)
            return cell
        } else if collectionView.tag == 3 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "detailTimeSlotCell", for: indexPath) as! TimeSlotCell
            
            createBookingTimeSlots(bookingTimeArray: barberDetailsObject!.booking_time)
            let obj = barberDetailsObject!.timeSlots[indexPath.item]
            if obj.isSelected {
                cell.slotViw.backgroundColor = #colorLiteral(red: 0.2909106016, green: 0.4674310684, blue: 0.6362583041, alpha: 1)
            } else {
                cell.slotViw.backgroundColor = #colorLiteral(red: 0.8134699464, green: 0.8940644264, blue: 0.9693123698, alpha: 1)
            }
            cell.timeLbl.text =  obj.time
            return cell
        } else if collectionView.tag == 5 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RatingCollectionViewCell", for: indexPath) as! RatingCollectionViewCell
            if let obj = barberDetailsObject
            {
                cell.userNameLbl.text = obj.barber_rating[indexPath.item].first_name + " " +  obj.barber_rating[indexPath.item].last_name
                cell.commentLbl.text =  obj.barber_rating[indexPath.item].comment
                cell.ratingView.value = CGFloat(Double(obj.barber_rating[indexPath.item].rating)!)
                
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecommendedCollectionViewCell", for: indexPath) as! RecommendedCollectionViewCell
            cell.ratingViw.roundCorners(corners: [.topRight, .bottomLeft], radius: 10)
            
            if let obj = barberDetailsObject
            {
                cell.addressLbl.text = obj.recommendedBarberList[indexPath.item].saloon_location
                cell.priceLbl.text = obj.recommendedBarberList[indexPath.item].price_range
                cell.userNameLbl.text =  obj.recommendedBarberList[indexPath.item].first_name
                cell.avgRatingLbl.text = obj.recommendedBarberList[indexPath.item].avg_rating
                cell.imageView.sd_setImage(with: URL(string: obj.recommendedBarberList[indexPath.item].additional_info), completed: nil)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "HH:mm:ss"
                var closedDate = "", openDate = ""
                if let date =  dateFormatter.date(from: obj.recommendedBarberList[indexPath.item].tomorrow_start_time), let date2 =  dateFormatter.date(from: obj.recommendedBarberList[indexPath.item].barber_clsoe_time)
                {
                    dateFormatter.dateFormat = "HH:mm a"
                    closedDate = dateFormatter.string(from: date2)
                    if closedDate == "00:00 AM" {
                        closedDate = "12:00 AM"
                    }
                    openDate = dateFormatter.string(from: date)
                    if openDate == "00:00 AM" {
                        openDate = "12:00 AM"
                    }
                }
                let result = compareTime(time: obj.recommendedBarberList[indexPath.item].barber_clsoe_time)
                cell.descLbl.text = obj.recommendedBarberList[indexPath.item].about
                cell.descLbl.numberOfLines = 2
                if obj.recommendedBarberList[indexPath.item].fully_occupied_status == "1" {
                    cell.salonTimeStatusLbl.text = "Fully Occupied"
                    cell.salonTimeStatusLbl.textColor = UIColor(red: 228/255.0, green: 143/255.0, blue: 45/255.0, alpha: 1)
                   
                    
                }
                else
                {
                    cell.salonTimeStatusLbl.text =  result ? "CLOSED " : "OPEN "
                    cell.salonTimeStatusLbl.textColor = result ? UIColor(red: 1.00, green: 0.00, blue: 0.00, alpha: 1.00) : UIColor(red: 23/255.0, green: 205/255.0, blue: 151/255.0, alpha: 1.00)
                   
                }
                 cell.closeTimeLbl.text = result ? "Opens " + openDate : "Closes \(closedDate)"
                
            }
            
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        print(indexPath.item)
        if collectionView.tag == 1 {
            let index = IndexPath(row:0, section: 1)
            if  let cell = self.tableViw.cellForRow(at: index) as? MiddleInstagramCell  {
                if indexPath.item < 6 {
                    cell.pageControl.currentPage = 0
                } else if indexPath.item > 6 &&  indexPath.item <= 12 {
                    cell.pageControl.currentPage = 1
                } else {
                    cell.pageControl.currentPage = 2
                }
            }
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == 1
        {
            self.openInstagram()
        }
        else if collectionView.tag != 5 && collectionView.tag != 3
        {
            var vc : BarberDetailViewController!
                   if #available(iOS 13.0, *) {
                       
                       vc = (homeStoryBoard.instantiateViewController(identifier:"BarberDetailViewController") as! BarberDetailViewController)
                       
                   } else {
                       // Fallback on earlier versions
                       
                       vc = (homeStoryBoard.instantiateViewController(withIdentifier:"BarberDetailViewController") as! BarberDetailViewController)
                   }
                   
                   
                   self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}
extension UIView{
    func animShow(){
        UIView.animate(withDuration: 2, delay: 0, options: [.curveEaseIn],
                       animations: {
                        print(self.center.y)
                        print(self.bounds.height)
                        self.frame.origin.y = 0
                        self.layoutIfNeeded()
        }, completion: nil)
        self.isHidden = false
    }
    func animHide(){
        UIView.animate(withDuration: 2, delay: 0, options: [.curveLinear],
                       animations: {
                        self.center.y += self.bounds.height
                        self.layoutIfNeeded()
                        
                        
        },  completion: {(_ completed: Bool) -> Void in
            self.isHidden = true
        })
    }
}

//
//  FilterViewController.swift
//  BarberApp
//
//  Created by iOS8 on 09/03/20.
//  Copyright © 2020 iOS8. All rights reserved.
//

import UIKit
import Alamofire
import RangeSeekSlider


protocol  FilterViewControllerProtocol {
    func updateView(filter_param:[String:Any])
}

class FilterViewController: UIViewController {
    
    var filterVCDelegate : FilterViewControllerProtocol?
    
    @IBOutlet weak var filterCollectionVow: UICollectionView!
    
    var servicesArray = [ServiceListObject]()
    var tmpServicesArray = [ServiceListObject]()
    var nationalityArray = [NationalityObject]()
    var selectedFilterParam = [String:Any]()
    var headerTitles = ["Service Type" , "Options" , "Price", "Distance" , "Barber Nationality" , "Sort By"]
    var priceFilter = "", serviceAtHome = false, hasCreditCard = false, openNow = false, priceSwitch = false, popularitySwitch = false, ratingSwitch = false
    var isMoreService = Bool()
    var rangeSliderValue = "", rangeMinValue : CGFloat = 0, rangeMaxValue : CGFloat = 0
    override func viewDidLoad() {
        super.viewDidLoad()
           
        getServiceListDataAPI()
        getNationalityListDataAPI()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func resetBtnClick(_ sender: Any) {
        resetAllFilter()
        filterVCDelegate?.updateView(filter_param: [:])
        self.navigationController?.popViewController(animated: true)
        
    }
    @IBAction func doneBtnClicj(_ sender: Any) {
        filterVCDelegate?.updateView(filter_param: getFilterUrl())
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func moreServiceAction()  {
        if !isMoreService {
            isMoreService = true
            tmpServicesArray = servicesArray
            // servicesArray.append(contentsOf: servicesArray)
        } else {
            isMoreService = false
            let arr:[ServiceListObject] = Array( servicesArray.prefix(6))
            tmpServicesArray = arr
        }
        
        filterCollectionVow.reloadData()
        
    }
    
    @objc func cheapPriceBtn()
    {
        
        priceFilter = priceFilter == "$" ? "" : "$"
        
        filterCollectionVow.reloadData()
    }
    
    @objc func mediumPriceBtn()
    {
      priceFilter = priceFilter == "$$" ? "" : "$$"
        filterCollectionVow.reloadData()
    }
    
    @objc func maxPriceBtn()
    {
       priceFilter = priceFilter == "$$$" ? "" : "$$$"
        filterCollectionVow.reloadData()
    }
    
     
    
    @objc func openNowSwitchBtn()
    {
        openNow = !openNow
    }
    @objc func hasCreditCardSwitchBtn()
    {
        hasCreditCard = !hasCreditCard
    }
    @objc func serviceAtHomeSwitchBtn()
    {
        serviceAtHome = !serviceAtHome
    }
    
    
    @objc func popularitySwitchBtn()
    {
        popularitySwitch = !popularitySwitch
    }
    @objc func ratingSwitchBtn()
    {
        ratingSwitch = !ratingSwitch
    }
    @objc func priceSwitchBtn()
    {
        priceSwitch = !priceSwitch
    }
    
    
    func setSelectedFilter()  {
        if selectedFilterParam.count > 0
        {
            priceFilter = selectedFilterParam["price_range"] as! String
            rangeSliderValue = selectedFilterParam["distance"] as! String
            hasCreditCard = selectedFilterParam["avail_credit_card"] as! String == "1" ? true : false
            priceSwitch = selectedFilterParam["sort_by_price"] as! String == "1" ? true : false
            popularitySwitch = selectedFilterParam["sort_by_customers"] as! String == "1" ? true : false
            serviceAtHome = selectedFilterParam["service_at_home"] as! String == "1" ? true : false
            ratingSwitch = selectedFilterParam["sort_by_rating"] as! String == "1" ? true : false

            
            
            if selectedFilterParam["open_now"] != nil
            {
                openNow = true
            }

            if let service_type_id =  selectedFilterParam["service_type_id"] as? String {
                let serviceStrArray = service_type_id.split(separator: ",")
                for service_id in serviceStrArray {
                    servicesArray.map { (item: ServiceListObject) -> ServiceListObject in
                        if item.service_id == service_id {
                            item.isSelected = "1"
                        }
                        return item
                    }
                }
            }
            
            if let  nationality = selectedFilterParam["nationality"]  as? String{
                let nationalityStrArray = nationality.split(separator: ",")
                
                
                
                for num_code in nationalityStrArray {
                    nationalityArray.map { (item: NationalityObject) -> NationalityObject in
                        if item.num_code == num_code {
                            item.isSelected = "1"
                        }
                        return item
                    }
                }
            }
            
            
            if isMoreService {
                
                tmpServicesArray = servicesArray
                // servicesArray.append(contentsOf: servicesArray)
            } else {
                
                let arr:[ServiceListObject] = Array( servicesArray.prefix(6))
                tmpServicesArray = arr
            }
            
            filterCollectionVow.reloadData()
            
        }
        
    }
    
    func resetAllFilter()  {
        nationalityArray.map { (item: NationalityObject) -> NationalityObject in
            item.isSelected = "0"
            return item    }
        servicesArray.map { (item: ServiceListObject) -> ServiceListObject in
            item.isSelected = "0"
            return item    }
        priceFilter = "$"
        rangeSliderValue = ""
        hasCreditCard = false
        priceSwitch =  false
        popularitySwitch = false
        serviceAtHome = false
        if isMoreService {
            
            tmpServicesArray = servicesArray
            // servicesArray.append(contentsOf: servicesArray)
        } else {
            
            let arr:[ServiceListObject] = Array( servicesArray.prefix(6))
            tmpServicesArray = arr
        }
        selectedFilterParam.removeAll()
        filterCollectionVow.reloadData()
    }
    
    
    func getFilterUrl() -> [String:Any] {
        var param = [String:Any]()
        var serviceTypeStr = ""
        let dateFormatter = DateFormatter()
        var nationalityStr = ""
       let (lat,long) = LocationService.sharedInstance.getCurrentLatitudeAnfLongitude()
        print("lat \(lat)  long \(long)")
        for item in servicesArray {
            if item.isSelected == "1" {
                if serviceTypeStr.isEmpty {
                    serviceTypeStr = item.service_id
                }
                else
                {
                    serviceTypeStr += ",\(item.service_id)"
                }
            }
            
        }
        
        for item in nationalityArray {
            if item.isSelected == "1" {
                if nationalityStr.isEmpty {
                    nationalityStr = item.num_code
                }
                else
                {
                    nationalityStr += ",\(item.num_code)"
                }
            }
            
        }
        param = ["price_range":priceFilter,"distance":rangeSliderValue,"avail_credit_card":hasCreditCard ? "1" : "0", "sort_by_price":priceSwitch ? "1" : "0","sort_by_rating":ratingSwitch ? "1" : "0","sort_by_customers": popularitySwitch ? "1" : "0","service_at_home": serviceAtHome ? "1" : "0","user_lat": lat == 0.0 ? "37.42199" : "\(lat)" ,"user_lon": long == 0.0 ? "122.0840"  : "\(long)"  ]
        
        dateFormatter.dateFormat = "HH:mm:ss"
        let todayDate = dateFormatter.string(from: Date())
        if openNow {
            param["open_now"] = todayDate
        }
        
        if !serviceTypeStr.isEmpty {
            param["service_type_id"] = serviceTypeStr
        }
        
        if !nationalityStr.isEmpty {
            param["nationality"] = nationalityStr
        }
        
        
        return param
        
        //        service_type_id=1,2,4,5&open_now=14:32:06&price_range=$$&distance=3-18&nationality=250&user_lat=37.421998333333335&user_lon=-122.08400000000002&avail_credit_card=1&sort_by_price=1&sort_by_rating=1&sort_by_customers=1&service_at_home=1
        
    }
    
    //MARK:API CAlls
    
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
                                let arr:[ServiceListObject] = Array( self.servicesArray.prefix(6))
                                self.tmpServicesArray = arr
                                
                            }
                            
                            
                            self.filterCollectionVow.reloadData()
                            self.setSelectedFilter()
                            
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
    
    func getNationalityListDataAPI()
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
                
                Alamofire.request(Base_Url+filter_countries_list_url, method: .post,  parameters: nil, encoding: URLEncoding.default, headers:headers)
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
                                
                                let array = ProjectManager2.sharedInstance.getNationalityListData(array: dataArray)
                                self.nationalityArray = array
                                //                                      let arr:[ServiceListObject] = Array( self.servicesArray.prefix(6))
                                //                                      self.tmpServicesArray = arr
                                
                            }
                            
                            
                            self.filterCollectionVow.reloadData()
                            self.setSelectedFilter()
                            
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
    
    
    func updateServiceListArray(service_id :String)  {
        
        servicesArray.map { (item : ServiceListObject) -> ServiceListObject in
            if item.service_id == service_id
            {
                if item.isSelected == "0" {
                    item.isSelected = "1"
                }
                else
                {
                    item.isSelected = "0"
                }
            }
            return item
        }
        if isMoreService {
            
            tmpServicesArray = servicesArray
            // servicesArray.append(contentsOf: servicesArray)
        } else {
            
            let arr:[ServiceListObject] = Array( servicesArray.prefix(6))
            tmpServicesArray = arr
        }
        
        filterCollectionVow.reloadData()
    }
    
    func updateNationalityListArray(num_code :String)  {
        
        nationalityArray.map { (item : NationalityObject) -> NationalityObject in
            if item.num_code == num_code
            {
                if item.isSelected == "0" {
                    item.isSelected = "1"
                }
                else
                {
                    item.isSelected = "0"
                }
            }
            return item
        }
        
        
        filterCollectionVow.reloadData()
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


extension FilterViewController: UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
            
        case UICollectionView.elementKindSectionHeader:
            
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "FilterHeaderView", for: indexPath) as! FilterHeaderView
            
            headerView.headerTitle.text = headerTitles[indexPath.section]
            return headerView
            
        case UICollectionView.elementKindSectionFooter:
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "FilterFooterView", for: indexPath) as! FilterHeaderView
            if indexPath.section == 0 {
                footerView.dropdown.isHidden = false
                footerView.moreServiceLbl.isHidden = false
                footerView.moreServiceBtn.isHidden = false
                if isMoreService {
                    footerView.moreServiceLbl.text = "less services"
                } else {
                    footerView.moreServiceLbl.text = "more services"
                }
                footerView.moreServiceBtn.addTarget(self, action: #selector(moreServiceAction), for: .touchUpInside)
                
            } else {
                footerView.dropdown.isHidden = true
                footerView.moreServiceLbl.isHidden = true
                footerView.moreServiceBtn.isHidden = true
            }
            return footerView
            
        default:
            
            
            assert(false, "Unexpected element kind")
        }
        
        return  UICollectionReusableView()
        
        
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return headerTitles.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return tmpServicesArray.count
        case 1:
            return 1
        case 2:
            return 1
        case 3:
            return 1
        case 4:
            return nationalityArray.count
        case 5:
            return 1
        default:
            return 0
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0 :
            let size = tmpServicesArray[indexPath.item].name.size(withAttributes: [NSAttributedString.Key.font: UIFont(name: "Avenir-Medium", size: 13.0)! ])
            
            return CGSize(width:size.width + 40, height:35)
            
        case 1 :
            return CGSize(width:UIScreen.main.bounds.size.width - 40, height:112)
            
        case 2 :
            return CGSize(width:UIScreen.main.bounds.size.width - 40, height:52)
            
        case 3 :
            return CGSize(width:UIScreen.main.bounds.size.width - 40, height:52)
        case 4 :
            let size = nationalityArray[indexPath.item].nationality.size(withAttributes: [NSAttributedString.Key.font: UIFont(name: "Avenir-Medium", size: 13.0)! ])
            return CGSize(width:size.width + 40, height:35)
        case 5 :
            return CGSize(width:UIScreen.main.bounds.size.width - 40, height:112)
        default:
            return CGSize.zero
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize(width: UIScreen.main.bounds.size.width - 40, height: 65)
        } else {
            return CGSize(width: UIScreen.main.bounds.size.width - 40, height: 30)
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0 :
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"FilterCollectionViewCell", for: indexPath)  as? FilterCollectionViewCell else {
                return UICollectionViewCell()
            }
            if tmpServicesArray[indexPath.item].isSelected == "1" {
                cell.serviceNameLbl.textColor = .white
                cell.outerViw.backgroundColor = #colorLiteral(red: 0.1309883595, green: 0.2987812161, blue: 0.5047755837, alpha: 1)
            } else {
                cell.outerViw.backgroundColor = #colorLiteral(red: 0.8758473396, green: 0.9036368132, blue: 0.9300265908, alpha: 1)
                cell.serviceNameLbl.textColor = .black
            }
            
            cell.serviceNameLbl.text = tmpServicesArray[indexPath.item].name
            
            return cell
        case 1:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"OptionsCollectionViewCell", for: indexPath)  as? OptionsCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            cell.serviceAtHomeSwitchBtn.isOn = serviceAtHome
            cell.hasCreditCardSwitchBtn.isOn = hasCreditCard
            cell.openNowSwitchBtn.isOn = openNow
            cell.serviceAtHomeSwitchBtn.addTarget(self, action: #selector(serviceAtHomeSwitchBtn), for: .valueChanged)
            cell.hasCreditCardSwitchBtn.addTarget(self, action: #selector(hasCreditCardSwitchBtn), for: .valueChanged)
            cell.openNowSwitchBtn.addTarget(self, action: #selector(openNowSwitchBtn), for: .valueChanged)
            
            return cell
            
        case 2:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"PriceCollectionViewCell", for: indexPath)  as? PriceCollectionViewCell else {
                return UICollectionViewCell()
            }
            let titleColor = UIColor(red: 242/255.0, green: 242/255.0, blue: 242/255.0, alpha: 1)
            if priceFilter == "$" {
                cell.cheapPriceBtn.backgroundColor = #colorLiteral(red: 0.1309883595, green: 0.2987812161, blue: 0.5047755837, alpha: 1)
                cell.mediumPriceBtn.backgroundColor = #colorLiteral(red: 0.8758473396, green: 0.9036368132, blue: 0.9300265908, alpha: 1)
                cell.maxPriceBtn.backgroundColor = #colorLiteral(red: 0.8758473396, green: 0.9036368132, blue: 0.9300265908, alpha: 1)
                cell.cheapPriceBtn.setTitleColor(titleColor, for: .normal)
                cell.mediumPriceBtn.setTitleColor(.black, for: .normal)
                cell.maxPriceBtn.setTitleColor(.black, for: .normal)
                
            }
            else if priceFilter == "$$"
            {
                cell.mediumPriceBtn.backgroundColor = #colorLiteral(red: 0.1309883595, green: 0.2987812161, blue: 0.5047755837, alpha: 1)
                cell.cheapPriceBtn.backgroundColor = #colorLiteral(red: 0.8758473396, green: 0.9036368132, blue: 0.9300265908, alpha: 1)
                cell.maxPriceBtn.backgroundColor = #colorLiteral(red: 0.8758473396, green: 0.9036368132, blue: 0.9300265908, alpha: 1)
                cell.mediumPriceBtn.setTitleColor(titleColor, for: .normal)
                cell.maxPriceBtn.setTitleColor(.black, for: .normal)
                cell.cheapPriceBtn.setTitleColor(.black, for: .normal)
            }
            else if priceFilter == "$$$"
            {
                cell.maxPriceBtn.backgroundColor = #colorLiteral(red: 0.1309883595, green: 0.2987812161, blue: 0.5047755837, alpha: 1)
                cell.mediumPriceBtn.backgroundColor = #colorLiteral(red: 0.8758473396, green: 0.9036368132, blue: 0.9300265908, alpha: 1)
                cell.cheapPriceBtn.backgroundColor = #colorLiteral(red: 0.8758473396, green: 0.9036368132, blue: 0.9300265908, alpha: 1)
                
                cell.maxPriceBtn.setTitleColor(titleColor, for: .normal)
                cell.mediumPriceBtn.setTitleColor(.black, for: .normal)
                cell.cheapPriceBtn.setTitleColor(.black, for: .normal)
                
            }
            else
            {
               
                cell.maxPriceBtn.backgroundColor = #colorLiteral(red: 0.8758473396, green: 0.9036368132, blue: 0.9300265908, alpha: 1)
                 cell.mediumPriceBtn.backgroundColor = #colorLiteral(red: 0.8758473396, green: 0.9036368132, blue: 0.9300265908, alpha: 1)
                cell.cheapPriceBtn.backgroundColor = #colorLiteral(red: 0.8758473396, green: 0.9036368132, blue: 0.9300265908, alpha: 1)
                
                cell.maxPriceBtn.setTitleColor(.black, for: .normal)
                cell.mediumPriceBtn.setTitleColor(.black, for: .normal)
                cell.cheapPriceBtn.setTitleColor(.black, for: .normal)
            }
            
            cell.cheapPriceBtn.addTarget(self, action: #selector(cheapPriceBtn), for: .touchUpInside)
            cell.mediumPriceBtn.addTarget(self, action: #selector(mediumPriceBtn), for: .touchUpInside)
            cell.maxPriceBtn.addTarget(self, action: #selector(maxPriceBtn), for: .touchUpInside)
            return cell
        case 3:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"DistanceCollectionViewCell", for: indexPath)  as? DistanceCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.rangeSlider.minLabelFont = UIFont(name:"Avenir-Medium", size: 14)!
            cell.rangeSlider.maxLabelFont = UIFont(name:"Avenir-Medium", size: 14)!
            
            cell.rangeSlider.delegate = self
            if rangeMaxValue != 0 && rangeMinValue != 0 {
                cell.rangeSlider.selectedMinValue = rangeMinValue
                cell.rangeSlider.selectedMaxValue = rangeMaxValue
            }
           
       
            
            return cell
        case 4 :
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"FilterCollectionViewCell", for: indexPath)  as? FilterCollectionViewCell else {
                return UICollectionViewCell()
            }
            if nationalityArray[indexPath.item].isSelected == "1" {
                cell.serviceNameLbl.textColor = .white
                cell.outerViw.backgroundColor = #colorLiteral(red: 0.1309883595, green: 0.2987812161, blue: 0.5047755837, alpha: 1)
            } else {
                cell.outerViw.backgroundColor = #colorLiteral(red: 0.8758473396, green: 0.9036368132, blue: 0.9300265908, alpha: 1)
                cell.serviceNameLbl.textColor = .black
            }
            
            cell.serviceNameLbl.text = nationalityArray[indexPath.item].nationality
            
            return cell
            
            
        case 5:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"SortCollectionViewCell", for: indexPath)  as? SortCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.priceSwitchBtn.isOn = priceSwitch
            cell.ratingSwitchBtn.isOn = ratingSwitch
            cell.popularitySwitchBtn.isOn = popularitySwitch
            cell.priceSwitchBtn.addTarget(self, action: #selector(priceSwitchBtn), for: .valueChanged)
            cell.ratingSwitchBtn.addTarget(self, action: #selector(ratingSwitchBtn), for: .valueChanged)
            cell.popularitySwitchBtn.addTarget(self, action: #selector(popularitySwitchBtn), for: .valueChanged)
            return cell
        default:
            return UICollectionViewCell()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            
            updateServiceListArray(service_id: tmpServicesArray[indexPath.row].service_id)
            break;
            
        case 4:
            updateNationalityListArray(num_code: nationalityArray[indexPath.row].num_code)
        default:
            return
        }
    }
    
    
}
//D

extension FilterViewController : RangeSeekSliderDelegate
{
    
    func rangeSeekSlider(_ slider: RangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat) {
      
        rangeMinValue = minValue
               rangeMaxValue = maxValue
        rangeSliderValue = "\(Double(minValue))-\(Double(maxValue))"
               print("Standard slider updated. Min Value: \(minValue) Max Value: \(maxValue)")
          
       }
    
   
     
}

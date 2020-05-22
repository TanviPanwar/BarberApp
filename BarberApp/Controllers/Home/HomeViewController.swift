//
//  HomeViewController.swift
//  BarberApp
//
//  Created by iOS8 on 06/03/20.
//  Copyright © 2020 iOS8. All rights reserved.
//

import UIKit
import Alamofire

class HomeViewController: UIViewController {
    
    @IBOutlet weak var mainTableView: UITableView!
    
    var objc  = LoginObject()
    var myBarberArray = [HomeObject]()
    var serviceListArray = [HomeObject]()
    var topBarberArray = [HomeObject]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
        
        homeDataApi()
    }
    
    // MARK: - Custom Methods
    
    @objc func navigateToSeeAllBarbers()  {
        
        if #available(iOS 13.0, *) {
            
            let vc = homeStoryBoard.instantiateViewController(identifier:"TopNearByBarbersController") as! TopNearByBarbersController
            self.navigationController?.pushViewController(vc, animated: true)

        } else {
            // Fallback on earlier versions
            
            let vc = homeStoryBoard.instantiateViewController(withIdentifier:"TopNearByBarbersController") as! TopNearByBarbersController
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    // MARK: - IB Actions
    
    @IBAction func bacKAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    // MARK: - Api Methods
    
    func homeDataApi()
    {
        if ProjectManager.sharedInstance.isInternetAvailable()
        {
            
             if let apiToken = UserDefaults.standard.value(forKey: DefaultsIdentifier.apiToken) as? String {
            
            //            let params = ["phone_number":objc.phone_number , "country_code":objc.country_code] as [String: Any]
            //            print(params)
//            DispatchQueue.main.async {
//                 ProjectManager.sharedInstance.showLoader(vc: self)
//            }
            
            let headers = [
                "Authorization": "Bearer " + apiToken]
            
            //"Accept": "application/json"
           print(headers)
            
            Alamofire.request(Base_Url+homeDataUrl, method: .post,  parameters: nil, encoding: URLEncoding.default, headers:headers)
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
                        
                        if let myBarber = json["my_barber"] as? NSArray , myBarber.count > 0 {
                            
                            let array = ProjectManager.sharedInstance.GetOnBoardingObjects(array: myBarber)
                            //self.myBarberArray = array
                            
                        }
                        
                        if let serviceList = json["service_list"] as? NSArray , serviceList.count > 0 {
                            
                            let array = ProjectManager.sharedInstance.GetHomeDataServiceListObjects(array: serviceList)
                            self.serviceListArray = array

                            
                        }
                        
                        if let topBarber = json["top_barber"] as? NSArray , topBarber.count > 0 {
                            
                            let array = ProjectManager.sharedInstance.GetHomeDataTopBarberListObjects(array: topBarber)
                            self.topBarberArray = array

                            
                        }
                        
                        self.mainTableView.reloadData()
                        
                        
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

    
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
extension HomeViewController:UITableViewDelegate , UITableViewDataSource {
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = (UIScreen.main.bounds.size.width - 120)/4
        switch indexPath.section {
        case 0:
            return height + 95
        case 1:
            return ((height + 47) * 2) + 60
        default:
            return UITableView.automaticDimension
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return topBarberArray.count
        default:
            return 0
        }
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 2 {
            return 60
        } else {
            return 0
        }
        
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 2 {
            
            let viw = UIView(frame: CGRect(x:0, y: 0, width: UIScreen.main.bounds.size.width, height: 60))
            viw.backgroundColor = .white
            let titleLbl = UILabel(frame: CGRect(x:30, y: 10, width: 210, height: 45))
            titleLbl.text = "Top Nearby Barbers"
            titleLbl.font = UIFont(name:"Avenir-Heavy", size: 21)
            titleLbl.textAlignment = .left
            let seeAllBtn = UIButton(frame: CGRect(x:UIScreen.main.bounds.size.width - 150, y: 18, width: 120, height: 25))
            seeAllBtn.contentHorizontalAlignment = .right
            seeAllBtn.titleLabel?.textAlignment = .right
            seeAllBtn.setTitle("See all (177)", for: .normal)
            seeAllBtn.titleLabel?.font = UIFont(name:"Avenir-Medium", size: 15)
            seeAllBtn.setTitleColor(.darkGray, for: .normal)
            seeAllBtn.addTarget(self, action: #selector(navigateToSeeAllBarbers), for: .touchUpInside)
            viw.addSubview(titleLbl)
            viw.addSubview(seeAllBtn)
            return viw
        } else {
            return UIView()
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier:"MyBarbersTableCell", for: indexPath) as? MyBarbersTableCell else {return UITableViewCell()}
            cell.mybarbersCollectionViw.tag = indexPath.section
            cell.sectionLbl.text = "My Barbers"
            cell.seeAllBtn.isHidden = true
            if let flowLayout = cell.mybarbersCollectionViw.collectionViewLayout as? UICollectionViewFlowLayout {
                flowLayout.scrollDirection = .horizontal
                
            }
            return cell
            
            
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier:"MyBarbersTableCell", for: indexPath) as? MyBarbersTableCell else {return UITableViewCell()}
            cell.mybarbersCollectionViw.tag = indexPath.section
            cell.sectionLbl.text = "Services"
            cell.seeAllBtn.isHidden = false
            if let flowLayout = cell.mybarbersCollectionViw.collectionViewLayout as? UICollectionViewFlowLayout {
                flowLayout.minimumLineSpacing = 10
                flowLayout.scrollDirection = .vertical
            }
            
            cell.mybarbersCollectionViw.reloadData()
            return cell
            
            
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier:"NearbyBarbersCell", for: indexPath) as? NearbyBarbersCell else {return UITableViewCell()}
            
            cell.userImgViw.sd_setImage(with: URL(string : self.topBarberArray[indexPath.row].image), placeholderImage:nil, options: [.cacheMemoryOnly]) { (image, error, cache, url) in

            }
            cell.barberNameLabel.text = topBarberArray[indexPath.row].barber_name
            cell.barberAddressLabel.text = topBarberArray[indexPath.row].saloon_location
            cell.barberNationalityLabel.text = topBarberArray[indexPath.row].nationality + " Provides " + topBarberArray[indexPath.row].service_type + " service"
             cell.closeStatusLabel.text = "Closes " + topBarberArray[indexPath.row].barber_close_time
            cell.ratingLabel.text = topBarberArray[indexPath.row].avg_rating
            
            
          
            return cell
            
            
        default:
            return UITableViewCell()
        }
        
    }
    
    
    
}

extension HomeViewController:UICollectionViewDelegate , UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (UIScreen.main.bounds.size.width - 120)/4
        return CGSize(width:width, height:width + 38 )
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView.tag == 0 {
            
            return 2
            
        } else {
          return serviceListArray.count
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"MyBarbersCollectionCell", for: indexPath) as? MyBarbersCollectionCell else {return UICollectionViewCell()}
        let height = (UIScreen.main.bounds.size.width - 120)/4
        
        if collectionView.tag == 0 {
            
            
            
            
        } else if collectionView.tag == 1{
            cell.userImgViw.sd_setImage(with: URL(string : self.serviceListArray[indexPath.row].image), placeholderImage:nil, options: [.cacheMemoryOnly]) { (image, error, cache, url) in

            }
            cell.userImgViw.tintColor = #colorLiteral(red: 0.0446976123, green: 0.2556945969, blue: 0.5071055889, alpha: 1)
            cell.userImgViw.shadowColor = .clear
            cell.titleLbl.text = serviceListArray[indexPath.row].name
            collectionView.isScrollEnabled = false
        }
        
        cell.heightConstarint.constant = height - 10
        return cell
    }
    
    
    
}

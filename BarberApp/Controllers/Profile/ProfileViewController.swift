//
//  ProfileViewController.swift
//  BarberApp
//
//  Created by iOS6 on 18/03/20.
//  Copyright © 2020 iOS8. All rights reserved.
//

import UIKit
import Alamofire

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, getStatusDelegate, getUserNameDelegate {
    func getUserName() {
        
        profileName.text = UserDefaults.standard.value(forKey: "user_Name") as? String
    }
    
    
    func getServiceProviderStatus() {
        
        self.getStatusApi()
    }
    

    
    @IBOutlet weak var profileTableView: UITableView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var personalInfoBtn: UIButton!
    @IBOutlet weak var notificationBtn: UIButton!
    @IBOutlet weak var registerAsBarberBtn: UIButton!
    @IBOutlet weak var getHelpBtn: UIButton!
    @IBOutlet weak var feedbackBtn: UIButton!
    @IBOutlet weak var termsServicesBtn: UIButton!
    @IBOutlet weak var logoutBtn: UIButton!
    var sectionArray = ["","Support" , "Legal", ""]
    var service1RowArraay = ["Register as a Barber"]
    var service1ImageArray = [#imageLiteral(resourceName: "Register-Barber")]
    var service2RowArraay = [String]()
    var service2ImageArray = [#imageLiteral(resourceName: "Register-Barber"),#imageLiteral(resourceName: "Freelancer-barber-black"), #imageLiteral(resourceName: "edit-Calendar"), #imageLiteral(resourceName: "edit-Service"), nil]

    var supportRowArraay = ["Get help", "Get us feedback"]
    var supportImageArray = [#imageLiteral(resourceName: "Help"),#imageLiteral(resourceName: "feedback")]

    var legalRowArraay = ["Terms of Service", "Logout"]

    var providerStatus = String()
    var availableStatus = String()
    var availability = "0"


    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        ProjectManager.sharedInstance.statusDelegate = self
        ProjectManager.sharedInstance.NameDelegate = self
        
        profileTableView.tableFooterView = UIView()
        
        
        if UserDefaults.standard.value(forKey: "user_Name") != nil {
            
        profileName.text = UserDefaults.standard.value(forKey: "user_Name") as? String
            
        }

        self.getStatusApi()
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
    
    
    @IBAction func personalInfoBtnAction(_ sender: Any) {
        
        var vc = EditProfileViewController()
        
        if #available(iOS 13.0, *) {
            
            vc = mainStoryBoard.instantiateViewController(identifier: "EditProfileViewController") as! EditProfileViewController
            
        } else {
            // Fallback on earlier versions
            
            vc = mainStoryBoard.instantiateViewController(withIdentifier: "EditProfileViewController") as! EditProfileViewController

        }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func notificationBtnAction(_ sender: Any) {
        
         var vc = ProfileNotificationsViewController()
        
        if #available(iOS 13.0, *) {
             vc = mainStoryBoard.instantiateViewController(identifier: "ProfileNotificationsViewController") as! ProfileNotificationsViewController
        } else {
            // Fallback on earlier versions
            
             vc = mainStoryBoard.instantiateViewController(withIdentifier: "ProfileNotificationsViewController") as! ProfileNotificationsViewController
        }
              
      self.present(vc, animated: true, completion: nil)

    }
    
    @IBAction func registerAsbarberBtnAction(_ sender: Any) {
        
        // var vc = RegisterAsBarberController()
           var vc = ReceiveJobsViewController()
        
        if #available(iOS 13.0, *) {
          // vc = homeStoryBoard.instantiateViewController(identifier:"RegisterAsBarberController" ) as! RegisterAsBarberController
            
               vc = mainStoryBoard.instantiateViewController(withIdentifier:"ReceiveJobsViewController" ) as! ReceiveJobsViewController
            
            
        } else {
            // Fallback on earlier versions
            
           //  vc = homeStoryBoard.instantiateViewController(withIdentifier:"RegisterAsBarberController" ) as! RegisterAsBarberController
            
            
               vc = mainStoryBoard.instantiateViewController(withIdentifier:"ReceiveJobsViewController" ) as! ReceiveJobsViewController
            
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func getHelpBtnAction(_ sender: Any) {
        
          var vc = HelpViewController()
        
        if #available(iOS 13.0, *) {
             vc = homeStoryBoard.instantiateViewController(identifier:"HelpViewController" ) as! HelpViewController
            
        } else {
            // Fallback on earlier versions
            
            vc = homeStoryBoard.instantiateViewController(withIdentifier:"HelpViewController" ) as! HelpViewController
        }
            self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func feedbackBtnAction(_ sender: Any) {
        
         var vc = FeedbackViewController()
        
        if #available(iOS 13.0, *) {
            vc = homeStoryBoard.instantiateViewController(identifier:"FeedbackViewController" ) as! FeedbackViewController
            
        } else {
            // Fallback on earlier versions
            
             vc = homeStoryBoard.instantiateViewController(withIdentifier:"FeedbackViewController" ) as! FeedbackViewController
        }
           self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func termServicesBtnAction(_ sender: Any) {
        
         var vc = TermsOfServicesController()
        
        if #available(iOS 13.0, *) {
            
           vc = homeStoryBoard.instantiateViewController(identifier:"TermsOfServicesController" ) as! TermsOfServicesController
            
        } else {
            // Fallback on earlier versions
            
            vc = homeStoryBoard.instantiateViewController(withIdentifier:"TermsOfServicesController" ) as! TermsOfServicesController
            
        }
           self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func logoutBtnAction(_ sender: Any) {
    
        print("logout")
        
        let alertController = UIAlertController(title: "", message:"Are you sure you want to logout?", preferredStyle: .alert)
        
        // Create OK button
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            
            
            self.logoutApi()
            
        }
        alertController.addAction(OKAction)
        
        // Create Cancel button
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction!) in
            print("Cancel button tapped");
        }
        alertController.addAction(cancelAction)
        
        // Present Dialog message
        self.present(alertController, animated: true, completion:nil)
        
        
    }
    
     // MARK:- TableView Delegates
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return sectionArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        if section  == 0 {
            
            if providerStatus == "3" || providerStatus == "" {
            
                return service1RowArraay.count
                
            } else {
                
                if service2RowArraay.count > 0 {
                    
                return service2RowArraay.count
                    
                } else {
                    
                    return 0
                }
            }
            
        } else if section == 1 {
            
            return supportRowArraay.count
            
        } else if section == 2 {
            
            return legalRowArraay.count
            
        } else {
            
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
         guard let cell = profileTableView.dequeueReusableCell(withIdentifier:"profileCell", for: indexPath) as? ProfileTableViewCell else {return UITableViewCell()}
        
        
        if indexPath.section == 0 {
            
            
            if providerStatus == "3" || providerStatus == "" {
            
                cell.cellTitleBtn.setTitle(service1RowArraay[indexPath.row], for: .normal)
                cell.cellImage.image = service1ImageArray[indexPath.row]
                
                if indexPath.row == 0 {
                    
                    cell.onTitleButtonTapped = {
                        
                         var vc = RegisterAsBarberController()
                          // var vc = SelectServicesViewController()
                        
                        if #available(iOS 13.0, *) {
                          vc = homeStoryBoard.instantiateViewController(identifier:"RegisterAsBarberController" ) as! RegisterAsBarberController
                            
                             //  vc = mainStoryBoard.instantiateViewController(withIdentifier:"SelectServicesViewController" ) as! SelectServicesViewController
                            
                            
                        } else {
                            // Fallback on earlier versions
                            
                             vc = homeStoryBoard.instantiateViewController(withIdentifier:"RegisterAsBarberController" ) as! RegisterAsBarberController
                            
                            
                               //vc = mainStoryBoard.instantiateViewController(withIdentifier:"SelectServicesViewController" ) as! SelectServicesViewController
                            
                        }
                        self.present(vc, animated: true, completion: nil)
                        
                    }
                    
                } else {
                    
                    
                    
                }
                
            } else {
                
                if service2RowArraay.count > 0 {
                
                cell.cellTitleBtn.setTitle(service2RowArraay[indexPath.row], for: .normal)
                cell.cellImage.image = service2ImageArray[indexPath.row]

                if indexPath.row == 0 {
                    
                    var titleStr = String()
                    
                    if providerStatus == "0" ||   providerStatus == "4" {
                        
                        titleStr = "Submitted - Currently being reviewed"
                        cell.cellTitleBtn.setTitleColor(#colorLiteral(red: 0.8933240771, green: 0.5590150356, blue: 0.1771246195, alpha: 1), for: .normal)

                    } else if providerStatus == "1" {
                        
                        titleStr = "Approved - You can accept bookings"
                        cell.cellTitleBtn.setTitleColor(#colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1), for: .normal)

                        
                    }  else if providerStatus == "2" {
                        
                        titleStr = "Declined -  Photo Not Clear"
                        cell.cellTitleBtn.setTitleColor(#colorLiteral(red: 0.8933240771, green: 0.5590150356, blue: 0.1771246195, alpha: 1), for: .normal)

                        
                    }
                    
                    cell.cellTitleBtn.setTitle(titleStr, for: .normal)
                    
                    cell.cellImage.isHidden = false
                    cell.availabilityBtn.isHidden = true
                    
                    cell.cellTitleBtn.isEnabled = true


                    cell.onTitleButtonTapped = {
                        
                        print(indexPath.row)

                    }

                } else if indexPath.row == 1 {
                    
                    cell.cellImage.isHidden = false
                    cell.availabilityBtn.isHidden = true
                        
                    cell.cellTitleBtn.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
                    cell.cellTitleBtn.isEnabled = true

                   
                    cell.onTitleButtonTapped = {
                        
                        var vc = AdditionalInfoViewController()
                        
                        if #available(iOS 13.0, *) {
                            
                            vc = mainStoryBoard.instantiateViewController(identifier: "AdditionalInfoViewController") as! AdditionalInfoViewController
                            
                        } else {
                            // Fallback on earlier versions
                            
                             vc = mainStoryBoard.instantiateViewController(withIdentifier: "AdditionalInfoViewController") as! AdditionalInfoViewController
                            
                        }
                        
                        vc.profileBool = true
                        self.present(vc, animated: true, completion: nil)
                        
                        
                        
                    }
                    
                } else if indexPath.row == 2 {
                    
                    cell.cellImage.isHidden = false
                    cell.availabilityBtn.isHidden = true
                   
                    cell.cellTitleBtn.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
                    cell.cellTitleBtn.isEnabled = true


                    cell.onTitleButtonTapped = {
                        
                        if #available(iOS 13.0, *) {
                            let vc = mainStoryBoard.instantiateViewController(identifier: "ReceiveJobsViewController") as! ReceiveJobsViewController
                            
                            vc.profileBool = true
                            self.present(vc, animated: true, completion: nil)
                        } else {
                            // Fallback on earlier versions
                            let vc = mainStoryBoard.instantiateViewController(withIdentifier: "ReceiveJobsViewController") as! ReceiveJobsViewController
                            
                            vc.profileBool = true
                            self.present(vc, animated: true, completion: nil)
                            
                        }
                        
                        
                        
                        
                    }
                    
                } else if indexPath.row == 3  {
                    
                    cell.cellImage.isHidden = false
                    cell.availabilityBtn.isHidden = true
                    
                    cell.cellTitleBtn.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
                    cell.cellTitleBtn.isEnabled = true


                   
                    cell.onTitleButtonTapped = {
                    
                        var vc = SelectServicesViewController()

                        if #available(iOS 13.0, *) {

                            vc = mainStoryBoard.instantiateViewController(identifier: "SelectServicesViewController") as! SelectServicesViewController

                        } else {
                            // Fallback on earlier versions

                            vc = mainStoryBoard.instantiateViewController(withIdentifier: "SelectServicesViewController") as! SelectServicesViewController

                        }
                        
                        vc.profileBool = true
                        self.present(vc, animated: true, completion:nil)
                        
                        
                        
                        
                        
                    }
                    
                } else {
                    
                    cell.cellImage.isHidden = true
                    cell.availabilityBtn.isHidden = false
                    
                    cell.cellTitleBtn.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
                    cell.cellTitleBtn.isEnabled = false

                    if availableStatus == "1" {
                        
                        cell.availabilityBtn.isOn = true
                        
                    } else {
                        
                        cell.availabilityBtn.isOn = false

                    }
                    
                    cell.onAvailabilityButtonTapped = {
                        
                        if cell.availabilityBtn.isOn {
                            
                            cell.availabilityBtn.isOn = true
                            self.availability = "1"
                            
                        }  else {
                            
                            cell.availabilityBtn.isOn = false
                            
                            self.availability = "0"
                            
                        }
                        
                        self.changeAvailabilityApi()
                    }
                    
                    
                    }
                
              }
                
            }
            
        }
        
        if indexPath.section == 1 {
            
            cell.cellTitleBtn.setTitle(supportRowArraay[indexPath.row], for: .normal)
            cell.cellImage.image = supportImageArray[indexPath.row]
            cell.cellTitleBtn.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
            cell.cellTitleBtn.isEnabled = true

            
            if indexPath.row == 0 {
                
                cell.onTitleButtonTapped = {
                    
                    var vc = HelpViewController()
                    
                    if #available(iOS 13.0, *) {
                         vc = homeStoryBoard.instantiateViewController(identifier:"HelpViewController" ) as! HelpViewController
                        
                    } else {
                        // Fallback on earlier versions
                        
                        vc = homeStoryBoard.instantiateViewController(withIdentifier:"HelpViewController" ) as! HelpViewController
                    }
                        self.navigationController?.pushViewController(vc, animated: true)
                    
                    
                }
                
            }
            
            if indexPath.row == 1 {
                
                cell.onTitleButtonTapped = {
                    
                    var vc = FeedbackViewController()
                    
                    if #available(iOS 13.0, *) {
                        vc = homeStoryBoard.instantiateViewController(identifier:"FeedbackViewController" ) as! FeedbackViewController
                        
                    } else {
                        // Fallback on earlier versions
                        
                         vc = homeStoryBoard.instantiateViewController(withIdentifier:"FeedbackViewController" ) as! FeedbackViewController
                    }
                       self.navigationController?.pushViewController(vc, animated: true)
                    
                    
                }
                
            }


        }
        
        if indexPath.section == 2 {
            
            
            cell.cellTitleBtn.setTitle(legalRowArraay[indexPath.row], for: .normal)
            cell.cellTitleBtn.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
            cell.cellTitleBtn.isEnabled = true
            
            if indexPath.row == 0 {
                
                cell.cellImage.image = #imageLiteral(resourceName: "Legal")

                cell.onTitleButtonTapped = {
                    
                    var vc = TermsOfServicesController()
                    
                    if #available(iOS 13.0, *) {
                        
                       vc = homeStoryBoard.instantiateViewController(identifier:"TermsOfServicesController" ) as! TermsOfServicesController
                        
                    } else {
                        // Fallback on earlier versions
                        
                        vc = homeStoryBoard.instantiateViewController(withIdentifier:"TermsOfServicesController" ) as! TermsOfServicesController
                        
                    }
                       self.navigationController?.pushViewController(vc, animated: true)
                    
                    
                }
                
            }
            
            if indexPath.row == 1 {
                
                cell.cellImage.image = nil

                cell.onTitleButtonTapped = {
                    
                    print("logout")
                    
                    let alertController = UIAlertController(title: "", message:"Are you sure you want to logout?", preferredStyle: .alert)
                    
                    // Create OK button
                    let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                        
                        
                        self.logoutApi()
                        
                    }
                    alertController.addAction(OKAction)
                    
                    // Create Cancel button
                    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction!) in
                        print("Cancel button tapped");
                    }
                    alertController.addAction(cancelAction)
                    
                    // Present Dialog message
                    self.present(alertController, animated: true, completion:nil)
                    
                    
                }
                
            }


        }
        
        
        return cell

        
        
    }
    
    
    
        func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            
            if section  == 0 {
                
                return 0
                
            } else if section == 3 {
 
                return 80
                
            } else {
                
               return 50
                
            }
        }
        
        func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
               
                return 20
            
        }
        
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 {
            
            let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 0))
            
            headerView.tag = section
            headerView.isUserInteractionEnabled = true
            
            return headerView
            
        } else if section == 3 {
            
            let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 80))
            
             let label = UILabel(frame: CGRect(x: 25, y: 25, width: UIScreen.main.bounds.width - 50 , height: 24))
                 label.font = UIFont(name:"Helvetica Neue", size: 17.0)
             label.textColor = #colorLiteral(red: 0.3179988265, green: 0.3179988265, blue: 0.3179988265, alpha: 1)
            label.textAlignment = .center
            
             // label.numberOfLines = 2
             label.text = "VERSION 01.12.07 (4569848)"
            
            headerView.addSubview(label)
                      
            return headerView
     
            
        } else {
        
        let obj = sectionArray[section]
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 50))
    
        let label = UILabel(frame: CGRect(x: 25, y: 5, width: UIScreen.main.bounds.width - 50 , height: 24))
            label.font = UIFont(name:"Helvetica Neue Medium", size: 20.0)
       
        // label.numberOfLines = 2
        label.text = obj
            
        let line = UIView(frame: CGRect(x: 25, y: label.frame.origin.y +  label.frame.size.height + 10 , width: UIScreen.main.bounds.width - 50 , height: 1))
        line.backgroundColor = #colorLiteral(red: 0.8940390944, green: 0.8941679001, blue: 0.8940109611, alpha: 1)
        line.tag = section
           
        headerView.addSubview(label)
        headerView.addSubview(line)
        label.tag = section
        
        
        headerView.tag = section
        headerView.isUserInteractionEnabled = true
        
        return headerView
        
     }
           
            
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
            
           let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 20))
           
           return headerView
        
    
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
                            
                            self.providerStatus = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"provider_status", dict: json as NSDictionary)as String
                            
                            self.availableStatus = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"user_available", dict: json as NSDictionary)as String
                            
                            
                            
                            if self.providerStatus == "3" || self.providerStatus == ""   {
                                
                               
                                
                            } else {
                                
                                self.service2RowArraay = ["Submitted - Currently being reviewed", "Edit Barber Profile", "Edit Schedule", "Edit Service", "Availability"]
                                
                            }
                            
                            self.profileTableView.reloadData()
                            
                            
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
    
         
    func changeAvailabilityApi()
    {
        if ProjectManager.sharedInstance.isInternetAvailable()
        {
            if let apiToken = UserDefaults.standard.value(forKey: DefaultsIdentifier.apiToken) as? String {
                
                // if apiToken != nil {
               
                DispatchQueue.main.async {
                    ProjectManager.sharedInstance.showLoader(vc: self)
                }
                
               let date = Date()
               let formatter = DateFormatter()
               formatter.dateFormat = "dd-MM-yyyy"
               let result = formatter.string(from: date)


                
                let params = ["provider_status": availability, "date":result] as [String: Any]
                
                let headers = [
                    "Authorization": "Bearer " + apiToken]
                
                //"Accept": "application/json"
                print(headers)
                
                Alamofire.request(Base_Url+userAvailabiltyStatusUrl , method: .post,  parameters: params, encoding: URLEncoding.default, headers:headers)
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
    
    
    func logoutApi()
    {
        if ProjectManager.sharedInstance.isInternetAvailable()
        {
            if let apiToken = UserDefaults.standard.value(forKey: DefaultsIdentifier.apiToken) as? String {
                
                // if apiToken != nil {
                
                
                DispatchQueue.main.async {
                    ProjectManager.sharedInstance.showLoader(vc: self)
                }
                
                let params = ["auth_token": apiToken] as [String: Any]
                
                let headers = [
                    "Authorization": "Bearer " + apiToken]
                                
                //"Accept": "application/json"
                print(headers)
                
                Alamofire.request(Base_Url+LogoutUrl , method: .post,  parameters: params, encoding: URLEncoding.default, headers:headers)
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
                            
                            UserDefaults.standard.set("", forKey: DefaultsIdentifier.apiToken)

                            var vc = MobileViewController()
                                   
                                   if #available(iOS 13.0, *) {
                                        vc = mainStoryBoard.instantiateViewController(identifier:"MobileViewController" ) as! MobileViewController
                                       
                                   } else {
                                       // Fallback on earlier versions
                                       
                                       vc = mainStoryBoard.instantiateViewController(withIdentifier:"MobileViewController" ) as! MobileViewController
                                   }
                            
                                        vc.LogoutBool = true
                                       self.navigationController?.pushViewController(vc, animated: true)
                            
                            
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

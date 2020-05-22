//
//  SelectBarbershopController.swift
//  BarberApp
//
//  Created by iOS8 on 20/03/20.
//  Copyright © 2020 iOS8. All rights reserved.
//

import UIKit
import Alamofire

class SelectBarbershopController: UIViewController, UITextViewDelegate {
    @IBOutlet weak var searchTxtFld: UITextField!
    
    @IBOutlet weak var shopsTableViw: UITableView!
    var shopsArr = ["Barcelona Barbershop", "Bachelor Barbershop" , "Barriotcha & Gram Barbershop" ,"Barriotcha & Gram","Barri Barbershop","Barriotcha","Bach","Bigg Boss", " Gram Barbershop", "VLCC" , "Hair Saloon", "Hair Dresser"]
    var filterArr = [HomeObject]()
    var shopsArray = [HomeObject]()
    var objc: HomeObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shopsTableViw.tableFooterView = UIView()
        searchTxtFld.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)

        // Do any additional setup after loading the view.
    }
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        DispatchQueue.global(qos: .background).async {
            print("This is run on the background queue")
            self.searchApi(search: textField.text!)

        }
        
//        let resultPredicate = NSPredicate(format: "SELF contains[c] %@", (textField.text)!)
//        let filteredArray = shopsArray.filter { resultPredicate.evaluate(with: $0.saloon_name) };
//        filterArr = filteredArray
//        shopsTableViw.reloadData()
       
            
            
        
    }
    
    
    // MARK:  IB Actions

    @IBAction func backAction(_ sender: Any) {
        //self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func continueBtnAction(_ sender: Any) {
        
        
        if objc != nil {
            
            self.continueApi()
            
        } else {
            
            ProjectManager.sharedInstance.showAlertwithTitle(title: "", desc: "Select Babershop", vc: self)
            
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
    
    // MARK: - Api Methods
    
    
    func searchApi(search: String)
    {
        if ProjectManager.sharedInstance.isInternetAvailable()
        {
            if let apiToken = UserDefaults.standard.value(forKey: DefaultsIdentifier.apiToken) as? String {
                
                // if apiToken != nil {
                
                
                
//                DispatchQueue.main.async {
//                     ProjectManager.sharedInstance.showLoader(vc: self)
//                }
                
                let params =  ["search": search] as [String:Any]
                let headers = [
                    "Authorization": "Bearer " + apiToken]
                
                //"Accept": "application/json"
                print(headers)
                
                Alamofire.request(Base_Url+SearchBarberShopUrl , method: .post,  parameters: params, encoding: URLEncoding.default, headers:headers)
                    .responseJSON { response in
                        
                        // ProjectManager.sharedInstance.stopLoader()
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
                            
                            if let data = json["data"] as? NSArray, data.count > 0 {
                                
                                DispatchQueue.main.async {
                                    
                                    let array = ProjectManager.sharedInstance.GetSearchBarberShopListObjects(array: data)
                                    
                                    self.shopsArray =  array
                                    
                                    let resultPredicate = NSPredicate(format: "SELF contains[c] %@", (search))
                                    let filteredArray = self.shopsArray.filter { resultPredicate.evaluate(with: $0.saloon_name) };
                                    self.filterArr = filteredArray
                                    self.shopsTableViw.reloadData()
                                }
                                
                            }
                            
                            
                            
                            
                            
                        } else {
                            
                            DispatchQueue.main.async {
                                
                                
                                let resultPredicate = NSPredicate(format: "SELF contains[c] %@", (search))
                                let filteredArray = self.shopsArray.filter { resultPredicate.evaluate(with: $0.saloon_name) };
                                self.filterArr = filteredArray
                                self.shopsTableViw.reloadData()
                               
                                
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
    
    func continueApi()
    {
        if ProjectManager.sharedInstance.isInternetAvailable()
        {
            if let apiToken = UserDefaults.standard.value(forKey: DefaultsIdentifier.apiToken) as? String {
                
                
                
                let params = ["saloon_name":objc!.saloon_name,
                              "saloon_location":objc!.saloon_location,
                              "preffered_visit_time":objc!.preffered_visit_time,
                              "saloon_lat":objc!.saloon_lat,
                              "saloon_lon":objc!.saloon_lon,
                    ] as [String: Any]
                print(params)
                
                DispatchQueue.main.async {
                    ProjectManager.sharedInstance.showLoader(vc: self)
                }
                
                let headers = [
                    "Authorization": "Bearer " + apiToken]
                
                //"Accept": "application/json"
                print(headers)
                
                Alamofire.request(Base_Url+saveSaloonAddressUrl , method: .post,  parameters: params, encoding: URLEncoding.default, headers:headers)
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
                            
                            if let data = json["data"] as? [String: Any] {
                                
                                //                                let objc = ProjectManager.sharedInstance.GetLoginDataObjects(dict: data)
                                
                                
                                var vc = CompleteProfileViewController()
                                
                                if #available(iOS 13.0, *) {
                                    
                                    vc = mainStoryBoard.instantiateViewController(identifier: "CompleteProfileViewController") as! CompleteProfileViewController
                                    
                                } else {
                                    // Fallback on earlier versions
                                    
                                    vc = mainStoryBoard.instantiateViewController(withIdentifier: "CompleteProfileViewController") as! CompleteProfileViewController
                                    
                                }
                                
                                vc.freelanceBool = false
                                self.present(vc, animated: true, completion: nil)
                                
                            }
                            
                            
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
    

}

extension SelectBarbershopController :UITableViewDelegate , UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filterArr.count > 0 {
        return filterArr.count
            
        } else {
            
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"barbershopCell", for: indexPath)
        cell.textLabel?.text = filterArr[indexPath.row].saloon_name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
         objc = filterArr[indexPath.row]
        
    }
}

//
//  CompleteProfileViewController.swift
//  BarberApp
//
//  Created by iOS6 on 19/03/20.
//  Copyright © 2020 iOS8. All rights reserved.
//

import UIKit
import Alamofire

class CompleteProfileViewController: UIViewController , UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

@IBOutlet weak var firstNameTextField: UITextField!
@IBOutlet weak var fmailyNameTextField: UITextField!
@IBOutlet weak var phoneNumberTextField: UITextField!
@IBOutlet weak var birthDateTextField: UITextField!
@IBOutlet weak var nationalityTextField: UITextField!
@IBOutlet weak var emailTextField: UITextField!
@IBOutlet weak var areaAndZoneTextField: UITextField!
@IBOutlet weak var streetNameTextField: UITextField!
@IBOutlet weak var buildingNumberTextField: UITextField!
    
@IBOutlet var pickerInputView: UIView!
@IBOutlet weak var toolBar: UIToolbar!
@IBOutlet weak var pickerView: UIPickerView!
@IBOutlet weak var datePicker: UIDatePicker!
@IBOutlet weak var cancelToolBarBtn: UIBarButtonItem!
@IBOutlet weak var doneToolBarBtn: UIBarButtonItem!

    var freelanceBool = Bool()
    var countriesArray = [CountryObject]()
    var countryId = String()
    var profileObjc = LoginObject()
    var btnTag = Int()
    let format =  DateFormatter()


    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        datePicker.isHidden = true
        pickerView.isHidden = true
        datePicker.maximumDate = Date()
        loadJson(filename: "country")
        getProfileApi()
        showPicker()
    
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK:- Custom Methods
    
    func setupUI() {
           
           firstNameTextField.text = profileObjc.first_name
           fmailyNameTextField.text = profileObjc.family_name
           phoneNumberTextField.text =  profileObjc.country_code + " " + profileObjc.phone_number
           birthDateTextField.text = profileObjc.dob
           //nationalityTextField.text = profileObjc.first_name
           emailTextField.text = profileObjc.email
           areaAndZoneTextField.text = profileObjc.area
           streetNameTextField.text = profileObjc.street
           buildingNumberTextField.text = profileObjc.building
        
        
        
        
       

        if countriesArray.contains(where: {$0.id == profileObjc.country_id}) {
           // it exists, do something
            
            let index = countriesArray.index(where: { $0.id == profileObjc.country_id })
            nationalityTextField.text = countriesArray[index!].countryName
        } else {
           //item could not be found
        }
    
           
       }
    
    @objc func showPicker()
    {
        nationalityTextField.inputView = pickerInputView
        nationalityTextField.inputAccessoryView = nil
        
        birthDateTextField.inputView = pickerInputView
        birthDateTextField.inputAccessoryView = nil
     
        
    }
    
  func loadJson(filename fileName: String){
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let object = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                if let array = object as? NSArray {
                    print(array)
                    self.countriesArray = ProjectManager.sharedInstance.GetCountriesIDObjects(array: array)
                    print(countriesArray)
                    countryId = countriesArray[0].id
                }
            } catch {
                print("Error!! Unable to parse  \(fileName).json")
            }
        }
 
    }
    
    
    
    //MARK:- TextField Delegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == nationalityTextField {
            
            btnTag = textField.tag

            datePicker.isHidden = true
            pickerView.isHidden = false
                showPicker()
                pickerView.reloadAllComponents()
        
            
        } else if textField == birthDateTextField {
            
            
            datePicker.isHidden = false
            pickerView.isHidden = true
            btnTag = textField.tag
            showPicker()

            
        } else {
            
            datePicker.isHidden = true
            pickerView.isHidden = true
            
            
        }
        
    }
    
    
    // MARK: - IB Actions
    
    @IBAction func backBtnAction(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveNtnAction(_ sender: Any) {
    }
    
    
    @IBAction func continueBtnAction(_ sender: Any) {
        
        
           
                if firstNameTextField.text!.isEmpty {
                    
                   ProjectManager.sharedInstance.showAlertwithTitle(title: "", desc: "First name is required.", vc: self)
                    
                    
                }  else if firstNameTextField.text!.count > 20  {
                    
                     ProjectManager.sharedInstance.showAlertwithTitle(title: "", desc: "First name should be 20 characters maximum", vc: self)
                    
                    
                } else if fmailyNameTextField.text!.isEmpty {
                    
                   ProjectManager.sharedInstance.showAlertwithTitle(title: "", desc: "Family name is required.", vc: self)
                    
                    
                } else if fmailyNameTextField.text!.count > 20  {
                    
                     ProjectManager.sharedInstance.showAlertwithTitle(title: "", desc: "Family name should be 20 characters maximum", vc: self)
                    
                    
                } else if phoneNumberTextField.text!.isEmpty {
                    
                   ProjectManager.sharedInstance.showAlertwithTitle(title: "", desc: "Phone number is required.", vc: self)
                    
                    
                }
        //        else if phoneNumberTextField.text!.count > 10  {
        //
        //             ProjectManager.sharedInstance.showAlertwithTitle(title: "", desc: "phone number should be 8 digits maximum", vc: self)
        //
        //
        //        }
                else if birthDateTextField.text!.isEmpty {
                    
                   ProjectManager.sharedInstance.showAlertwithTitle(title: "", desc: "Date of birth  is required.", vc: self)
                    
                    
                } else if emailTextField.text!.count > 25  {
                    
                     ProjectManager.sharedInstance.showAlertwithTitle(title: "", desc: "Email  should be 20 characters maximum", vc: self)
                    
                    
                } else if areaAndZoneTextField.text!.count > 35  {
                    
                     ProjectManager.sharedInstance.showAlertwithTitle(title: "", desc: "Area  should be 20 characters maximum", vc: self)
                    
                    
                } else if streetNameTextField.text!.count > 20  {
                    
                     ProjectManager.sharedInstance.showAlertwithTitle(title: "", desc: "Street  should be 20 characters maximum", vc: self)
                    
                    
                } else if buildingNumberTextField.text!.count > 50  {
                    
                     ProjectManager.sharedInstance.showAlertwithTitle(title: "", desc: "Building details should be 20 characters maximum", vc: self)
                    
                    
                } else {
                    
                    self.completeProfileApi()
                }
                
 

    }
    
    @IBAction func cancelBtnAction(_ sender: Any) {
           
           self.view.endEditing(true)
           
       }
       
       @IBAction func doneBtnAction(_ sender: Any) {
        
        let row = pickerView.selectedRow(inComponent: 0)

        
        if btnTag == 1 {
            
            format.dateFormat = "dd/MM/yyyy"
            birthDateTextField.text = format.string(from: datePicker.date)
            
            
        } else if btnTag == 2 {

           countryId = countriesArray[row].id
           profileObjc.country_id = countryId
           nationalityTextField.text = countriesArray[row].countryName
            
        }
        
          self.view.endEditing(true)

        
    }
    
    
    //MARK:- PickerView DataSources
      
      func numberOfComponents(in pickerView: UIPickerView) -> Int {
          return 1
      }
      
      func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
          
   
        return countriesArray.count
        
         
      }
      
      
      func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView
      {
          let pickerLabel = UILabel()
       
          pickerLabel.text = countriesArray[row].countryName
          pickerLabel.lineBreakMode = .byWordWrapping
          pickerLabel.numberOfLines = 0
          pickerLabel.sizeToFit()
          
          pickerLabel.textAlignment = NSTextAlignment.center
          return pickerLabel
      }
      
      
      func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
          
      }
      
      func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        
          
          return 30.0
      }
    
    // MARK:- Api Methods

    
    func getProfileApi()
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
                
                Alamofire.request(Base_Url+getCustomerProfileUrl , method: .post,  parameters: nil, encoding: URLEncoding.default, headers:headers)
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
                                
                                let objc = ProjectManager.sharedInstance.GetLoginDataObjects(dict: data)
                                self.profileObjc = objc
                                self.setupUI()
                                                                
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
    
        func completeProfileApi()
        {
            if ProjectManager.sharedInstance.isInternetAvailable()
            {
                if let apiToken = UserDefaults.standard.value(forKey: DefaultsIdentifier.apiToken) as? String {
                    
            
                    
                    self.profileObjc.first_name = (firstNameTextField.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
                    self.profileObjc.family_name = (fmailyNameTextField.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
                    self.profileObjc.phone_number = (phoneNumberTextField.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
                    self.profileObjc.dob = (birthDateTextField.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
                    //self.profileObjc.country_id = countryId
                    self.profileObjc.email = (emailTextField.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
                    self.profileObjc.area = (areaAndZoneTextField.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
                    self.profileObjc.street = (streetNameTextField.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
                    self.profileObjc.building = (buildingNumberTextField.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
                    
                    
                    
                    let params = ["first_name":profileObjc.first_name,
                        "family_name":profileObjc.family_name,
                        "dob":profileObjc.dob,
                        "country_id":profileObjc.country_id,
                        "email":profileObjc.email,
                        "area": profileObjc.area,
                        "street": profileObjc.street,
                        "building": profileObjc.building] as [String: Any]
                    print(params)
                    
                    DispatchQueue.main.async {
                          ProjectManager.sharedInstance.showLoader(vc: self)
                    }
                    
                    let headers = [
                        "Authorization": "Bearer " + apiToken]
                    
                    //"Accept": "application/json"
                    print(headers)
                    
                    Alamofire.request(Base_Url+editPersonalProfileUrl , method: .post,  parameters: params, encoding: URLEncoding.default, headers:headers)
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
    //
                                    
                                    if #available(iOS 13.0, *) {
                                        let vc = mainStoryBoard.instantiateViewController(identifier: "AdditionalInfoViewController") as! AdditionalInfoViewController
                                        
                                        if self.freelanceBool {
                                            vc.freelanceBool = true
                                            } else {
                                                
                                                vc.freelanceBool = false
                                            }
                                        
                                            vc.nameStr = self.profileObjc.first_name
                                            self.present(vc, animated: true, completion: nil)
                                        
                                    } else {
                                        // Fallback on earlier versions
                                        
                                        let vc = mainStoryBoard.instantiateViewController(withIdentifier: "AdditionalInfoViewController") as! AdditionalInfoViewController
                                        
                                        if self.freelanceBool {
                                            vc.freelanceBool = true
                                        } else {
                                            
                                            vc.freelanceBool = false
                                        }
                                        
                                        vc.nameStr = self.profileObjc.first_name

                                        self.present(vc, animated: true, completion: nil)
                                    }

                                    
                                    ProjectManager.sharedInstance.showAlertwithTitle(title: "", desc: msg as String, vc: self)
                                    
                                    
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

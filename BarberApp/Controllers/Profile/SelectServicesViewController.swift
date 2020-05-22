//
//  SelectServicesViewController.swift
//  BarberApp
//
//  Created by iOS6 on 25/03/20.
//  Copyright © 2020 iOS8. All rights reserved.
//

import UIKit
import Alamofire

class SelectServicesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var selectServiceTableView: UITableView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var submitApplicationBtn: UIButton!
    
    let kHeaderSectionTag: Int = 6900;
    var i: Int = 0
    var answeredQuestionsArray: Array<Any> = []
    var sectionItems: Array<Any> = []
    //let section  = headerView?.tag
    var expandedSectionHeaderNumber: Int = -1
    var expandedSectionHeader: UITableViewHeaderFooterView!
    
    var currentIndex = Int()
//    var sectionArray = ["Haircut", "Beard Cut", "Hair and Beard Cut", "Beard Trimming", "Beard Coloring and Styling", "Kid Haircut", "Elderly Haircut", "","Face and Ears Waxing", "Hair Coloring", "Keryatine", "Hairdrying and Gel", "Shampoo and Wash", "", "Home service Fee"]
    
    var sectionArray = ["Main Service","Extra Services", "Home Services"]
    var sectionDescriptionArray = ["Select the service you are able to cut and how much you charge for them", "What else do you provide as a special service and how much you charge for them", "Do you offer on-demand service by going to the customer’s location and giving a haircut?"]
    var sectionMainServiceArray = ["Haircut", "Beard Cut", "Hair and Beard Cut", "Beard Trimming", "Beard Coloring and Styling", "Kid Haircut", "Elderly Haircut"]
    var sectionExtraServiceArray = ["Face and Ears Waxing", "Hair Coloring", "Keryatine", "Hairdrying and Gel", "Shampoo and Wash"]
    var sectionHomeServiceArray = ["Home service Fee"]
    var mainArray = [ServiceObject]()
    var mainServiceArray = [ServiceObject]()
    var ExtraServiceArray = [ServiceObject]()
    var homeObjc = ServiceObject()

    
    var statusArray = [false, false, false, false, false, false, false]
    var itemsArray = [String]()
    var addBtn = UIButton()
    var switchBtn = UISwitch()
    var sectionHeight = Int()
    var headerView : UIView?
    var priceTextField = UITextField()
    var line = UIView()
    var deleteBtn = UIButton()
    var profileBool = Bool()
    var freelanceBool = Bool()


    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
//
//         let cell = selectServiceTableView.cellForRow(at: IndexPath(row: 0, section: 0 )) as? ReceiveJobsTableViewCell
//        cell?.descreptionViewHeightConstraint.constant = 0
        
        if profileBool {
            
            saveBtn.isHidden = false
            submitApplicationBtn.isHidden = true
            
        } else {
            
            saveBtn.isHidden = true
            submitApplicationBtn.isHidden = false

        }
       
        getUserServicesApi()
        
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    //MARK:- TextField Delegate

    
    func textFieldDidEndEditing(_ textField: UITextField) {

            
            
            if textField.tag == 0 || textField.tag == self.mainServiceArray.count + 1 || textField.tag == self.mainArray.count + 2 {
                
                
            } else if textField.tag == self.mainArray.count + 3 {
                
                homeObjc.home_service_fee = textField.text!
                homeObjc.home_service_status = "1"
                
            } else if textField.tag >= self.mainServiceArray.count + 2 {
                
                self.mainArray[textField.tag - 2].price = textField.text!
                self.mainArray[textField.tag - 2].main_service_status = "0"
                self.mainArray[textField.tag - 2].extra_service_status = "1"
                self.mainArray[textField.tag - 2].service_status = "1"

                
                
            }else {
                
                self.mainArray[textField.tag - 1].price = textField.text!
                self.mainArray[textField.tag - 1].main_service_status = "1"
                self.mainArray[textField.tag - 1].extra_service_status = "0"
                self.mainArray[textField.tag - 1].service_status = "1"


            }
      
    }
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView.tag == 0 || textView.tag == self.mainServiceArray.count + 1 || textView.tag == self.mainArray.count + 2 {
            
            
        } else if textView.tag >= self.mainServiceArray.count + 2 {
            
            self.mainArray[textView.tag - 2].dscription = textView.text!
            self.mainArray[textView.tag - 2].main_service_status = "0"
            self.mainArray[textView.tag - 2].extra_service_status = "1"
            self.mainArray[textView.tag - 2].service_status = "1"

            
            
        } else {
            
            self.mainArray[textView.tag - 1].dscription = textView.text!
            self.mainArray[textView.tag - 1].main_service_status = "1"
            self.mainArray[textView.tag - 1].extra_service_status = "0"
            self.mainArray[textView.tag - 1].service_status = "1"


        }

        
    }
    
    
     // MARK: - Custom Methods
    
    func arryObject() -> [Any] {
        
        var categories = [Any]()

        for menu in mainArray{
                 if(mainArray.count != 0){
                    let Cat: NSMutableDictionary = NSMutableDictionary()
                    
                    if (menu.price == "0" && menu.dscription == "" && menu.service_category == "1") || (menu.price == "" && menu.dscription == "" && menu.service_category == "1") {
                        
                        Cat.setValue("0", forKey: "service_status")
                        Cat.setValue("1", forKey: "main_service_status")
                        Cat.setValue("0", forKey: "extra_service_status")
                        
                    } else if (menu.price == "0" && menu.dscription == "" && menu.service_category == "2") || (menu.price == "" && menu.dscription == "" && menu.service_category == "2") {
                        
                        Cat.setValue("0", forKey: "service_status")
                        Cat.setValue("0", forKey: "main_service_status")
                        Cat.setValue("1", forKey: "extra_service_status")
                        
                    } else if (menu.service_category == "1" && menu.price != "0") ||  (menu.service_category == "1" && menu.price != "") {
                        
                        Cat.setValue("1", forKey: "service_status")
                        Cat.setValue("1", forKey: "main_service_status")
                        Cat.setValue("0", forKey: "extra_service_status")
                        
                    } else if (menu.service_category == "2" && menu.price != "0") || (menu.service_category == "2" && menu.price != "") {
                        
                        Cat.setValue("1", forKey: "service_status")
                        Cat.setValue("0", forKey: "main_service_status")
                        Cat.setValue("1", forKey: "extra_service_status")
                        
                    } else {
                        
                        Cat.setValue(menu.service_status, forKey: "service_status")
                        Cat.setValue(menu.main_service_status, forKey: "main_service_status")
                        Cat.setValue(menu.extra_service_status, forKey: "extra_service_status")
                        
                    }
                    
                     Cat.setValue(menu.service_id, forKey: "service_id")
                     Cat.setValue(menu.price, forKey: "price")
                     Cat.setValue(menu.dscription, forKey: "description")
                 //  let array = JSON(Cat)
                     categories.append(Cat)}
                 }
        
        print(categories)
        return categories

    }
    
    
    func convertToJson(result: [Any]) -> String {
        
//        do {
//
//            //Convert to Data
//            let jsonData = try JSONSerialization.data(withJSONObject: result, options: JSONSerialization.WritingOptions.prettyPrinted)
//
//            //Convert back to string. Usually only do this for debugging
//            if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
//               print(JSONString)
//            }
//
//            //In production, you usually want to try and cast as the root data structure. Here we are casting as a dictionary. If the root object is an array cast as [Any].
//            let json = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers) as? [Any]
//
//            print(json!)
//
//            return json!
//
//        } catch {
//         //   print(error.description)
//
//            return [""]
//        }
        
        
        
        
        
        var createJSON: String? = nil
        do {
            createJSON = String(
                data: try JSONSerialization.data(
                    withJSONObject: result,
                    options:.prettyPrinted),
                encoding: .utf8)

            print(createJSON!)
        } catch {
        }

        return createJSON!
        
    

        
    }
   
    func convert() -> String {

        var jsonString: String? = nil

        let jsonCompatibleArray = mainArray.map { model -> [String : Any] in
            
            if model.price == "0.00" && model.dscription == "" && model.service_category == "1" {
                
                
                return [
                    
                    
                    "service_status":"0",
                    "main_service_status":"1",
                    "extra_service_status":"0",
                    "service_id":model.service_id,
                    "price":model.price,
                    "description":model.dscription
                    
                    
                ]
                
            } else if model.price == "0.00" && model.dscription == "" && model.service_category == "2" {
                
                return [
                    
                    
                    "service_status":"0",
                    "main_service_status":"0",
                    "extra_service_status":"1",
                    "service_id":model.service_id,
                    "price":model.price,
                    "description":model.dscription
                    
                    
                ]
                
            } else if model.service_category == "1" && model.price != "0.00"{
                
                return [
                    
                    
                    "service_status":"1",
                    "main_service_status":"1",
                    "extra_service_status":"0",
                    "service_id":model.service_id,
                    "price":model.price,
                    "description":model.dscription
                    
                    
                ]
                
                
            } else if model.service_category == "2" && model.price != "0.00" {
                
                return [
                    
                    
                    "service_status":"1",
                    "main_service_status":"0",
                    "extra_service_status":"1",
                    "service_id":model.service_id,
                    "price":model.price,
                    "description":model.dscription
                    
                    
                ]
                
                
            } else {
                
                return [
                    
                    
                    "service_status":model.service_status,
                    "main_service_status":model.main_service_status,
                    "extra_service_status":model.extra_service_status,
                    "service_id":model.service_id,
                    "price":model.price,
                    "description":model.dscription
                    
                    
                ]
                
            }
            
        }
        
        print(jsonCompatibleArray)
        
        do {

      //  let data = try JSONSerialization.data(withJSONObject: jsonCompatibleArray, options: .prettyPrinted)
            
             jsonString = String(
             data: try JSONSerialization.data(
                 withJSONObject: jsonCompatibleArray,
                 options:.prettyPrinted),
             encoding: .utf8)
            
            print(jsonString!)
        } catch {
            
            
        }
        
        return jsonString!

        
    }
    
    
    
    // MARK: - IB Actions
    
    @IBAction func backBtnAction(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)

    }
    
    
    @IBAction func saveBtnAction(_ sender: Any) {
        
        
            
            let jsonStr = convert()
            let result = arryObject()
            
            let jsonString = convertToJson(result: result)
            
            saveServiceApi(result: jsonString)


       
        
        
        //        var vc = ThankYouViewController()
        //
        //        if #available(iOS 13.0, *) {
        //
        //             vc = homeStoryBoard.instantiateViewController(identifier: "ThankYouViewController") as! ThankYouViewController
        //
        //        } else {
        //            // Fallback on earlier versions
        //
        //             vc = homeStoryBoard.instantiateViewController(withIdentifier: "ThankYouViewController") as! ThankYouViewController
        //
        //        }
        //        self.present(vc, animated: true, completion: nil)
        
        
        
    }
    
    
    @IBAction func submitApplicationBtnAction(_ sender: Any) {
        
        
            
            let jsonStr = convert()
            let result = arryObject()
            
            let jsonString = convertToJson(result: result)
            
            saveServiceApi(result: jsonString)


       
        
        
        //        var vc = ThankYouViewController()
        //
        //        if #available(iOS 13.0, *) {
        //
        //             vc = homeStoryBoard.instantiateViewController(identifier: "ThankYouViewController") as! ThankYouViewController
        //
        //        } else {
        //            // Fallback on earlier versions
        //
        //             vc = homeStoryBoard.instantiateViewController(withIdentifier: "ThankYouViewController") as! ThankYouViewController
        //
        //        }
        //        self.present(vc, animated: true, completion: nil)
        
        
        
    }
    
    
    // MARK: - TableView Delegates
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        
        if mainArray.count > 0 {
            
            if homeObjc.home_service_status == "0" {

                return mainArray.count + 4

            } else {
                
                return mainArray.count + 4
                
            }
            
        } else {
            
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if  section == 0 || section == self.mainServiceArray.count + 1 || section == self.mainArray.count + 2 || section == self.mainArray.count + 3 {
            
            return 0
            
        } else {
  
                if section >= self.mainServiceArray.count + 2 {
   
                    if self.mainArray[section - 2].addDescription == "" {
                        
                        return 0
                        
                    } else {
                        
                        return 1
                    }
                
                
            }  else {
                
                if self.mainArray[section - 1].addDescription == "" {
                    
                    return 0
                    
                } else {
                    
                    return 1
                }
      
            }
       
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        return 90
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        guard let cell = selectServiceTableView.dequeueReusableCell(withIdentifier:"receiveJobCell", for: indexPath) as? ReceiveJobsTableViewCell else {return UITableViewCell()}
        
        cell.serviceDescTextView.delegate = self

        cell.serviceDescTextView.tag = indexPath.section
//        cell.serviceDescTextView.accessibilityLabel = "\(indexPath.section)"
        cell.priceView.setBorder(width: 1, color: #colorLiteral(red: 0.8940390944, green: 0.8941679001, blue: 0.8940109611, alpha: 1))
        
        
        if indexPath.section == 0 || indexPath.section == self.mainServiceArray.count + 1 || indexPath.section == self.mainArray.count + 2 {


        } else {

            if  indexPath.section >= self.mainServiceArray.count + 2 && indexPath.section == self.mainArray.count + 3  {

//                if homeObjc.home_service_status == "0" {
//
//                    return 0
//
//                } else {
//
//                    return 1
//                }


            } else if indexPath.section >= self.mainServiceArray.count + 2 {

                if self.mainArray[indexPath.section - 2].addDescription == "" {


                } else {

                    cell.serviceDescTextView.text =  self.mainArray[indexPath.section - 2].dscription

                }
                

            }  else {

                if self.mainArray[indexPath.section - 1].addDescription == "" {

                } else {

                    cell.serviceDescTextView.text =  self.mainArray[indexPath.section - 1].dscription

                }

            }


        }

        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 || section == self.mainServiceArray.count + 1 || section == self.mainArray.count + 2 {
            
            return 120
            
        } else {
            
            //return 100
            
            if  section >= self.mainServiceArray.count + 2 && section == self.mainArray.count + 3  {
                
                if homeObjc.home_service_status == "0" {
                    
                    return 100
                    
                } else {
                    
                    return 100
                }
                
            } else if section >= self.mainServiceArray.count + 2 {

                
                // self.mainArray[section - 2].addDesc == ""
                if self.mainArray[section - 2].switchBool == false {

                    return 40

                } else {

                  return 100

                }

            } else {

                // self.mainArray[section - 2].addDesc == ""
                if self.mainArray[section - 1].switchBool == false {

                    return 40

                } else {

                  return 100

                }



//                if let sectionHeader = headerView {
//                    return 100
//                } else {
//                    return 100
//                }


            }

            
          // return 100
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        
        if section == 1 || section == 2 {
            
            return 5
            
        } else {
            
            return 5
            
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 || section == self.mainServiceArray.count + 1 || section == self.mainArray.count + 2 {
            
            let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 80))
            
           // headerView.backgroundColor = #colorLiteral(red: 0.4392156899, green: 0.01176470611, blue: 0.1921568662, alpha: 1)
            
            //        let size1 =  CGSize(width:(sectionArray[section] as NSString).size(withAttributes: [NSAttributedString.Key.font: UIFont(name:"Helvetica Neue Medium", size: 19)!]).width + 10, height: 41)
            
            let size = CGSize(width: 90, height: 30)
            
            print(size)
            let label = UILabel(frame: CGRect(x: 39, y: 11, width: size.width + 40 , height: 30))
            label.font = UIFont(name:"Helvetica Neue Bold", size: 22)
            // label.numberOfLines = 2
        
            
           let desc = UILabel(frame: CGRect(x: 39, y: label.frame.origin.y + label.frame.size.height , width: UIScreen.main.bounds.width - 75 , height: 70))
            
            desc.font = UIFont(name:"Helvetica Neue Light", size: 17)
            desc.numberOfLines = 0
            
            
            if section == 0 {
                
                label.text = "Main Services"
                desc.text = "Select the service you are able to cut and how much you charge for them"
                
            } else if section == self.mainServiceArray.count + 1 {
                
                label.text = "Extra Services"
                desc.text = "What else do you provide as a special service and how much you charge for them"
                
                
            } else if section == self.mainArray.count + 2 {
                
                label.text = "Home Services"
                desc.text = "Do you offer on-demand service by going to the customer’s location and giving a haircut?"
                
                
            }
            
            headerView.addSubview(label)
            headerView.addSubview(desc)
            
            headerView.tag = section
            headerView.isUserInteractionEnabled = true
            
            return headerView
            
            
        }
            
            
//        else if section == 2 {
//
//            let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 80))
//
//           // headerView.backgroundColor = #colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1)
//
//
//
//            //        let size1 =  CGSize(width:(sectionArray[section] as NSString).size(withAttributes: [NSAttributedString.Key.font: UIFont(name:"Helvetica Neue Medium", size: 19)!]).width + 10, height: 41)
//
//            let size = CGSize(width: 90, height: 30)
//
//            print(size)
//            let label = UILabel(frame: CGRect(x: 39, y: 11, width: size.width + 40 , height: 30))
//            label.font = UIFont(name:"Helvetica Neue Bold", size: 22)
//            // label.numberOfLines = 2
//            label.text = "Home Service"
//
//            let desc = UILabel(frame: CGRect(x: 39, y: label.frame.origin.y + label.frame.size.height , width: UIScreen.main.bounds.width - 75 , height: 70))
//            desc.font = UIFont(name:"Helvetica Neue Light", size: 17)
//            desc.numberOfLines = 0
//            desc.text = "Do you offer on-demand service by going to the customer’s location and giving a haircut?"
//
//            headerView.addSubview(label)
//            headerView.addSubview(desc)
//
//            headerView.tag = section
//            headerView.isUserInteractionEnabled = true
//
//            return headerView
//
//
//        }
            
            
//        if section == self.mainServiceArray.count + 2 {
//
//
//
//        }
            
        else {
            
            if mainArray.count > 0 {
                
                headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 100))
                
                var obj =  String()
                 if  section >= self.mainServiceArray.count + 2 && section == self.mainArray.count + 3  {
                    
                    obj = "Home Service"
                    
                } else if section >= self.mainServiceArray.count + 2 {
                    
                     obj = mainArray[section - 2].service_name
                    
                    
                    
                 } else {
                     obj = mainArray[section - 1].service_name
                    
                    
                    
                }
                
                //let obj = mainArray[section - 1].service_name
                
                let size = CGSize(width: 90, height: 30)
                let size1 = self.textWidth(text: obj, font: UIFont(name: "Helvetica Neue Medium", size: 19))
                print(size)
                let label = UILabel(frame: CGRect(x: 39, y: 11, width: size1 + 70 , height: 30))
                label.font = UIFont(name:"Helvetica Neue Bold", size: 19)
                // label.numberOfLines = 2
              
                label.text = obj
                
                switchBtn = UISwitch(frame: CGRect(x: UIScreen.main.bounds.width - 89, y: 11, width: 51, height: 31)) //330
                switchBtn.addTarget(self, action: #selector(switchBtnAction), for: .valueChanged)
                switchBtn.onTintColor = #colorLiteral(red: 0.1294117647, green: 0.2980392157, blue: 0.5058823529, alpha: 1)
                switchBtn.isOn = true
                switchBtn.tag = section
                
                priceTextField = UITextField(frame: CGRect(x: 39, y: label.frame.origin.y + label.frame.size.height
                    + 8, width: UIScreen.main.bounds.width - 162 , height: 24))
                priceTextField.font = UIFont(name:"Helvetica Neue Light", size: 23)
                // label.numberOfLines = 2 UIScreen.main.bounds.width - 162
                //priceTextField.text = "30.00 QAR"
                priceTextField.placeholder = "0.00 QAR"
                priceTextField.tag = section
                priceTextField.delegate = self
                
                if  section >= self.mainServiceArray.count + 2 && section == self.mainArray.count + 3  {
                    
                    if homeObjc.home_service_fee == "" {
                        
                        priceTextField.text = "0.00 QAR"
    
                    } else {
                    
                       priceTextField.text = self.homeObjc.home_service_fee + " QAR"
                        
                    }
                    
                } else if section >= self.mainServiceArray.count + 2 {
                    
                    if mainArray[section - 2].price.isEmpty {
                        
                        priceTextField.text = ""
                        
                        
                    } else {
                        
                        priceTextField.text = mainArray[section - 2].price + " QAR"
                    }
                    
                }  else {
                    if mainArray[section - 1].price.isEmpty {
                        
                        priceTextField.text = ""
                        
                        
                    } else {
                        
                        priceTextField.text = mainArray[section - 1].price + " QAR"
                        
                    }

                }
                
                
                
                
                
                

                
//                let fixedLabel = UILabel(frame: CGRect(x: priceTextField.frame.origin.x + priceTextField.frame.size.width, y: label.frame.origin.y + label.frame.size.height
//                    + 8, width: 50 , height: 24))
//                fixedLabel.font = UIFont(name:"Helvetica Neue Light", size: 23)
//                // label.numberOfLines = 2
//                fixedLabel.text = "QAR"
//                fixedLabel.tag = section
                
                
                
                addBtn = UIButton(frame: CGRect(x: UIScreen.main.bounds.width - 79, y: switchBtn.frame.origin.y + switchBtn.frame.size.height + 5, width: 38, height: 24)) //switchBtn.frame.origin.x + 4
                
                addBtn.contentMode = .scaleAspectFit
                addBtn.tintColor = .black
                addBtn.setImage(#imageLiteral(resourceName: "addBtn"), for: .normal)
                addBtn.addTarget(self, action: #selector(expandSectionAction), for: .touchUpInside)
                addBtn.tag = section
                
                deleteBtn = UIButton(frame: CGRect(x: UIScreen.main.bounds.width - 79, y: switchBtn.frame.origin.y + switchBtn.frame.size.height + 5, width: 38, height: 24))   //switchBtn.frame.origin.x + 4
                
                deleteBtn.contentMode = .scaleAspectFit
                deleteBtn.tintColor = .black
                deleteBtn.setImage(#imageLiteral(resourceName: "deleteBtn"), for: .normal)
                deleteBtn.addTarget(self, action: #selector(collapseSectionAction), for: .touchUpInside)
                deleteBtn.tag = section

                
                
                
                
                line = UIView(frame: CGRect(x: 39, y: priceTextField.frame.origin.y + label.frame.size.height , width: UIScreen.main.bounds.width - 60 , height: 1))
                
                line.backgroundColor = #colorLiteral(red: 0.8940390944, green: 0.8941679001, blue: 0.8940109611, alpha: 1)
                line.tag = section
                
                
                
                headerView!.addSubview(label)
                headerView!.addSubview(switchBtn)
                headerView!.addSubview(priceTextField)
                //headerView.addSubview(fixedLabel)
                headerView!.addSubview(addBtn)
                headerView!.addSubview(deleteBtn)
                headerView!.addSubview(line)
                
                
                if section == 0 || section == self.mainServiceArray.count + 1 || section == self.mainArray.count + 2 {
                    
                    
                } else {
                    
                    if  section >= self.mainServiceArray.count + 2 && section == self.mainArray.count + 3  {
                        
                        if homeObjc.home_service_status == "0" {
                            
                            addBtn.isHidden = true
                            deleteBtn.isHidden = true
                            
                        } else {
                            
                            addBtn.isHidden = true
                            deleteBtn.isHidden = true
                            
                        }
                        
                        
                    } else if section >= self.mainServiceArray.count + 2 {
                        
                        if self.mainArray[section - 2].addDescription == "" {
                            
                            addBtn.isHidden = false
                            deleteBtn.isHidden = true


                            
                        } else {

                            addBtn.isHidden = true
                            deleteBtn.isHidden = false

                            
                        }
                        
                        
                    }  else {
                        
                        if self.mainArray[section - 1].addDescription == "" {
                            
                            addBtn.isHidden = false
                            deleteBtn.isHidden = true
                            
                        } else {
                            
                            addBtn.isHidden = true
                            deleteBtn.isHidden = false

                        }
                        
                    }
                    
                    
                }
                
                
                
                
                
                if section == 0 || section == self.mainServiceArray.count + 1 || section == self.mainArray.count + 2 {
                    
                    
                } else {
                    
                    if  section >= self.mainServiceArray.count + 2 && section == self.mainArray.count + 3  {
                        
                        if homeObjc.home_service_status == "0" {
                            
                            addBtn.isHidden = true
                            deleteBtn.isHidden = true
                            priceTextField.isHidden = true
                            line.isHidden = true
                            switchBtn.isOn = false
                            
                        } else {
                            
                            addBtn.isHidden = true
                            deleteBtn.isHidden = true
                            priceTextField.isHidden = false
                            line.isHidden = false
                            switchBtn.isOn = true
                            
                        }
                        
                        
                    } else if section >= self.mainServiceArray.count + 2 {
                        
                        if self.mainArray[section - 2].switchBool == true {
                            
                            addBtn.isHidden = false
                           // deleteBtn.isHidden = false
                            priceTextField.isHidden = false
                            line.isHidden = false
                            switchBtn.isOn = true


                            
                        } else {

                               addBtn.isHidden = true
                               deleteBtn.isHidden = true
                               priceTextField.isHidden = true
                               line.isHidden = true
                               switchBtn.isOn = false


                            
                        }
                        
                        
                    }  else {
                        
                        if self.mainArray[section - 1].switchBool == true {
                            
                                                     
                            addBtn.isHidden = false
                           // deleteBtn.isHidden = false
                            priceTextField.isHidden = false
                            line.isHidden = false
                            switchBtn.isOn = true


                            
                        } else {
                            
                            addBtn.isHidden = true
                            deleteBtn.isHidden = true
                            priceTextField.isHidden = true
                            line.isHidden = true
                            switchBtn.isOn = false



                        }
                        
                    }
                    
                    
                }
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                return headerView
                
            } else {
                
                return UIView()
            }
        }
            
            
            
            
            
//        else {
//
//            let obj = sectionArray[section]
//
//            let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 30))
//           //  headerView.backgroundColor = #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)
//
//
//            let size1 = self.textWidth(text: obj, font: UIFont(name: "Helvetica Neue Medium", size: 19))
//
//
////            let size1 = CGSize(width:(sectionArray[section] as NSString).size(withAttributes: [NSAttributedString.Key.font: UIFont(name:"Helvetica Neue Medium", size: 19)!]).width + 10, height: 30)
//
//            let size = CGSize(width: 90, height: 30)
//
//            print(size)
//            let label = UILabel(frame: CGRect(x: 39, y: 11, width: size1 + 70 , height: 30))
//            label.font = UIFont(name:"Helvetica Neue Bold", size: 19)
//            // label.numberOfLines = 2
//            label.text = obj
//
//            let switchBtn = UISwitch(frame: CGRect(x: 330, y: 11, width: 51, height: 31))
//            switchBtn.addTarget(self, action: #selector(collapseSectionAction), for: .touchUpInside)
//            switchBtn.tag = section
//
//
//
//            let expandLbl = UIButton(frame: CGRect(x:  switchBtn.frame.origin.x  , y:  switchBtn.frame.origin.x + switchBtn.frame.size.height + 8 , width:47, height: 24))
//            expandLbl.contentMode = .scaleAspectFit
//            expandLbl.tintColor = .black
//            //if statusArray[section] {
//            expandLbl.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
//            expandLbl.setImage(#imageLiteral(resourceName: "addBtn"), for: .normal)
//            expandLbl.addTarget(self, action:#selector(expandSectionAction), for: .touchUpInside)
//
//            expandLbl.tag = section
//
//
//
//            let priceTextField = UITextField(frame: CGRect(x: 39, y: label.frame.origin.y + label.frame.size.height
//                + 8, width: UIScreen.main.bounds.width - 162 , height: 24))
//            priceTextField.font = UIFont(name:"Helvetica Neue Light", size: 23)
//            // label.numberOfLines = 2
//            priceTextField.text = "30.00 QAR"
//            priceTextField.tag = section
//
//             addBtn = UIButton(frame: CGRect(x: switchBtn.frame.origin.x + 4, y: switchBtn.frame.origin.y + switchBtn.frame.size.height + 5, width: 38, height: 24))
//
//            addBtn.contentMode = .scaleAspectFit
//            addBtn.tintColor = .black
//            addBtn.setImage(#imageLiteral(resourceName: "addBtn"), for: .normal)
//            addBtn.addTarget(self, action: #selector(expandSectionAction), for: .touchUpInside)
//            addBtn.tag = section
//
//            let line = UIView(frame: CGRect(x: 39, y: priceTextField.frame.origin.y + label.frame.size.height , width: UIScreen.main.bounds.width - 60 , height: 1))
//
//            line.backgroundColor = #colorLiteral(red: 0.8940390944, green: 0.8941679001, blue: 0.8940109611, alpha: 1)
//            line.tag = section
//
//
//
//
//
//
//
//
//
//
//
//
//            // }
//            //        else {
//            //          expandLbl.image  = #imageLiteral(resourceName: "expand")
//            //        }
//
//            let deleteImg = UIButton(frame: CGRect(x: headerView.frame.origin.x + headerView.frame.size.width - 40 , y: 8, width:20, height: 24))
//            deleteImg.contentMode = .scaleAspectFit
//            deleteImg.tintColor = .black
//            deleteImg.setImage(#imageLiteral(resourceName: "deleteBtn"), for: .normal)
//            deleteImg.addTarget(self, action:#selector(collapseSectionAction), for: .touchUpInside)
//            deleteImg.tag = section
//
//            headerView.addSubview(label)
//            headerView.addSubview(switchBtn)
//
//            headerView.addSubview(priceTextField)
//            headerView.addSubview(addBtn)
//            headerView.addSubview(line)
//
//            // headerView.addSubview(expandLbl)
//
//
//
//
//
//            //headerView.addSubview(deleteImg)
//            //        switch section {
//            //
//            //        case 0:
//            //           if getProfileObject.first_job.count > 0 {
//            //                deleteImg.isHidden = false
//            //            } else {
//            //                deleteImg.isHidden = true
//            //            }
//            //
//            //        case 1:
//            //           if getProfileObject.first_job.count > 0 {
//            //                deleteImg.isHidden = false
//            //            } else {
//            //                deleteImg.isHidden = true
//            //            }
//            //
//            //        case 2:
//            //            if getProfileObject.first_job.count > 0 {
//            //                deleteImg.isHidden = false
//            //            } else {
//            //                deleteImg.isHidden = true
//            //            }
//            //
//            //        case 3:
//            //            if getProfileObject.partners.count > 0 {
//            //                deleteImg.isHidden = false
//            //            } else {
//            //                deleteImg.isHidden = true
//            //            }
//            //
//            //        case 4:
//            //            if getProfileObject.marriage_to.count > 0 || getProfileObject.marriage_date.count > 0 {
//            //                deleteImg.isHidden = false
//            //            } else {
//            //                deleteImg.isHidden = true
//            //            }
//            //
//            //        case 5:
//            //            if getProfileObject.marriage_to.count > 0 || getProfileObject.marriage_date.count > 0 {
//            //                deleteImg.isHidden = false
//            //            } else {
//            //                deleteImg.isHidden = true
//            //            }
//            //
//            //        case 6:
//            //            if getProfileObject.marriage_to.count > 0 || getProfileObject.marriage_date.count > 0 {
//            //                deleteImg.isHidden = false
//            //            } else {
//            //                deleteImg.isHidden = true
//            //            }
//            //
//            //        default:
//            //            break
//            //        }
//
//
//
//
//
//
//            headerView.tag = section
//            headerView.isUserInteractionEnabled = true
//
//            //   let tapgesture = UITapGestureRecognizer(target: self , action: #selector(self.sectionTapped(_:)))
//            //  headerView.addGestureRecognizer(tapgesture)
//            return headerView
//            //        }
//            //        else {
//            //            return UIView()
//            //        }
//
//
//
//        }
        
        
        
        
        
        
//        else {
//
//            return UIView()
//        }
        
        
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 10))
        
        return headerView
        
    }
    
    
    func tableViewExpandSection(_ section: Int, imageView: UIImageView) {
        let sectionData = self.mainArray
        if (sectionData.count == 0) {
            self.expandedSectionHeaderNumber = -1;
            
            return;
            
        }
//        else if section == 7 || section == 13 {
//
//            self.expandedSectionHeaderNumber = -1;
//
//            return;
//
//        }
        else {
            UIView.animate(withDuration: 0.4, animations: {
                imageView.transform = CGAffineTransform(rotationAngle: (180.0 * CGFloat(Double.pi)) / 180.0)
            })
            var indexesPath = [IndexPath]()
            for i in 0 ..< sectionData.count {
                let index = IndexPath(row: i, section: section)
                indexesPath.append(index)
            }
            self.expandedSectionHeaderNumber = section
            self.selectServiceTableView!.beginUpdates()
            self.selectServiceTableView!.insertRows(at: indexesPath, with: UITableView.RowAnimation.fade)
            self.selectServiceTableView!.endUpdates()
        }
    }
    
    func tableViewCollapeSection(_ section: Int, imageView: UIImageView) {
        let sectionData = self.mainArray  //[section]
        
        self.expandedSectionHeaderNumber = -1;
        if (sectionData.count == 0) {
            return;
            
        }
//        else if section == 7 || section == 13 {
//
//            return;
//
//        }
        else {
            
            UIView.animate(withDuration: 0.4, animations: {
                imageView.transform = CGAffineTransform(rotationAngle: (0.0 * CGFloat(Double.pi)) / 180.0)
            })
            var indexesPath = [IndexPath]()
            for i in 0 ..< sectionData.count {
                let index = IndexPath(row: i, section: section)
                indexesPath.append(index)
            }
            self.selectServiceTableView!.beginUpdates()
            self.selectServiceTableView!.deleteRows(at: indexesPath, with: UITableView.RowAnimation.fade)
            self.selectServiceTableView!.endUpdates()
        }
    }
    
    @objc func sectionTapped(_ sender: UITapGestureRecognizer)
    {
        let headerView = sender.view
        let section  = headerView?.tag
        
    }
    
    @objc func expandSectionAction(sender: UIButton!) {
        
        
        
        if sender.tag == 0 || sender.tag == self.mainServiceArray.count + 1 || sender.tag == self.mainArray.count + 2 {
            
            
        } else {
            
            if  sender.tag >= self.mainServiceArray.count + 2 && sender.tag == self.mainArray.count + 3  {
                
                //                if homeObjc.home_service_status == "0" {
                //
                //                    return 0
                //
                //                } else {
                //
                //                    return 1
                //                }
                
                
            } else if sender.tag >= self.mainServiceArray.count + 2 {
                
                if self.mainArray[sender.tag - 2].addDescription == "" {
                    
                    self.mainArray[sender.tag - 2].addDescription = "1"

                    
                } else {

                    self.mainArray[sender.tag - 2].addDescription = ""
                    self.mainArray[sender.tag - 2].dscription = ""
//                    self.mainArray[sender.tag - 2].price = ""



                    
                }
                
                
            }  else {
                
                if self.mainArray[sender.tag - 1].addDescription == "" {
                    
                    self.mainArray[sender.tag - 1].addDescription = "1"

                    
                } else {
                    
                    self.mainArray[sender.tag - 1].addDescription = ""
                    self.mainArray[sender.tag - 1].dscription = ""
//                    self.mainArray[sender.tag - 1].price = ""



                }
                
            }
            
            
        }
    
        selectServiceTableView.reloadData()
        
        
        
    }
    
    @objc func collapseSectionAction(sender: UIButton!) {
        
        
        
        
        if sender.tag == 0 || sender.tag == self.mainServiceArray.count + 1 || sender.tag == self.mainArray.count + 2 {
            
            
        } else {
            
            if  sender.tag >= self.mainServiceArray.count + 2 && sender.tag == self.mainArray.count + 3  {
                
                //                if homeObjc.home_service_status == "0" {
                //
                //                    return 0
                //
                //                } else {
                //
                //                    return 1
                //                }
                
                
            } else if sender.tag >= self.mainServiceArray.count + 2 {
                
              
                    
                    self.mainArray[sender.tag - 2].addDescription = ""
                    self.mainArray[sender.tag - 2].dscription = ""
//                    self.mainArray[sender.tag - 2].price = ""


                    
               
                
            }  else {
            
                    
                    self.mainArray[sender.tag - 1].addDescription = ""
                    self.mainArray[sender.tag - 1].dscription = ""
//                    self.mainArray[sender.tag - 1].price = ""

               
                
            }
            
            
        }
        
   
        
        selectServiceTableView.reloadData()
        
        
    }
    
    @objc func switchBtnAction(sender: UISwitch!) {
        
        
        
         if  sender.tag >= self.mainServiceArray.count + 2 && sender.tag == self.mainArray.count + 3  {
            
            if homeObjc.home_service_status == "0" {
                
                sender.isOn = true
                
                
                if let sectionHeader = headerView {
                    
                    let headerHeight:CGFloat
                    
                    
                    headerHeight = 100.0
                    
                    
                    UIView.animate(withDuration: 0.3, animations: {
                        self.selectServiceTableView?.beginUpdates()
                        sectionHeader.frame.size.height = headerHeight
                        self.selectServiceTableView?.endUpdates()
                    } )
                    
                    homeObjc.home_service_status = "1"

                    
                }
                
                
                
            } else {
                
                sender.isOn = false
                
                
                if let sectionHeader = headerView {
                    
                    let headerHeight:CGFloat
                    
                    
                    headerHeight = 40.0
                    
                    
                    UIView.animate(withDuration: 0.3, animations: {
                        self.selectServiceTableView?.beginUpdates()
                        sectionHeader.frame.size.height = headerHeight
                        self.selectServiceTableView?.endUpdates()
                    } )
                    
                    homeObjc.home_service_status = "0"

                    
                }
                
                
            }
            
            
         } else if sender.tag >= self.mainServiceArray.count + 2 {
            
            if self.mainArray[sender.tag - 2].switchBool == true {
                
                sender.isOn = false
                
                self.mainArray[sender.tag - 2].switchBool = false

                self.mainArray[sender.tag - 2].addDesc = ""
                self.mainArray[sender.tag - 2].price = ""
                priceTextField.isHidden = true
                addBtn.isHidden = true
                line.isHidden = true
                
                
                if let sectionHeader = headerView {
                    
                    let headerHeight:CGFloat
                    
                    
                    headerHeight = 40.0
                    
                    
                    UIView.animate(withDuration: 0.3, animations: {
                        self.selectServiceTableView?.beginUpdates()
                        sectionHeader.frame.size.height = headerHeight
                        self.selectServiceTableView?.endUpdates()
                    } )
                    
                    
                    if self.mainArray[sender.tag - 2].addDescription == "1" {
                        
                        self.mainArray[sender.tag - 2].addDescription = ""
                        self.mainArray[sender.tag - 2].dscription = ""

                        
                    } else {
                        
                        self.mainArray[sender.tag - 2].addDescription = ""
                        self.mainArray[sender.tag - 2].dscription = ""

                    }
                }
                
                
                
            } else {

                
                sender.isOn = true

                self.mainArray[sender.tag - 2].switchBool = true
                
                
                self.mainArray[sender.tag - 2].addDesc = "1"
                priceTextField.isHidden = false
                addBtn.isHidden = false
                line.isHidden = false
                
                if let sectionHeader = headerView {
                    
                    let headerHeight:CGFloat
                    
                    
                    headerHeight = 100.0
                    
                    
                    UIView.animate(withDuration: 0.3, animations: {
                        self.selectServiceTableView?.beginUpdates()
                        sectionHeader.frame.size.height = headerHeight
                        self.selectServiceTableView?.endUpdates()
                    } )
                    
                    
                    if self.mainArray[sender.tag - 2].addDescription == "1" {
                        
                        self.mainArray[sender.tag - 2].addDescription = ""
                        self.mainArray[sender.tag - 2].dscription = ""

                        
                    } else {
                        
                        self.mainArray[sender.tag - 2].addDescription = ""
                        self.mainArray[sender.tag - 2].dscription = ""

                    }
                    
                }


                
            }
            
            
        }  else {
            
            if self.mainArray[sender.tag - 1].switchBool == true {
                
                sender.isOn = false

                
                self.mainArray[sender.tag - 1].switchBool = false
                                
                self.mainArray[sender.tag - 1].addDesc = ""
                self.mainArray[sender.tag - 1].price = ""
                priceTextField.isHidden = true
                addBtn.isHidden = true
                line.isHidden = true
                
                
                if let sectionHeader = headerView {
                    
                    let headerHeight:CGFloat
                    
                    
                    headerHeight = 40.0
                    
                    
                    UIView.animate(withDuration: 0.3, animations: {
                        self.selectServiceTableView?.beginUpdates()
                        sectionHeader.frame.size.height = headerHeight
                        self.selectServiceTableView?.endUpdates()
                    } )
                    
                    
                    if self.mainArray[sender.tag - 1].addDescription == "1" {
                        
                        self.mainArray[sender.tag - 1].addDescription = ""
                        self.mainArray[sender.tag - 1].dscription = ""

                        
                    } else {
                        
                        self.mainArray[sender.tag - 1].addDescription = ""
                        self.mainArray[sender.tag - 1].dscription = ""

                    }
                }

                
                
                
                

                
            } else {
                
                sender.isOn = true
                
                
                self.mainArray[sender.tag - 1].switchBool = true
                
                self.mainArray[sender.tag - 1].addDesc = "1"
                priceTextField.isHidden = false
                addBtn.isHidden = false
                line.isHidden = false
                
                if let sectionHeader = headerView {
                    
                    let headerHeight:CGFloat
                    
                    
                    headerHeight = 100.0
                    
                    
                    UIView.animate(withDuration: 0.3, animations: {
                        self.selectServiceTableView?.beginUpdates()
                        sectionHeader.frame.size.height = headerHeight
                        self.selectServiceTableView?.endUpdates()
                    } )
                    
                    
                    if self.mainArray[sender.tag - 1].addDescription == "1" {
                        
                        self.mainArray[sender.tag - 1].addDescription = ""
                        self.mainArray[sender.tag - 1].dscription = ""

                        
                    } else {
                        
                        self.mainArray[sender.tag - 1].addDescription = ""
                        self.mainArray[sender.tag - 1].dscription = ""

                    }
                    
                }


            }
            
        }
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
//
//
//            if  sender.tag >= self.mainServiceArray.count + 2 && sender.tag == self.mainArray.count + 3  {
//
//                //                if homeObjc.home_service_status == "0" {
//                //
//                //                    return 0
//                //
//                //                } else {
//                //
//                //                    return 1
//                //                }
//
//
//            } else if sender.tag >= self.mainServiceArray.count + 2 {
//
//
////                if self.mainArray[sender.tag - 2].switchBool == true {
////
////
////                    sender.isOn = false
////                } else {
////
////                    sender.isOn = true
////                }
//
//
//                if sender.isOn {
//                    sender.isOn = false
//
//
//                } else {
//
//                    sender.isOn = true
//
//                }
//
//
//
//
//            }  else {
//
//                if sender.isOn {
//
//                    //sender.isOn = true
//                    self.mainArray[sender.tag - 1].addDesc = "1"
//                    priceTextField.isHidden = false
//                    addBtn.isHidden = false
//                    line.isHidden = false
//
//                    if let sectionHeader = headerView {
//
//                        let headerHeight:CGFloat
//
//
//                        headerHeight = 100.0
//
//
//                        UIView.animate(withDuration: 0.3, animations: {
//                            self.selectServiceTableView?.beginUpdates()
//                            sectionHeader.frame.size.height = headerHeight
//                            self.selectServiceTableView?.endUpdates()
//                        } )
//                    }
//
//                } else {
//
//                    //sender.isOn = false
//
//                    self.mainArray[sender.tag - 1].addDesc = ""
//                    priceTextField.isHidden = true
//                    addBtn.isHidden = true
//                    line.isHidden = true
//
//
//                    if let sectionHeader = headerView {
//
//                        let headerHeight:CGFloat
//
//
//                        headerHeight = 30.0
//
//
//                        UIView.animate(withDuration: 0.3, animations: {
//                            self.selectServiceTableView?.beginUpdates()
//                            sectionHeader.frame.size.height = headerHeight
//                            self.selectServiceTableView?.endUpdates()
//                        } )
//                    }
//
//
//
//
//
//                }
                
                    
                    
                
                
                
                
//
//                if let sectionHeader = headerView {
//
//                    let headerHeight:CGFloat
//
//                    if sectionHeader.frame.size.height == 100 {
//                        headerHeight = 30.0
//                    } else {
//                        headerHeight = 100.0
//                    }
//
//                    UIView.animate(withDuration: 0.3, animations: {
//                        self.selectServiceTableView?.beginUpdates()
//                        sectionHeader.frame.size.height = headerHeight
//                        self.selectServiceTableView?.endUpdates()
//                    } )
//                }
                
                
                
                
                
                
                
           // }
            
      
        
        selectServiceTableView.reloadData()


        
    }
    
    
    func textWidth(text: String, font: UIFont?) -> CGFloat {
        let attributes = font != nil ? [NSAttributedString.Key.font: font] : [:]
        return text.size(withAttributes: attributes as [NSAttributedString.Key : Any]).width
    }
    
    
    
    // MARK: - Api Methods
    
    
    func getUserServicesApi()
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
                
                Alamofire.request(Base_Url+getUserServicesUrl , method: .post,  parameters: nil, encoding: URLEncoding.default, headers:headers)
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
                            
                            if let mainService = json["main_service"] as? NSArray , mainService.count > 0 {
                                
                                self.mainServiceArray = ProjectManager.sharedInstance.GetServiceObjects(array: mainService)
                                
                                
                            }
                            if let extraService = json["extra_service"] as? NSArray , extraService.count > 0 {
                                
                                self.ExtraServiceArray = ProjectManager.sharedInstance.GetServiceObjects(array: extraService)
                                
                                
                            }
                            
                            if let homeService = json["home_service"] as? [String: Any]  {
                                
                                self.homeObjc = ProjectManager.sharedInstance.GetHomeServiceObjects(dict: homeService)
                                
                                
                            }
                            
                            if self.homeObjc.home_service_status == "1" {
                                
                                
                            } else {
                                
                                
                            }
                            self.mainArray = self.mainServiceArray + self.ExtraServiceArray
                            self.selectServiceTableView.reloadData()
                        
                            
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
    
    
    func saveServiceApi(result :  String)
        {
            if ProjectManager.sharedInstance.isInternetAvailable()
            {
                if let apiToken = UserDefaults.standard.value(forKey: DefaultsIdentifier.apiToken) as? String {
                    
                    // if apiToken != nil {
                    
                    
                    
                    
                    DispatchQueue.main.async {
                         ProjectManager.sharedInstance.showLoader(vc: self)
                    }
                    
                    
                    let params = ["service_data":result, "home_service":homeObjc.home_service_status, "home_service_fee":homeObjc.home_service_fee] as [String: Any]
                    
                    print(params)
                    
                    let headers = [
                        "Authorization": "Bearer " + apiToken ,"Content-Type": "application/json" ,"Accept": "application/json" ]
                    
                    //"Accept": "application/json"
                    print(headers)
                    
                    Alamofire.request(Base_Url+saveServiceUrl , method: .post,  parameters: params, encoding: JSONEncoding.default, headers:headers)
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
                                
                                
                                if self.profileBool {
                                    
                                    self.dismiss(animated: true, completion: nil)
                                    
                                    
                                } else {
                                    
                                    
                                    var vc = ThankYouViewController()
                                    
                                    if #available(iOS 13.0, *) {
                                        
                                        vc = homeStoryBoard.instantiateViewController(identifier: "ThankYouViewController") as! ThankYouViewController
                                        
                                    } else {
                                        // Fallback on earlier versions
                                        
                                        vc = homeStoryBoard.instantiateViewController(withIdentifier: "ThankYouViewController") as! ThankYouViewController
                                        
                                    }
                                    
                                    vc.freelanceBool = self.freelanceBool
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

//
//  ScheduleViewController.swift
//  BarberApp
//
//  Created by iOS6 on 11/05/20.
//  Copyright © 2020 iOS8. All rights reserved.
//

import UIKit
import Alamofire

class ScheduleViewController: UIViewController , UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var receiveJobsTableView: UITableView!
    
    @IBOutlet var pickerInputView: UIView!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var datePickerStart: UIDatePicker!
      @IBOutlet weak var datePickerEnd: UIDatePicker!
    @IBOutlet weak var cancelToolBarBtn: UIBarButtonItem!
    @IBOutlet weak var doneToolBarBtn: UIBarButtonItem!
    
    
    let format =  DateFormatter()

    
    var switchBtn = UISwitch()
    let kHeaderSectionTag: Int = 6900;
    var i: Int = 0
    var answeredQuestionsArray: Array<Any> = []
    var sectionItems: Array<Any> = []
    //let section  = headerView?.tag
    var expandedSectionHeaderNumber: Int = -1
    var expandedSectionHeader: UITableViewHeaderFooterView!
    
    var currentIndex = Int()
    var sectionArray = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    var statusArray = [false, false, false, false, false, false, false]
    var sundayArray = [Int]()
    var mondayArray =  [Int]()
    var tuesdayArray =  [Int]()
    var wednesdayArray =  [Int]()
    var thursdayArray =  [Int]()
    var fridayArray =  [Int]()
    var saturdayArray =  [Int]()
    var sundayTimingsArray =  [String]()
    var mondayTimingsArray =  [String]()
    var tuesdayTimingsArray =  [String]()
    var wednesdayTimingsArray =  [String]()
    var thursdayTimingsArray =  [String]()
    var fridayTimingsArray =  [String]()
    var saturdayTimingsArray = [String]()
    var addBool = Bool()
    var monBool = Bool()
    var tuesBool = Bool()
    var wedBool = Bool()
    var thurBool = Bool()
    var friBool = Bool()
    var satBool = Bool()
    var availTimeArray = [ScheduleObject]()
    var objc = ScheduleObject()
    var btnRow = Int()
    var btnSection = Int()
    var accessLabel = String()
    var totalTimeArray = [ScheduleObject]()
    var switchValue = 1

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        print("******", sundayTimingsArray.count)
        getScheduleApi()
        format.dateFormat = "hh:mm a"
//        let date = format.date(from: "09:00")
//        let endDate = format.date(from: "05:00")
//        datePickerStart.date = date!
//        datePickerEnd.date = endDate!
        
        datePickerStart.setDate(from: "09:00", format: "hh:mm a")
        datePickerEnd.setDate(from: "05:00", format: "hh:mm a")
        timeCompare(startDate: "09:00 AM" , endDate: "05:00 PM", timeTocheck: "10:00 AM")




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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        
            btnSection = textField.tag
            accessLabel = textField.accessibilityLabel!
        
//        let index = NSIndexPath(row: btnRow, section:btnSection)
//
//         let cell = receiveJobsTableView.cellForRow(at: index as IndexPath) as! ReceiveJobsTableViewCell
        
//        if textField == nationalityTextField {
//
//            btnTag = textField.tag
//
//            datePicker.isHidden = true
//            pickerView.isHidden = false
//                showPicker()
//                pickerView.reloadAllComponents()
//
//
//        } else if textField == birthDateTextField {
//
//
//            datePicker.isHidden = false
//            pickerView.isHidden = true
//            btnTag = textField.tag
//            showPicker()
//
//
//        } else {
//
//            datePicker.isHidden = true
//            pickerView.isHidden = true
//
//
//        }
        
    }
    
    
    // MARK: -Custom Methods
    
    func timeCompare(startDate: String , endDate: String, timeTocheck: String) -> Bool {
        
       // let startDate = "09:00 AM"
       // let endDate = "05:00 PM"

        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"

       // let timeTocheck = "10:00 AM"

        let startTime = minutes(sinceMidnight: formatter.date(from: startDate))
        let endTime = minutes(sinceMidnight: formatter.date(from: endDate))
        let nowTime = minutes(sinceMidnight: formatter.date(from: timeTocheck))


        if startTime <= nowTime && nowTime <= endTime {
            print("Time is between")
            return true
        } else {
            print("Time is not between")
            return false
        }

    }
    
    func eachTimeCompare(startDate: String , endDate: String) -> Bool {
        
       // let startDate = "09:00 AM"
       // let endDate = "05:00 PM"

        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"

       // let timeTocheck = "10:00 AM"

        let startTime = minutes(sinceMidnight: formatter.date(from: startDate))
        let endTime = minutes(sinceMidnight: formatter.date(from: endDate))


        if startTime < endTime {
            print("Time is Greater")
            return true
        } else {
            print("Time is Smaller")
            return false
        }

    }
    
    
    func minutes(sinceMidnight date: Date?) -> Int {
        var components: DateComponents? = nil
        if let date = date {
            components = Calendar.current.dateComponents(
                [.hour, .minute, .second],
                from: date)
        }
        return 60 * Int(components?.hour ?? 0) + Int(components?.minute ?? 0)
    }

    func getParameters() -> [[String: Any]] {
        var result = [[String: Any]]()

        for mmap in totalTimeArray {
            let material: [String: Any] = [
                "time_from": mmap.time_from,
                "time_to": mmap.time_to,
                "day": mmap.day,
                "day_off_status": mmap.day_off_status
                
            ]
            result.append(material)
        }

        return result
    }
    
    func arryObject() -> [Any] {
        
        var categories = [Any]()

        for menu in totalTimeArray{
                 if(totalTimeArray.count != 0){
                    let Cat: NSMutableDictionary = NSMutableDictionary()
                     Cat.setValue(menu.time_from, forKey: "time_from")
                     Cat.setValue(menu.time_to, forKey: "time_to")
                    Cat.setValue(menu.day, forKey: "day")
                    Cat.setValue(menu.day_off_status, forKey: "day_off_status")
                //  let array = JSON(Cat)
                     categories.append(Cat)}
                 }
        
        print(categories)
        return categories

    }
    
    
    
    // MARK: - IB Actions
    
    @IBAction func backBtnAction(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pickServiceBtnAction(_ sender: Any) {
        
        print(availTimeArray)
        
//        if availTimeArray.count == 0 {
//
//            ProjectManager.sharedInstance.showAlertwithTitle(title: "Alert", desc: "Please select atleast one schedule.", vc: self)
//
//        } else {
//
//            for i in 0...availTimeArray.count - 1 {
//
//                let obj = ScheduleObject()
//                obj.time_from = availTimeArray[i].time_from
//                obj.time_to = availTimeArray[i].time_to
//                obj.day = availTimeArray[i].day
//                obj.day_off_status = availTimeArray[i].day_off_status
//                self.totalTimeArray.append(obj)
//
//
//            }
//
//          //  let result = getParameters()
//           let result = arryObject()
//
//           saveScheduleApi(result: result)
//
//        }
        
        
        //
        var vc = SelectServicesViewController()

        if #available(iOS 13.0, *) {

            vc = mainStoryBoard.instantiateViewController(identifier: "SelectServicesViewController") as! SelectServicesViewController

        } else {
            // Fallback on earlier versions

            vc = mainStoryBoard.instantiateViewController(withIdentifier: "SelectServicesViewController") as! SelectServicesViewController

        }

        self.present(vc, animated: true, completion: nil)
        
    }
    
    
      
      @IBAction func cancelBtnAction(_ sender: Any) {
             
             self.view.endEditing(true)
             
         }
         
    @IBAction func doneBtnAction(_ sender: Any) {
        
        
        //        var tag = (sender as AnyObject).tag
        //        var accessLabel = (sender as AnyObject).accessibilityLabel
        //
        //        var index = NSIndexPath(row: Int(accessLabel!!)!, section: tag!)
        
        let index = NSIndexPath(row: Int(accessLabel)!, section:btnSection)
        var cell = receiveJobsTableView.cellForRow(at: index as IndexPath) as! ReceiveJobsTableViewCell
        
        format.dateFormat = "hh:mm a"
        
        if btnSection == 0 {
            
            if accessLabel == "0" {
                
                let check = eachTimeCompare(startDate: format.string(from: datePickerStart.date), endDate: format.string(from: datePickerEnd.date))
                
                
                if check {
                    
                    cell.timeRangeTextField.text = format.string(from: datePickerStart.date) + " - " +  format.string(from: datePickerEnd.date)
                    
                    let objc = ScheduleObject()
                    objc.time_from = format.string(from: datePickerStart.date)
                    objc.time_to = format.string(from: datePickerEnd.date)
                    objc.day = "Sunday"
                    objc.day_off_status = "1"
                    objc.identify = 1
                    
                    if  self.availTimeArray.contains(where: { $0.identify == 1 }) {
                        
                        // found
                        
                        let index = self.availTimeArray.firstIndex(where: { $0.identify == objc.identify })
                        self.availTimeArray[index!].time_from = objc.time_from
                        self.availTimeArray[index!].time_to = objc.time_to
                        
                        
                    } else {
                        
                        // not
                        
                        self.availTimeArray.append(objc)
                        
                    }
                    
                    //self.availTimeArray.append(objc)
                    print(availTimeArray)
                    
                } else {
                    
                    ProjectManager.sharedInstance.showAlertwithTitle(title: "Alert!", desc: "Time should not be between or equal to selected time slot", vc: self)
                    
                }
                
                
                
            }
            
            if accessLabel == "1" {
                
                
                let value = eachTimeCompare(startDate: format.string(from: datePickerStart.date), endDate: format.string(from: datePickerEnd.date))
                
                if value {
                    
                    //                    cell.timeRangeTextField.text = format.string(from: datePickerStart.date) + " - " +  format.string(from: datePickerEnd.date)
                    
                    let objc = ScheduleObject()
                    
                    objc.time_from = format.string(from: datePickerStart.date)
                    objc.time_to = format.string(from: datePickerEnd.date)
                    objc.day = "Sunday"
                    objc.day_off_status = "1"
                    objc.identify = 2
                    
                    let Sd = format.string(from: datePickerStart.date)
                    let Ed = format.string(from: datePickerEnd.date)
                    if let index = self.availTimeArray.firstIndex(where: { $0.identify == 1 }) {
                        let previousDate =  self.availTimeArray[index].time_from
                        let previousDate1 =  self.availTimeArray[index].time_to
                        
                        
                        let check =  timeCompare(startDate: previousDate, endDate: previousDate1, timeTocheck: Sd)
                        let check1 = timeCompare(startDate: previousDate, endDate: previousDate1, timeTocheck: Ed)
                        
                        if check ==  false && check1 ==  false {
                            
                            cell.timeRangeTextField.text = format.string(from: datePickerStart.date) + " - " +  format.string(from: datePickerEnd.date)
                            
                            if  self.availTimeArray.contains(where: { $0.identify == 2 }) {
                                
                                // found
                                
                                let index = self.availTimeArray.firstIndex(where: { $0.identify == objc.identify })
                                self.availTimeArray[index!].time_from = objc.time_from
                                self.availTimeArray[index!].time_to = objc.time_to
                                
                                
                            } else {
                                
                                // not
                                
                                self.availTimeArray.append(objc)
                                
                            }
                            
                            // self.availTimeArray.append(objc)
                            
                        } else {
                            
                            ProjectManager.sharedInstance.showAlertwithTitle(title: "Alert!", desc: "Time should not be between or equal to selected time slot", vc: self)
                        }
                        
                    }  else {
                        
                        cell.timeRangeTextField.text = format.string(from: datePickerStart.date) + " - " +  format.string(from: datePickerEnd.date)
                        
                        
                        if  self.availTimeArray.contains(where: { $0.identify == 2 }) {
                            
                            // found
                            
                            let index = self.availTimeArray.firstIndex(where: { $0.identify == objc.identify })
                            self.availTimeArray[index!].time_from = objc.time_from
                            self.availTimeArray[index!].time_to = objc.time_to
                            
                            
                        } else {
                            
                            // not
                            
                            self.availTimeArray.append(objc)
                            
                        }
                        
                        
                    }
                    
                } else {
                    
                    ProjectManager.sharedInstance.showAlertwithTitle(title: "Alert!", desc: "Time should not be between or equal to selected time slot", vc: self)
                }
                
            }
        }
        
        if btnSection == 1 {
            
            if accessLabel == "0" {
                
                let check = eachTimeCompare(startDate: format.string(from: datePickerStart.date), endDate: format.string(from: datePickerEnd.date))
                
                
                if check {
                    
                    cell.timeRangeTextField.text = format.string(from: datePickerStart.date) + " - " +  format.string(from: datePickerEnd.date)
                    
                    
                    let objc = ScheduleObject()
                    
                    objc.time_from = format.string(from: datePickerStart.date)
                    objc.time_to = format.string(from: datePickerEnd.date)
                    objc.day = "Monday"
                    objc.day_off_status = "1"
                    objc.identify = 3
                    
                    if  self.availTimeArray.contains(where: { $0.identify == 3 }) {
                        
                        // found
                        
                        let index = self.availTimeArray.firstIndex(where: { $0.identify == objc.identify })
                        self.availTimeArray[index!].time_from = objc.time_from
                        self.availTimeArray[index!].time_to = objc.time_to
                        
                        
                    } else {
                        
                        // not
                        
                        self.availTimeArray.append(objc)
                        
                    }
                    
                } else {
                    
                    ProjectManager.sharedInstance.showAlertwithTitle(title: "Alert!", desc: "Time should not be between or equal to selected time slot", vc: self)
                }
                
                
            }
            
            if accessLabel == "1" {
                
                let value = eachTimeCompare(startDate: format.string(from: datePickerStart.date), endDate: format.string(from: datePickerEnd.date))
                
                if value {
                    
                    //                    cell.timeRangeTextField.text = format.string(from: datePickerStart.date) + " - " +  format.string(from: datePickerEnd.date)
                    
                    let objc = ScheduleObject()
                    
                    objc.time_from = format.string(from: datePickerStart.date)
                    objc.time_to = format.string(from: datePickerEnd.date)
                    objc.day = "Monday"
                    objc.day_off_status = "1"
                    objc.identify = 4
                    
                    let Sd = format.string(from: datePickerStart.date)
                    let Ed = format.string(from: datePickerEnd.date)
                    if let index = self.availTimeArray.firstIndex(where: { $0.identify == 3 }) {
                        let previousDate =  self.availTimeArray[index].time_from
                        let previousDate1 =  self.availTimeArray[index].time_to
                        
                        
                        let check =  timeCompare(startDate: previousDate, endDate: previousDate1, timeTocheck: Sd)
                        let check1 = timeCompare(startDate: previousDate, endDate: previousDate1, timeTocheck: Ed)
                        
                        if check ==  false && check1 ==  false {
                            
                            
                            cell.timeRangeTextField.text = format.string(from: datePickerStart.date) + " - " +  format.string(from: datePickerEnd.date)
                            
                            if  self.availTimeArray.contains(where: { $0.identify == 4 }) {
                                
                                // found
                                
                                let index = self.availTimeArray.firstIndex(where: { $0.identify == objc.identify })
                                self.availTimeArray[index!].time_from = objc.time_from
                                self.availTimeArray[index!].time_to = objc.time_to
                                
                                
                            } else {
                                
                                // not
                                
                                self.availTimeArray.append(objc)
                                
                            }
                            
                        }  else {
                            
                            cell.timeRangeTextField.text = format.string(from: datePickerStart.date) + " - " +  format.string(from: datePickerEnd.date)
                            
                            
                            if  self.availTimeArray.contains(where: { $0.identify == 4 }) {
                                
                                // found
                                
                                let index = self.availTimeArray.firstIndex(where: { $0.identify == objc.identify })
                                self.availTimeArray[index!].time_from = objc.time_from
                                self.availTimeArray[index!].time_to = objc.time_to
                                
                                
                            } else {
                                
                                // not
                                
                                self.availTimeArray.append(objc)
                                
                            }
                            
                            
                        }
                        
                    } else {
                        
                        ProjectManager.sharedInstance.showAlertwithTitle(title: "Alert!", desc: "Time should not be between or equal to selected time slot", vc: self)
                    }
                    
                } else {
                    
                    ProjectManager.sharedInstance.showAlertwithTitle(title: "Alert!", desc: "Time should not be between or equal to selected time slot", vc: self)
                }
                
            }
        }
        
        if btnSection == 2 {
            
            if accessLabel == "0" {
                
                let check = eachTimeCompare(startDate: format.string(from: datePickerStart.date), endDate: format.string(from: datePickerEnd.date))
                
                
                if check {
                    
                    cell.timeRangeTextField.text = format.string(from: datePickerStart.date) + " - " +  format.string(from: datePickerEnd.date)
                    
                    let objc = ScheduleObject()
                    
                    objc.time_from = format.string(from: datePickerStart.date)
                    objc.time_to = format.string(from: datePickerEnd.date)
                    objc.day = "Tuesday"
                    objc.day_off_status = "1"
                    objc.identify = 5
                    
                    if  self.availTimeArray.contains(where: { $0.identify == 5 }) {
                        
                        // found
                        
                        let index = self.availTimeArray.firstIndex(where: { $0.identify == objc.identify })
                        self.availTimeArray[index!].time_from = objc.time_from
                        self.availTimeArray[index!].time_to = objc.time_to
                        
                        
                    } else {
                        
                        // not
                        
                        self.availTimeArray.append(objc)
                        
                    }
                    
                } else {
                    
                    ProjectManager.sharedInstance.showAlertwithTitle(title: "Alert!", desc: "Time should not be between or equal to selected time slot", vc: self)
                }
                
            }
            
            if accessLabel == "1" {
                
                let value = eachTimeCompare(startDate: format.string(from: datePickerStart.date), endDate: format.string(from: datePickerEnd.date))
                
                if value {
                    
                    //                    cell.timeRangeTextField.text = format.string(from: datePickerStart.date) + " - " +  format.string(from: datePickerEnd.date)
                    
                    let objc = ScheduleObject()
                    
                    objc.time_from = format.string(from: datePickerStart.date)
                    objc.time_to = format.string(from: datePickerEnd.date)
                    objc.day = "Tuesday"
                    objc.day_off_status = "1"
                    objc.identify = 6
                    
                    let Sd = format.string(from: datePickerStart.date)
                    let Ed = format.string(from: datePickerEnd.date)
                    if let index = self.availTimeArray.firstIndex(where: { $0.identify == 5 }) {
                        let previousDate =  self.availTimeArray[index].time_from
                        let previousDate1 =  self.availTimeArray[index].time_to
                        
                        
                        let check =  timeCompare(startDate: previousDate, endDate: previousDate1, timeTocheck: Sd)
                        let check1 = timeCompare(startDate: previousDate, endDate: previousDate1, timeTocheck: Ed)
                        
                        if check ==  false && check1 ==  false {
                            
                            cell.timeRangeTextField.text = format.string(from: datePickerStart.date) + " - " +  format.string(from: datePickerEnd.date)
                            
                            if  self.availTimeArray.contains(where: { $0.identify == 6 }) {
                                
                                // found
                                
                                let index = self.availTimeArray.firstIndex(where: { $0.identify == objc.identify })
                                self.availTimeArray[index!].time_from = objc.time_from
                                self.availTimeArray[index!].time_to = objc.time_to
                                
                                
                            } else {
                                
                                // not
                                
                                self.availTimeArray.append(objc)
                                
                            }
                            
                        } else {
                            
                            ProjectManager.sharedInstance.showAlertwithTitle(title: "Alert!", desc: "Time should not be between or equal to selected time slot", vc: self)
                        }
                        
                    }  else {
                        
                        cell.timeRangeTextField.text = format.string(from: datePickerStart.date) + " - " +  format.string(from: datePickerEnd.date)
                        
                        
                        if  self.availTimeArray.contains(where: { $0.identify == 6 }) {
                            
                            // found
                            
                            let index = self.availTimeArray.firstIndex(where: { $0.identify == objc.identify })
                            self.availTimeArray[index!].time_from = objc.time_from
                            self.availTimeArray[index!].time_to = objc.time_to
                            
                            
                        } else {
                            
                            // not
                            
                            self.availTimeArray.append(objc)
                            
                        }
                        
                        
                    }
                    
                } else {
                    
                    ProjectManager.sharedInstance.showAlertwithTitle(title: "Alert!", desc: "Time should not be between or equal to selected time slot", vc: self)
                }
                
                
            }
        }
        
        if btnSection == 3 {
            
            if accessLabel == "0" {
                
                let check = eachTimeCompare(startDate: format.string(from: datePickerStart.date), endDate: format.string(from: datePickerEnd.date))
                
                
                if check {
                    
                    cell.timeRangeTextField.text = format.string(from: datePickerStart.date) + " - " +  format.string(from: datePickerEnd.date)
                    
                    let objc = ScheduleObject()
                    
                    objc.time_from = format.string(from: datePickerStart.date)
                    objc.time_to = format.string(from: datePickerEnd.date)
                    objc.day = "Wednesday"
                    objc.day_off_status = "1"
                    objc.identify = 7
                    
                    if  self.availTimeArray.contains(where: { $0.identify == 7 }) {
                        
                        // found
                        
                        let index = self.availTimeArray.firstIndex(where: { $0.identify == objc.identify })
                        self.availTimeArray[index!].time_from = objc.time_from
                        self.availTimeArray[index!].time_to = objc.time_to
                        
                        
                    } else {
                        
                        // not
                        
                        self.availTimeArray.append(objc)
                        
                    }
                    
                    
                } else {
                    
                    ProjectManager.sharedInstance.showAlertwithTitle(title: "Alert!", desc: "Time should not be between or equal to selected time slot", vc: self)
                }
                
            }
            
            if accessLabel == "1" {
                
                let value = eachTimeCompare(startDate: format.string(from: datePickerStart.date), endDate: format.string(from: datePickerEnd.date))
                
                if value {
                    
                    //                    cell.timeRangeTextField.text = format.string(from: datePickerStart.date) + " - " +  format.string(from: datePickerEnd.date)
                    
                    let objc = ScheduleObject()
                    
                    objc.time_from = format.string(from: datePickerStart.date)
                    objc.time_to = format.string(from: datePickerEnd.date)
                    objc.day = "Wednesday"
                    objc.day_off_status = "1"
                    objc.identify = 8
                    
                    let Sd = format.string(from: datePickerStart.date)
                    let Ed = format.string(from: datePickerEnd.date)
                    if let index = self.availTimeArray.firstIndex(where: { $0.identify == 7 }) {
                        let previousDate =  self.availTimeArray[index].time_from
                        let previousDate1 =  self.availTimeArray[index].time_to
                        
                        
                        let check =  timeCompare(startDate: previousDate, endDate: previousDate1, timeTocheck: Sd)
                        let check1 = timeCompare(startDate: previousDate, endDate: previousDate1, timeTocheck: Ed)
                        
                        if check ==  false && check1 ==  false {
                            
                            cell.timeRangeTextField.text = format.string(from: datePickerStart.date) + " - " +  format.string(from: datePickerEnd.date)
                            
                            
                            if  self.availTimeArray.contains(where: { $0.identify == 8 }) {
                                
                                // found
                                
                                let index = self.availTimeArray.firstIndex(where: { $0.identify == objc.identify })
                                self.availTimeArray[index!].time_from = objc.time_from
                                self.availTimeArray[index!].time_to = objc.time_to
                                
                                
                            } else {
                                
                                // not
                                
                                self.availTimeArray.append(objc)
                                
                            }
                            
                        }  else {
                            
                            cell.timeRangeTextField.text = format.string(from: datePickerStart.date) + " - " +  format.string(from: datePickerEnd.date)
                            
                            
                            if  self.availTimeArray.contains(where: { $0.identify == 8 }) {
                                
                                // found
                                
                                let index = self.availTimeArray.firstIndex(where: { $0.identify == objc.identify })
                                self.availTimeArray[index!].time_from = objc.time_from
                                self.availTimeArray[index!].time_to = objc.time_to
                                
                                
                            } else {
                                
                                // not
                                
                                self.availTimeArray.append(objc)
                                
                            }
                            
                            
                        }
                        
                    } else {
                        
                        ProjectManager.sharedInstance.showAlertwithTitle(title: "Alert!", desc: "Time should not be between or equal to selected time slot", vc: self)
                    }
                    
                } else {
                    
                    ProjectManager.sharedInstance.showAlertwithTitle(title: "Alert!", desc: "Time should not be between or equal to selected time slot", vc: self)
                }
                
                
            }
        }
        
        if btnSection == 4 {
            
            if accessLabel == "0" {
                
                let check = eachTimeCompare(startDate: format.string(from: datePickerStart.date), endDate: format.string(from: datePickerEnd.date))
                
                
                if check {
                    
                    cell.timeRangeTextField.text = format.string(from: datePickerStart.date) + " - " +  format.string(from: datePickerEnd.date)
                    
                    let objc = ScheduleObject()
                    
                    objc.time_from = format.string(from: datePickerStart.date)
                    objc.time_to = format.string(from: datePickerEnd.date)
                    objc.day = "Thursday"
                    objc.day_off_status = "1"
                    objc.identify = 9
                    
                    if  self.availTimeArray.contains(where: { $0.identify == 9 }) {
                        
                        // found
                        
                        let index = self.availTimeArray.firstIndex(where: { $0.identify == objc.identify })
                        self.availTimeArray[index!].time_from = objc.time_from
                        self.availTimeArray[index!].time_to = objc.time_to
                        
                        
                    } else {
                        
                        // not
                        
                        self.availTimeArray.append(objc)
                        
                    }
                } else {
                    
                    ProjectManager.sharedInstance.showAlertwithTitle(title: "Alert!", desc: "Time should not be between or equal to selected time slot", vc: self)
                }
                
                
            }
            
            if accessLabel == "1" {
                
                let value = eachTimeCompare(startDate: format.string(from: datePickerStart.date), endDate: format.string(from: datePickerEnd.date))
                
                if value {
                    
                    //                    cell.timeRangeTextField.text = format.string(from: datePickerStart.date) + " - " +  format.string(from: datePickerEnd.date)
                    
                    let objc = ScheduleObject()
                    
                    objc.time_from = format.string(from: datePickerStart.date)
                    objc.time_to = format.string(from: datePickerEnd.date)
                    objc.day = "Thursday"
                    objc.day_off_status = "1"
                    objc.identify = 10
                    
                    let Sd = format.string(from: datePickerStart.date)
                    let Ed = format.string(from: datePickerEnd.date)
                    if let index = self.availTimeArray.firstIndex(where: { $0.identify == 9 }) {
                        let previousDate =  self.availTimeArray[index].time_from
                        let previousDate1 =  self.availTimeArray[index].time_to
                        
                        
                        let check =  timeCompare(startDate: previousDate, endDate: previousDate1, timeTocheck: Sd)
                        let check1 = timeCompare(startDate: previousDate, endDate: previousDate1, timeTocheck: Ed)
                        
                        if check ==  false && check1 ==  false {
                            
                            cell.timeRangeTextField.text = format.string(from: datePickerStart.date) + " - " +  format.string(from: datePickerEnd.date)
                            
                            if  self.availTimeArray.contains(where: { $0.identify == 10 }) {
                                
                                // found
                                
                                let index = self.availTimeArray.firstIndex(where: { $0.identify == objc.identify })
                                self.availTimeArray[index!].time_from = objc.time_from
                                self.availTimeArray[index!].time_to = objc.time_to
                                
                                
                            } else {
                                
                                // not
                                
                                self.availTimeArray.append(objc)
                                
                            }
                            
                        } else {
                            
                            ProjectManager.sharedInstance.showAlertwithTitle(title: "Alert!", desc: "Time should not be between or equal to selected time slot", vc: self)
                        }
                        
                    }  else {
                        
                        cell.timeRangeTextField.text = format.string(from: datePickerStart.date) + " - " +  format.string(from: datePickerEnd.date)
                        
                        
                        if  self.availTimeArray.contains(where: { $0.identify == 10 }) {
                            
                            // found
                            
                            let index = self.availTimeArray.firstIndex(where: { $0.identify == objc.identify })
                            self.availTimeArray[index!].time_from = objc.time_from
                            self.availTimeArray[index!].time_to = objc.time_to
                            
                            
                        } else {
                            
                            // not
                            
                            self.availTimeArray.append(objc)
                            
                        }
                        
                        
                    }
                    
                } else {
                    
                    ProjectManager.sharedInstance.showAlertwithTitle(title: "Alert!", desc: "Time should not be between or equal to selected time slot", vc: self)
                }
                
                
                
            }
        }
        
        if btnSection == 5 {
            
            if accessLabel == "0" {
                
                let check = eachTimeCompare(startDate: format.string(from: datePickerStart.date), endDate: format.string(from: datePickerEnd.date))
                
                
                if check {
                    
                    cell.timeRangeTextField.text = format.string(from: datePickerStart.date) + " - " +  format.string(from: datePickerEnd.date)
                    
                    let objc = ScheduleObject()
                    
                    objc.time_from = format.string(from: datePickerStart.date)
                    objc.time_to = format.string(from: datePickerEnd.date)
                    objc.day = "Friday"
                    objc.day_off_status = "1"
                    objc.identify = 11
                    
                    if  self.availTimeArray.contains(where: { $0.identify == 11 }) {
                        
                        // found
                        
                        let index = self.availTimeArray.firstIndex(where: { $0.identify == objc.identify })
                        self.availTimeArray[index!].time_from = objc.time_from
                        self.availTimeArray[index!].time_to = objc.time_to
                        
                        
                    } else {
                        
                        // not
                        
                        self.availTimeArray.append(objc)
                        
                    }
                    
                } else {
                    
                    ProjectManager.sharedInstance.showAlertwithTitle(title: "Alert!", desc: "Time should not be between or equal to selected time slot", vc: self)
                }
                
                
            }
            
            if accessLabel == "1" {
                
                let value = eachTimeCompare(startDate: format.string(from: datePickerStart.date), endDate: format.string(from: datePickerEnd.date))
                
                if value {
                    
                    //                    cell.timeRangeTextField.text = format.string(from: datePickerStart.date) + " - " +  format.string(from: datePickerEnd.date)
                    
                    let objc = ScheduleObject()
                    
                    objc.time_from = format.string(from: datePickerStart.date)
                    objc.time_to = format.string(from: datePickerEnd.date)
                    objc.day = "Friday"
                    objc.day_off_status = "1"
                    objc.identify = 12
                    
                    let Sd = format.string(from: datePickerStart.date)
                    let Ed = format.string(from: datePickerEnd.date)
                    if let index = self.availTimeArray.firstIndex(where: { $0.identify == 11 }) {
                        let previousDate =  self.availTimeArray[index].time_from
                        let previousDate1 =  self.availTimeArray[index].time_to
                        
                        
                        let check =  timeCompare(startDate: previousDate, endDate: previousDate1, timeTocheck: Sd)
                        let check1 = timeCompare(startDate: previousDate, endDate: previousDate1, timeTocheck: Ed)
                        
                        if check ==  false && check1 ==  false {
                            
                            cell.timeRangeTextField.text = format.string(from: datePickerStart.date) + " - " +  format.string(from: datePickerEnd.date)
                            
                            if  self.availTimeArray.contains(where: { $0.identify == 12 }) {
                                
                                // found
                                
                                let index = self.availTimeArray.firstIndex(where: { $0.identify == objc.identify })
                                self.availTimeArray[index!].time_from = objc.time_from
                                self.availTimeArray[index!].time_to = objc.time_to
                                
                                
                            } else {
                                
                                // not
                                
                                self.availTimeArray.append(objc)
                                
                            }
                            
                        } else {
                            
                            ProjectManager.sharedInstance.showAlertwithTitle(title: "Alert!", desc: "Time should not be between or equal to selected time slot", vc: self)
                        }
                        
                    }  else {
                        
                        cell.timeRangeTextField.text = format.string(from: datePickerStart.date) + " - " +  format.string(from: datePickerEnd.date)
                        
                        
                        if  self.availTimeArray.contains(where: { $0.identify == 12 }) {
                            
                            // found
                            
                            let index = self.availTimeArray.firstIndex(where: { $0.identify == objc.identify })
                            self.availTimeArray[index!].time_from = objc.time_from
                            self.availTimeArray[index!].time_to = objc.time_to
                            
                            
                        } else {
                            
                            // not
                            
                            self.availTimeArray.append(objc)
                            
                        }
                        
                        
                    }
                    
                } else {
                    
                    ProjectManager.sharedInstance.showAlertwithTitle(title: "Alert!", desc: "Time should not be between or equal to selected time slot", vc: self)
                }
                
                
            }
        }
        
        if btnSection == 6 {
            
            if accessLabel == "0" {
                
                let check = eachTimeCompare(startDate: format.string(from: datePickerStart.date), endDate: format.string(from: datePickerEnd.date))
                
                
                if check {
                    
                    cell.timeRangeTextField.text = format.string(from: datePickerStart.date) + " - " +  format.string(from: datePickerEnd.date)
                    
                    let objc = ScheduleObject()
                    
                    objc.time_from = format.string(from: datePickerStart.date)
                    objc.time_to = format.string(from: datePickerEnd.date)
                    objc.day = "Saturday"
                    objc.day_off_status = "1"
                    objc.identify = 13
                    
                    if  self.availTimeArray.contains(where: { $0.identify == 13 }) {
                        
                        // found
                        
                        let index = self.availTimeArray.firstIndex(where: { $0.identify == objc.identify })
                        self.availTimeArray[index!].time_from = objc.time_from
                        self.availTimeArray[index!].time_to = objc.time_to
                        
                        
                    } else {
                        
                        // not
                        
                        self.availTimeArray.append(objc)
                        
                    }
                    
                } else {
                    
                    ProjectManager.sharedInstance.showAlertwithTitle(title: "Alert!", desc: "Time should not be between or equal to selected time slot", vc: self)
                }
                
            }
            
            if accessLabel == "1" {
                
                let value = eachTimeCompare(startDate: format.string(from: datePickerStart.date), endDate: format.string(from: datePickerEnd.date))
                
                if value {
                    
                    //                    cell.timeRangeTextField.text = format.string(from: datePickerStart.date) + " - " +  format.string(from: datePickerEnd.date)
                    
                    let objc = ScheduleObject()
                    
                    objc.time_from = format.string(from: datePickerStart.date)
                    objc.time_to = format.string(from: datePickerEnd.date)
                    objc.day = "Saturday"
                    objc.day_off_status = "1"
                    objc.identify = 14
                    
                    
                    let Sd = format.string(from: datePickerStart.date)
                    let Ed = format.string(from: datePickerEnd.date)
                    if let index = self.availTimeArray.firstIndex(where: { $0.identify == 13 }) {
                        let previousDate =  self.availTimeArray[index].time_from
                        let previousDate1 =  self.availTimeArray[index].time_to
                        
                        
                        let check =  timeCompare(startDate: previousDate, endDate: previousDate1, timeTocheck: Sd)
                        let check1 = timeCompare(startDate: previousDate, endDate: previousDate1, timeTocheck: Ed)
                        
                        if check ==  false && check1 ==  false {
                            
                            cell.timeRangeTextField.text = format.string(from: datePickerStart.date) + " - " +  format.string(from: datePickerEnd.date)
                            
                            
                            if  self.availTimeArray.contains(where: { $0.identify == 14 }) {
                                
                                // found
                                
                                let index = self.availTimeArray.firstIndex(where: { $0.identify == objc.identify })
                                self.availTimeArray[index!].time_from = objc.time_from
                                self.availTimeArray[index!].time_to = objc.time_to
                                
                                
                            } else {
                                
                                // not
                                
                                self.availTimeArray.append(objc)
                                
                            }
                            
                        } else {
                            
                            ProjectManager.sharedInstance.showAlertwithTitle(title: "Alert!", desc: "Time should not be between or equal to selected time slot", vc: self)
                        }
                        
                    } else {
                        
                        cell.timeRangeTextField.text = format.string(from: datePickerStart.date) + " - " +  format.string(from: datePickerEnd.date)
                        
                        
                        if  self.availTimeArray.contains(where: { $0.identify == 14 }) {
                            
                            // found
                            
                            let index = self.availTimeArray.firstIndex(where: { $0.identify == objc.identify })
                            self.availTimeArray[index!].time_from = objc.time_from
                            self.availTimeArray[index!].time_to = objc.time_to
                            
                            
                        } else {
                            
                            // not
                            
                            self.availTimeArray.append(objc)
                            
                        }
                        
                        
                    }
                    
                } else {
                    
                    ProjectManager.sharedInstance.showAlertwithTitle(title: "Alert!", desc: "Time should not be between or equal to selected time slot", vc: self)
                }
                
            }
        }
        
        self.view.endEditing(true)
        
        
    }
    
    
    // MARK: - TableView Delegates
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return sectionArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            
            return sundayTimingsArray.count
            
        } else  if section == 1 {
            
            return mondayTimingsArray.count
            
        } else  if section == 2 {
            
            return tuesdayTimingsArray.count
            
        } else  if section == 3 {
            
            return wednesdayTimingsArray.count
            
        } else  if section == 4 {
            
            return thursdayTimingsArray.count
            
        } else  if section == 5 {
            
            return fridayTimingsArray.count
            
        } else  if section == 6 {
            
            return saturdayTimingsArray.count
            
        } else {
            
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        guard let cell = receiveJobsTableView.dequeueReusableCell(withIdentifier:"receiveJobCell", for: indexPath) as? ReceiveJobsTableViewCell else {return UITableViewCell()}
        
//        cell.timeRangeTextField.tag = indexPath.row
//        cell.timeRangeTextField.accessibilityLabel = "\(indexPath.section)"
        
        cell.timeRangeTextField.delegate = self
        cell.timeRangeTextField.accessibilityLabel = "\(indexPath.row)"
        cell.timeRangeTextField.tag = indexPath.section
        cell.addDeleteBtn.accessibilityLabel = "\(indexPath.row)"
        cell.addDeleteBtn.tag = indexPath.section
        
        cell.timeRangeTextField.inputView = pickerInputView
        cell.timeRangeTextField.inputAccessoryView = nil
//        btnSection = cell.timeRangeTextField.tag
//        accessLabel = cell.timeRangeTextField.accessibilityLabel!
//        btnRow = Int(accessLabel)!
        
//        doneToolBarBtn.accessibilityLabel = cell.timeRangeTextField.accessibilityLabel
//        doneToolBarBtn.tag = cell.timeRangeTextField.tag

        
        print("*****", indexPath.row)
        
        
        if indexPath.row == 0 {
            
            cell.addDeleteBtn.setImage(#imageLiteral(resourceName: "addBtn"), for: .normal)
            
            
        }
        
        if indexPath.section == 0 {
            
            print("*****0", indexPath.section)
            
            
            if indexPath.row == 1 && sundayTimingsArray.count == 2 {
                
                cell.addDeleteBtn.setImage(#imageLiteral(resourceName: "deleteBtn"), for: .normal)
                //addBool  = true
                print("*****0", indexPath.row)
                
                
                
            }
            //            if indexPath.row == 0 && sundayTimingsArray.count == 1  {
            //
            //                cell.addDeleteBtn.setImage(#imageLiteral(resourceName: "addBtn"), for: .normal)
            //                //addBool = false
            //                print("*****0", indexPath.row)
            //
            //
            //
            //            }
            
            
            cell.onAddDeleteButtonTapped = {
                
                if indexPath.row == 1 {
                    
                    print("*****0", indexPath.row)
                    
                    
                    self.collapseSectionAction(sender: cell.addDeleteBtn)
                    
                    //self.addBool = false
                    
                    
                }
                if indexPath.row == 0 {
                    
                    print("*****0", indexPath.row)
                    
                    self.expandSectionAction(sender: cell.addDeleteBtn)
                    
                }
                
            }
            
        }
        
        if indexPath.section == 1 {
            print("*****1", indexPath.section)
            
            
            if  indexPath.row == 1 && mondayTimingsArray.count == 2 {
                
                cell.addDeleteBtn.setImage(#imageLiteral(resourceName: "deleteBtn"), for: .normal)
                // monBool  = true
                print("*****1", indexPath.row)
                
                
                
            }
            //            if indexPath.row == 0 && mondayTimingsArray.count == 1 {
            //
            //                cell.addDeleteBtn.setImage(#imageLiteral(resourceName: "addBtn"), for: .normal)
            //                //monBool = false
            //
            //                print("*****1", indexPath.row)
            //
            //
            //            }
            
            cell.onAddDeleteButtonTapped = {
                
                
                if indexPath.row == 1 {
                    
                    self.collapseSectionAction(sender: cell.addDeleteBtn)
                    
                    //self.addBool = false
                    
                    print("*****1", indexPath.row)
                    
                    
                    
                }
                
                if indexPath.row == 0 {
                    
                    print("*****", indexPath.row)
                    
                    self.expandSectionAction(sender: cell.addDeleteBtn)
                    
                    print("*****1", indexPath.row)
                    
                    
                }
                
                
            }
            
            
        }
        
        
        if indexPath.section == 2 {
            print("*****1", indexPath.section)
            
            
            if  indexPath.row == 1 && tuesdayTimingsArray.count == 2 {
                
                cell.addDeleteBtn.setImage(#imageLiteral(resourceName: "deleteBtn"), for: .normal)
                // monBool  = true
                print("*****1", indexPath.row)
                
                
                
            }
            //            if indexPath.row == 0 && mondayTimingsArray.count == 1 {
            //
            //                cell.addDeleteBtn.setImage(#imageLiteral(resourceName: "addBtn"), for: .normal)
            //                //monBool = false
            //
            //                print("*****1", indexPath.row)
            //
            //
            //            }
            
            cell.onAddDeleteButtonTapped = {
                
                
                if indexPath.row == 1 {
                    
                    self.collapseSectionAction(sender: cell.addDeleteBtn)
                    
                    //self.addBool = false
                    
                    print("*****1", indexPath.row)
                    
                    
                    
                }
                
                if indexPath.row == 0 {
                    
                    print("*****", indexPath.row)
                    
                    self.expandSectionAction(sender: cell.addDeleteBtn)
                    
                    print("*****1", indexPath.row)
                    
                    
                }
                
                
            }
            
            
        }
        
        if indexPath.section == 3 {
            print("*****1", indexPath.section)
            
            
            if  indexPath.row == 1 && wednesdayTimingsArray.count == 2 {
                
                cell.addDeleteBtn.setImage(#imageLiteral(resourceName: "deleteBtn"), for: .normal)
                // monBool  = true
                print("*****1", indexPath.row)
                
                
                
            }
            //            if indexPath.row == 0 && mondayTimingsArray.count == 1 {
            //
            //                cell.addDeleteBtn.setImage(#imageLiteral(resourceName: "addBtn"), for: .normal)
            //                //monBool = false
            //
            //                print("*****1", indexPath.row)
            //
            //
            //            }
            
            cell.onAddDeleteButtonTapped = {
                
                
                if indexPath.row == 1 {
                    
                    self.collapseSectionAction(sender: cell.addDeleteBtn)
                    
                    //self.addBool = false
                    
                    print("*****1", indexPath.row)
                    
                    
                    
                }
                
                if indexPath.row == 0 {
                    
                    print("*****", indexPath.row)
                    
                    self.expandSectionAction(sender: cell.addDeleteBtn)
                    
                    print("*****1", indexPath.row)
                    
                    
                }
                
                
            }
            
            
        }
        
        if indexPath.section == 4 {
            print("*****1", indexPath.section)
            
            
            if  indexPath.row == 1 && thursdayTimingsArray.count == 2 {
                
                cell.addDeleteBtn.setImage(#imageLiteral(resourceName: "deleteBtn"), for: .normal)
                // monBool  = true
                print("*****1", indexPath.row)
                
                
                
            }
            //            if indexPath.row == 0 && mondayTimingsArray.count == 1 {
            //
            //                cell.addDeleteBtn.setImage(#imageLiteral(resourceName: "addBtn"), for: .normal)
            //                //monBool = false
            //
            //                print("*****1", indexPath.row)
            //
            //
            //            }
            
            cell.onAddDeleteButtonTapped = {
                
                
                if indexPath.row == 1 {
                    
                    self.collapseSectionAction(sender: cell.addDeleteBtn)
                    
                    //self.addBool = false
                    
                    print("*****1", indexPath.row)
                    
                    
                    
                }
                
                if indexPath.row == 0 {
                    
                    print("*****", indexPath.row)
                    
                    self.expandSectionAction(sender: cell.addDeleteBtn)
                    
                    print("*****1", indexPath.row)
                    
                    
                }
                
                
            }
            
            
        }
        
        
        if indexPath.section == 5 {
            print("*****1", indexPath.section)
            
            
            if  indexPath.row == 1 && fridayTimingsArray.count == 2 {
                
                cell.addDeleteBtn.setImage(#imageLiteral(resourceName: "deleteBtn"), for: .normal)
                // monBool  = true
                print("*****1", indexPath.row)
                
                
                
            }
            //            if indexPath.row == 0 && mondayTimingsArray.count == 1 {
            //
            //                cell.addDeleteBtn.setImage(#imageLiteral(resourceName: "addBtn"), for: .normal)
            //                //monBool = false
            //
            //                print("*****1", indexPath.row)
            //
            //
            //            }
            
            cell.onAddDeleteButtonTapped = {
                
                
                if indexPath.row == 1 {
                    
                    self.collapseSectionAction(sender: cell.addDeleteBtn)
                    
                    //self.addBool = false
                    
                    print("*****1", indexPath.row)
                    
                    
                    
                }
                
                if indexPath.row == 0 {
                    
                    print("*****", indexPath.row)
                    
                    self.expandSectionAction(sender: cell.addDeleteBtn)
                    
                    print("*****1", indexPath.row)
                    
                    
                }
                
                
            }
            
            
        }
        
        if indexPath.section == 6 {
            print("*****1", indexPath.section)
            
            
            if  indexPath.row == 1 && saturdayTimingsArray.count == 2 {
                
                cell.addDeleteBtn.setImage(#imageLiteral(resourceName: "deleteBtn"), for: .normal)
                // monBool  = true
                print("*****1", indexPath.row)
                
                
                
            }
            //            if indexPath.row == 0 && mondayTimingsArray.count == 1 {
            //
            //                cell.addDeleteBtn.setImage(#imageLiteral(resourceName: "addBtn"), for: .normal)
            //                //monBool = false
            //
            //                print("*****1", indexPath.row)
            //
            //
            //            }
            
            cell.onAddDeleteButtonTapped = {
                
                
                if indexPath.row == 1 {
                    
                    self.collapseSectionAction(sender: cell.addDeleteBtn)
                    
                    //self.addBool = false
                    
                    print("*****1", indexPath.row)
                    
                    
                    
                }
                
                if indexPath.row == 0 {
                    
                    print("*****", indexPath.row)
                    
                    self.expandSectionAction(sender: cell.addDeleteBtn)
                    
                    print("*****1", indexPath.row)
                    
                    
                }
                
                
            }
            
            
        }

    
        
        
        //        switch indexPath.section {
        //
        //        case 0:
        //
        //            if indexPath.row == 1 && sundayTimingsArray.count == 2{
        //
        //                cell.addDeleteBtn.setImage(#imageLiteral(resourceName: "deleteBtn"), for: .normal)
        //                addBool  = true
        //
        //           }
        //                else {
        //
        //                addBool  = false
        //
        //            }
        //
        //        case 1:
        //
        //            if indexPath.row == 1 && mondayTimingsArray.count == 2{
        //
        //                cell.addDeleteBtn.setImage(#imageLiteral(resourceName: "deleteBtn"), for: .normal)
        //                monBool  = true
        //
        //           }
        //            else {
        //
        //                monBool  = false
        //
        //            }
        //
        //        case 2:
        //
        //            if indexPath.row == 1 && tuesdayTimingsArray.count == 2{
        //
        //                cell.addDeleteBtn.setImage(#imageLiteral(resourceName: "deleteBtn"), for: .normal)
        //                tuesBool  = true
        //
        //          }
        //                else {
        //
        //                tuesBool  = false
        //
        //            }
        //
        //        case 3:
        //
        //            if indexPath.row == 1 && wednesdayTimingsArray.count == 2{
        //
        //                cell.addDeleteBtn.setImage(#imageLiteral(resourceName: "deleteBtn"), for: .normal)
        //                wedBool  = true
        //
        //         }
        //                else {
        //
        //                wedBool  = false
        //
        //            }
        //
        //        case 4:
        //
        //            if indexPath.row == 1 && thursdayTimingsArray.count == 2{
        //
        //                cell.addDeleteBtn.setImage(#imageLiteral(resourceName: "deleteBtn"), for: .normal)
        //                thurBool  = true
        //
        //           }
        //                else {
        //
        //                thurBool  = false
        //
        //            }
        //
        //        case 5:
        //
        //            if indexPath.row == 1 && fridayTimingsArray.count == 2{
        //
        //                cell.addDeleteBtn.setImage(#imageLiteral(resourceName: "deleteBtn"), for: .normal)
        //                friBool  = true
        //
        //  }
        //               else {
        //
        //                friBool  = false
        //
        //            }
        //
        //        case 6:
        //
        //            if indexPath.row == 1 && saturdayTimingsArray.count == 2{
        //
        //                cell.addDeleteBtn.setImage(#imageLiteral(resourceName: "deleteBtn"), for: .normal)
        //                satBool  = true
        //
        //     }
        //                else {
        //
        //                satBool  = false
        //
        //            }
        //
        //        default:
        //            break
        //        }
        
        
        //        cell.onAddDeleteButtonTapped = {
        //
        //            print("")
        //
        //            switch indexPath.section {
        //
        //            case 0:
        //
        //                if self.addBool {
        //
        //                    self.collapseSectionAction(sender: cell.addDeleteBtn)
        //
        //                    //self.addBool = false
        //
        //
        //                } else {
        //
        //                    print("*****", indexPath.row)
        //
        //                    self.expandSectionAction(sender: cell.addDeleteBtn)
        //
        //                }
        //
        //            case 1:
        //
        //                if self.monBool {
        //
        //                    self.collapseSectionAction(sender: cell.addDeleteBtn)
        //
        //                    //self.addBool = false
        //
        //
        //                } else {
        //
        //                    print("*****", indexPath.row)
        //
        //                    self.expandSectionAction(sender: cell.addDeleteBtn)
        //
        //                }
        //
        //            case 2:
        //
        //                if self.tuesBool {
        //
        //                    self.collapseSectionAction(sender: cell.addDeleteBtn)
        //
        //                    //self.addBool = false
        //
        //
        //                } else {
        //
        //                    print("*****", indexPath.row)
        //
        //                    self.expandSectionAction(sender: cell.addDeleteBtn)
        //
        //                }
        //
        //            case 3:
        //
        //                if self.wedBool {
        //
        //                    self.collapseSectionAction(sender: cell.addDeleteBtn)
        //
        //                    //self.addBool = false
        //
        //
        //                } else {
        //
        //                    print("*****", indexPath.row)
        //
        //                    self.expandSectionAction(sender: cell.addDeleteBtn)
        //
        //                }
        //
        //            case 4:
        //
        //                if self.thurBool {
        //
        //                    self.collapseSectionAction(sender: cell.addDeleteBtn)
        //
        //                    //self.addBool = false
        //
        //
        //                } else {
        //
        //                    print("*****", indexPath.row)
        //
        //                    self.expandSectionAction(sender: cell.addDeleteBtn)
        //
        //                }
        //
        //            case 5:
        //
        //                if self.friBool {
        //
        //                    self.collapseSectionAction(sender: cell.addDeleteBtn)
        //
        //                    //self.addBool = false
        //
        //
        //                } else {
        //
        //                    print("*****", indexPath.row)
        //
        //                    self.expandSectionAction(sender: cell.addDeleteBtn)
        //
        //                }
        //
        //            case 6:
        //
        //                if self.satBool {
        //
        //                    self.collapseSectionAction(sender: cell.addDeleteBtn)
        //
        //                    //self.addBool = false
        //
        //
        //                } else {
        //
        //                    print("*****", indexPath.row)
        //
        //                    self.expandSectionAction(sender: cell.addDeleteBtn)
        //
        //                }
        //
        //
        //
        //            default:
        //                break
        //            }
        //
        //
        //        }
        
        return cell
        
    }
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell,forRowAt indexPath: IndexPath) {
//
//           let cell = receiveJobsTableView.cellForRow(at: indexPath) as? ReceiveJobsTableViewCell
//
//        //        cell.timeRangeTextField.tag = indexPath.row
//        //        cell.timeRangeTextField.accessibilityLabel = "\(indexPath.section)"
//
//        cell!.timeRangeTextField.accessibilityLabel = "\(indexPath.row)"
//                cell!.addDeleteBtn.accessibilityLabel = "\(indexPath.row)"
//                cell!.timeRangeTextField.inputView = pickerInputView
//                cell!.timeRangeTextField.inputAccessoryView = nil
//                doneToolBarBtn.accessibilityLabel = cell!.timeRangeTextField.accessibilityLabel
//                doneToolBarBtn.tag = cell!.timeRangeTextField.tag
//
//    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        
        return 35
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 25
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        //        if section == 0 {
        
        let obj = sectionArray[section]
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 30))
        
        
        
        //        let size1 =  CGSize(width:(sectionArray[section] as NSString).size(withAttributes: [NSAttributedString.Key.font: UIFont(name:"Helvetica Neue Medium", size: 19)!]).width + 10, height: 41)
        
        let size = CGSize(width: 90, height: 30)
        
        print(size)
        let label = UILabel(frame: CGRect(x: 39, y: 11, width: size.width , height: 30))
        label.font = UIFont(name:"Helvetica Neue Bold", size: 19)
        // label.numberOfLines = 2
        label.text = obj
        
        switchBtn = UISwitch(frame: CGRect(x: label.frame.origin.x + size.width + 170, y: 11, width: 51, height: 31))
        switchBtn.addTarget(self, action: #selector(switchBtnAction), for: .valueChanged)
        switchBtn.tag = section
        
        
        
        let expandLbl = UIButton(frame: CGRect(x:  switchBtn.frame.origin.x  , y:  switchBtn.frame.origin.x + switchBtn.frame.size.height + 8 , width:47, height: 24))
        expandLbl.contentMode = .scaleAspectFit
        expandLbl.tintColor = .black
        //if statusArray[section] {
        //expandLbl.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        expandLbl.setImage(#imageLiteral(resourceName: "addBtn"), for: .normal)
        expandLbl.addTarget(self, action:#selector(expandSectionAction), for: .touchUpInside)
        
        expandLbl.tag = section
        
        // }
        //        else {
        //          expandLbl.image  = #imageLiteral(resourceName: "expand")
        //        }
        
        let deleteImg = UIButton(frame: CGRect(x: headerView.frame.origin.x + headerView.frame.size.width - 40 , y: 8, width:20, height: 24)) //UIButton(frame: CGRect(x: switchBtn.frame.origin.x + switchBtn.frame.size.width  , y: switchBtn.frame.origin.y + 5 + switchBtn.frame.size.height, width:20, height: 24))
        
        deleteImg.contentMode = .scaleAspectFit
        deleteImg.tintColor = .black
        deleteImg.setImage(#imageLiteral(resourceName: "deleteBtn"), for: .normal)
        deleteImg.addTarget(self, action:#selector(collapseSectionAction), for: .touchUpInside)
        deleteImg.tag = section
        
        headerView.addSubview(label)
        headerView.addSubview(switchBtn)
        // headerView.addSubview(expandLbl)
        // headerView.addSubview(deleteImg)
        
        
        
        
        
        //headerView.addSubview(deleteImg)
        //        switch section {
        //
        //        case 0:
        //           if sundayTimingsArray.count > 1 {
        //                deleteImg.isHidden = false
        //
        //
        //           } else if sundayTimingsArray.count == 1 {
        //                deleteImg.isHidden = true
        //            }
        //
        //        case 1:
        //           if mondayTimingsArray.count > 1 {
        //                deleteImg.isHidden = false
        //            } else if mondayTimingsArray.count == 1 {
        //                deleteImg.isHidden = true
        //            }
        //
        //        case 2:
        //            if tuesdayTimingsArray.count > 1 {
        //                deleteImg.isHidden = false
        //            } else if tuesdayTimingsArray.count == 1 {
        //                deleteImg.isHidden = true
        //            }
        //
        //        case 3:
        //            if wednesdayTimingsArray.count > 1 {
        //                deleteImg.isHidden = false
        //            } else if wednesdayTimingsArray.count == 1 {
        //                deleteImg.isHidden = true
        //            }
        //
        //        case 4:
        //            if thursdayTimingsArray.count > 1 {
        //                deleteImg.isHidden = false
        //            } else if thursdayTimingsArray.count == 1 {
        //                deleteImg.isHidden = true
        //            }
        //
        //        case 5:
        //            if fridayTimingsArray.count > 1 {
        //                deleteImg.isHidden = false
        //            } else if fridayTimingsArray.count == 1 {
        //                deleteImg.isHidden = true
        //            }
        //
        //        case 6:
        //            if  saturdayTimingsArray.count > 1 {
        //                deleteImg.isHidden = false
        //            } else if saturdayTimingsArray.count == 1 {
        //                deleteImg.isHidden = true
        //            }
        //
        //        default:
        //            break
        //        }
        
        
        
        
        
        
        headerView.tag = section
        headerView.isUserInteractionEnabled = true
        
        //   let tapgesture = UITapGestureRecognizer(target: self , action: #selector(self.sectionTapped(_:)))
        //  headerView.addGestureRecognizer(tapgesture)
        return headerView
        //        }
        //        else {
        //            return UIView()
        //        }
        
        
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 20))
        
        return headerView
        
    }
    
    func tableViewExpandSection(_ section: Int, imageView: UIImageView) {
        let sectionData = self.sectionArray
        if (sectionData.count == 0) {
            self.expandedSectionHeaderNumber = -1;
            
            return;
        } else {
            UIView.animate(withDuration: 0.4, animations: {
                imageView.transform = CGAffineTransform(rotationAngle: (180.0 * CGFloat(Double.pi)) / 180.0)
            })
            var indexesPath = [IndexPath]()
            for i in 0 ..< sectionData.count {
                let index = IndexPath(row: i, section: section)
                indexesPath.append(index)
            }
            self.expandedSectionHeaderNumber = section
            self.receiveJobsTableView!.beginUpdates()
            self.receiveJobsTableView!.insertRows(at: indexesPath, with: UITableView.RowAnimation.fade)
            self.receiveJobsTableView!.endUpdates()
        }
    }
    
    func tableViewCollapeSection(_ section: Int, imageView: UIImageView) {
        let sectionData = self.sectionArray[section]
        
        self.expandedSectionHeaderNumber = -1;
        if (sectionData.count == 0) {
            return;
        } else {
            UIView.animate(withDuration: 0.4, animations: {
                imageView.transform = CGAffineTransform(rotationAngle: (0.0 * CGFloat(Double.pi)) / 180.0)
            })
            var indexesPath = [IndexPath]()
            for i in 0 ..< sectionData.count {
                let index = IndexPath(row: i, section: section)
                indexesPath.append(index)
            }
            self.receiveJobsTableView!.beginUpdates()
            self.receiveJobsTableView!.deleteRows(at: indexesPath, with: UITableView.RowAnimation.fade)
            self.receiveJobsTableView!.endUpdates()
        }
    }
    
    @objc func sectionTapped(_ sender: UITapGestureRecognizer)
    {
        let headerView = sender.view
        let section  = headerView?.tag
        
    }
    
    @objc func expandSectionAction(sender: UIButton!) {
  
        
        print(sender.tag)
        
        if sender.tag == 0 {
            
            //addBool = false
            if sundayTimingsArray.count < 2 {
                sundayTimingsArray.append("")
                print(sundayTimingsArray.count)
                
                //                if sundayTimingsArray.count == 2  {
                //
                //                   addBool = true
                //
                //        }
                
                
            }
        } else  if sender.tag == 1 {
            
            // addBool = false
            
            if mondayTimingsArray.count < 2 {
                mondayTimingsArray.append("")
                print(mondayTimingsArray.count)
                //                addBool = false
                //                if mondayTimingsArray.count == 2 {
                //
                //                    addBool = true
                //
                //                }
                
            }
        } else if sender.tag == 2 {
            
            // = false
            if tuesdayTimingsArray.count < 2 {
                tuesdayTimingsArray.append("")
                print(tuesdayTimingsArray.count)
                
                //                if tuesdayTimingsArray.count == 2 {
                //
                //                                   addBool = true
                //
                //                               }
                
            }
        } else if sender.tag == 3 {
            
            // jobsArray.count += 1
            // addBool = false
            if wednesdayTimingsArray.count < 2 {
                wednesdayTimingsArray.append("")
                print(wednesdayTimingsArray.count)
                
                //                if wednesdayTimingsArray.count == 2 {
                //
                //                                   addBool = true
                //
                //                               }
                
            }
        } else if sender.tag == 4 {
            
            //addBool = false
            if thursdayTimingsArray.count < 2 {
                thursdayTimingsArray.append("")
                print(thursdayTimingsArray.count)
                
                //                if thursdayTimingsArray.count == 2 {
                //
                //                                   addBool = true
                //
                //                               }
                
            }
        } else if sender.tag == 5 {
            
            //addBool = false
            if fridayTimingsArray.count < 2 {
                fridayTimingsArray.append("")
                print(fridayTimingsArray.count)
                
                //                if fridayTimingsArray.count == 2 {
                //
                //                                   addBool = true
                //
                //                               }
                
            }
        } else if sender.tag == 6 {
            
            //addBool = false
            if saturdayTimingsArray.count < 2 {
                saturdayTimingsArray.append("")
                print(saturdayTimingsArray.count)
                
                //                if saturdayTimingsArray.count == 2 {
                //
                //                                   addBool = true
                //
                //                               }
                //
            }
            
        }

        
        receiveJobsTableView.reloadData()
        
        
        
    }
    
    @objc func collapseSectionAction(sender: UIButton!) {
        
        
        if sender.tag == 0 {
            
            if sender.accessibilityLabel == "1" {
                
                sundayTimingsArray.removeLast()
                print(sundayTimingsArray.count)
                if let index = self.availTimeArray.firstIndex(where: { $0.identify == 2 }) {
                self.availTimeArray.remove(at: index)
                }

            }
            
            
        } else if sender.tag == 1 {
            
            if sender.accessibilityLabel == "1" {
                
                mondayTimingsArray.removeLast()
                print(mondayTimingsArray.count)
                let index = self.availTimeArray.firstIndex(where: { $0.identify == 4 })
                self.availTimeArray.remove(at: index!)

                
            }
            
        } else if sender.tag == 2 {
            
            
            if sender.accessibilityLabel == "1" {
                
                tuesdayTimingsArray.removeLast()
                print(tuesdayTimingsArray.count)
                let index = self.availTimeArray.firstIndex(where: { $0.identify == 6 })
                self.availTimeArray.remove(at: index!)

                
            }
            
        } else if sender.tag == 3 {
            
            if sender.accessibilityLabel == "1" {
                
                wednesdayTimingsArray.removeLast()
                print(wednesdayTimingsArray.count)
                
                let index = self.availTimeArray.firstIndex(where: { $0.identify == 8 })
                self.availTimeArray.remove(at: index!)

                
            }
            
        } else if sender.tag == 4 {
            
            if sender.accessibilityLabel == "1" {
                
                thursdayTimingsArray.removeLast()
                print(thursdayTimingsArray.count)
                
                let index = self.availTimeArray.firstIndex(where: { $0.identify == 10 })
                self.availTimeArray.remove(at: index!)

                
            }
            
        } else if sender.tag == 5 {
            
            if sender.accessibilityLabel == "1" {
                
                fridayTimingsArray.removeLast()
                print(fridayTimingsArray.count)
                
                let index = self.availTimeArray.firstIndex(where: { $0.identify == 12 })
                self.availTimeArray.remove(at: index!)

                
            }
            
        } else if sender.tag == 6 {
            
            if sender.accessibilityLabel == "1" {
                
                saturdayTimingsArray.removeLast()
                print(saturdayTimingsArray.count)
                
                let index = self.availTimeArray.firstIndex(where: { $0.identify == 14 })
                self.availTimeArray.remove(at: index!)

                
            }
        }
        
        receiveJobsTableView.reloadData()
        
        
    }
    
    @objc func switchBtnAction(sender: UISwitch!) {
        
        if (sender.isOn == true)
        {
            print("isOn")
            
            if sender.tag == 0 {
                      
                      //addBool = false
                      if sundayTimingsArray.count < 1 {
                          sundayTimingsArray.append("")
                          print(sundayTimingsArray.count)
                          
                          //                if sundayTimingsArray.count == 2  {
                          //
                          //                   addBool = true
                          //
                          //        }
                          
                          
                      }
                  } else  if sender.tag == 1 {
                      
                      // addBool = false
                      
                      if mondayTimingsArray.count < 1 {
                          mondayTimingsArray.append("")
                          print(mondayTimingsArray.count)
                          //                addBool = false
                          //                if mondayTimingsArray.count == 2 {
                          //
                          //                    addBool = true
                          //
                          //                }
                          
                      }
                  } else if sender.tag == 2 {
                      
                      // = false
                      if tuesdayTimingsArray.count < 1 {
                          tuesdayTimingsArray.append("")
                          print(tuesdayTimingsArray.count)
                          
                          //                if tuesdayTimingsArray.count == 2 {
                          //
                          //                                   addBool = true
                          //
                          //                               }
                          
                      }
                  } else if sender.tag == 3 {
                      
                      // jobsArray.count += 1
                      // addBool = false
                      if wednesdayTimingsArray.count < 1 {
                          wednesdayTimingsArray.append("")
                          print(wednesdayTimingsArray.count)
                          
                          //                if wednesdayTimingsArray.count == 2 {
                          //
                          //                                   addBool = true
                          //
                          //                               }
                          
                      }
                  } else if sender.tag == 4 {
                      
                      //addBool = false
                      if thursdayTimingsArray.count < 1 {
                          thursdayTimingsArray.append("")
                          print(thursdayTimingsArray.count)
                          
                          //                if thursdayTimingsArray.count == 2 {
                          //
                          //                                   addBool = true
                          //
                          //                               }
                          
                      }
                  } else if sender.tag == 5 {
                      
                      //addBool = false
                      if fridayTimingsArray.count < 1 {
                          fridayTimingsArray.append("")
                          print(fridayTimingsArray.count)
                          
                          //                if fridayTimingsArray.count == 2 {
                          //
                          //                                   addBool = true
                          //
                          //                               }
                          
                      }
                  } else if sender.tag == 6 {
                      
                      //addBool = false
                      if saturdayTimingsArray.count < 1 {
                          saturdayTimingsArray.append("")
                          print(saturdayTimingsArray.count)
                          
                          //                if saturdayTimingsArray.count == 2 {
                          //
                          //                                   addBool = true
                          //
                          //                               }
                          //
                      }
                      
                  }

                  
                  receiveJobsTableView.reloadData()
                  
            
            
        } else if (sender.isOn == false) {
            
            print("isOff")
            
            if sender.tag == 0 {
                      
                
                sundayTimingsArray.removeAll()
                    
                  } else  if sender.tag == 1 {
                      
                      mondayTimingsArray.removeAll()

                  
                  } else if sender.tag == 2 {
                      
                      tuesdayTimingsArray.removeAll()
                    
                  } else if sender.tag == 3 {
                      
                      wednesdayTimingsArray.removeAll()
                   
                  } else if sender.tag == 4 {
                      
                      thursdayTimingsArray.removeAll()
                   
                     
                  } else if sender.tag == 5 {
                      
                      fridayTimingsArray.removeAll()
            
                     
                  } else if sender.tag == 6 {
                      
                      saturdayTimingsArray.removeAll()
                    
                      
                  }

                  
                  receiveJobsTableView.reloadData()
                  

            
            
        }
        print(sender.tag)
        
       
        
        
        
        
    }
    
    
    // MARK: - Api Methods
    
    
    func getScheduleApi()
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
                
                Alamofire.request(Base_Url+getScheduleUrl , method: .post,  parameters: nil, encoding: URLEncoding.default, headers:headers)
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
                                
//                                let objc = ProjectManager.sharedInstance.GetLoginDataObjects(dict: data)
                                 
                                
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
    
    func saveScheduleApi(result : [Any])
        {
            if ProjectManager.sharedInstance.isInternetAvailable()
            {
                if let apiToken = UserDefaults.standard.value(forKey: DefaultsIdentifier.apiToken) as? String {
                    
                    // if apiToken != nil {
                    
                    
                    
                    
                    DispatchQueue.main.async {
                         ProjectManager.sharedInstance.showLoader(vc: self)
                    }
                    
                    
                    let params = ["avail_time":result, "user_ip":"193.189.20.201"] as [String: Any]
                    
                    print(params)
                    
                    let headers = [
                        "Authorization": "Bearer " + apiToken]
                    
                    //"Accept": "application/json"
                    print(headers)
                    
                    Alamofire.request(Base_Url+saveScheduleUrl , method: .post,  parameters: params, encoding: URLEncoding.default, headers:headers)
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
                                    
    //                                let objc = ProjectManager.sharedInstance.GetLoginDataObjects(dict: data)
                                     
                                    
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

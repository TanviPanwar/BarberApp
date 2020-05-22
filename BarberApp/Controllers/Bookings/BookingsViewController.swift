//
//  BookingsViewController.swift
//  BarberApp
//
//  Created by iOS6 on 17/03/20.
//  Copyright © 2020 iOS8. All rights reserved.
//

import UIKit

class BookingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var bookingTableView: UITableView!
    @IBOutlet weak var appointmentView: UIView!
    @IBOutlet weak var reviewView: UIView!
    @IBOutlet weak var complainView: UIView!
    
    @IBOutlet weak var experienceView: RoundedButton!
    @IBOutlet weak var experienceComplaintView: RoundedButton!
    
    var availableTimeSlots = ["01 AM", "02 AM", "03 AM" ,"10 AM" ,"11 AM", "12 PM" , "03 PM" , "04 PM", "07 PM",]
    var sliderImages = [UIImage(named:"barberSample"), UIImage(named:"barberSample"), UIImage(named:"barberSample")]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        appointmentView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        reviewView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        complainView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        experienceView.setBorder(width: 1, color: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1))
        experienceComplaintView.setBorder(width: 1, color: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1))
        
    }
    
    // MARK: - IB Actions
    
    @IBAction func continueAction(_ sender: Any) {
        self.appointmentView.isHidden = true
//        let alertController =  UIAlertController(title:"Home Service" , message: "This barber offers home services for the selected services you picked. Would you like to receive your service at home or at the Salon?", preferredStyle: .alert)
//        let homeAction = UIAlertAction(title:"Home Service", style: .default) { (action) in
//            let vc = homeStoryBoard.instantiateViewController(identifier:"CustomerAddressViewController") as! CustomerAddressViewController
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
//        let saloonAction = UIAlertAction(title:"Salon Service", style: .default) { (action) in
//               }
//        alertController.addAction(homeAction)
//        alertController.addAction(saloonAction)
//        self.present(alertController, animated: true, completion:nil)
        
    }
    
    
    @IBAction func submitReviewBtnAction(_ sender: Any) {
        
        reviewView.isHidden = true
    }
    
    @IBAction func submitComplainBtnAction(_ sender: Any) {
        
        complainView.isHidden = true
    }
    
    // MARK: - Custom Methods
    
    func getTimeSlots()  -> [TimeObj] {
        
        var array: [TimeObj] = []
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy hh:mm a"
        let formatter2 = DateFormatter()
        formatter2.dateFormat = "hh a"
        let startDate = "20-08-2018 00:00 AM"
        let endDate = "21-08-2018 00:00 AM"
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

    
    // MARK: - TableView Delegates
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
        
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        if section == 0 {
        
       let view = UIView(frame: CGRect(x: 0, y: 0, width: bookingTableView.bounds.size.width, height: 50))
            
       let headerView = UIView(frame: CGRect(x: 25, y: 0, width: tableView.bounds.size.width - 32, height: 40))
       
        headerView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        let label = UILabel(frame: CGRect(x: 0, y: 20, width: headerView.frame.size.width - 100, height: 30))
        label.numberOfLines = 1
        label.font =  UIFont(name: "Avenir Medium ", size: 24)
        label.textColor = #colorLiteral(red: 0, green: 0.003993117716, blue: 0, alpha: 1)
        label.text = "Upcoming"
       
        headerView.addSubview(label)
        view.addSubview(headerView)

        return view
            
        } else if section == 1 {
            
           let view = UIView(frame: CGRect(x: 0, y: 0, width: bookingTableView.bounds.size.width, height: 50))
                 
            let headerView = UIView(frame: CGRect(x: 25, y: 0, width: tableView.bounds.size.width - 32, height: 40))
            
             headerView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
             let label = UILabel(frame: CGRect(x: 0, y: 20, width: headerView.frame.size.width - 100, height: 30))
             label.numberOfLines = 1
             label.font =  UIFont(name: "Avenir Medium ", size: 24)
             label.textColor = #colorLiteral(red: 0.1765596569, green: 0.1765596569, blue: 0.1765596569, alpha: 1)
             label.text = "History"
            
             headerView.addSubview(label)
             view.addSubview(headerView)
            
            return view
            
            
        }  else {
            
             let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
            
             headerView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            
            return headerView
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
       
       return 50
        
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        if section == 0 {
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: bookingTableView.bounds.size.width, height: 40))
             
        let headerView = UIView(frame: CGRect(x: 20, y: 0, width: tableView.bounds.size.width, height: 40))
        
         headerView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
         let viewLine = UIView(frame: CGRect(x: 0, y: 30, width: headerView.frame.size.width - 40, height: 2))
         viewLine.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)

         headerView.addSubview(viewLine)
         view.addSubview(headerView)
        
        return view
            
        } else {
            
            let footerView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
            
            footerView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            
            return footerView
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        
        if section == 0 {
            
         return 40
            
        } else {
            
            return 0
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            
            return 2
            
        } else {
            
            return 5
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        UITableView.automaticDimension;
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier:"bookingCell", for: indexPath) as? BookingsTableViewCell else {return UITableViewCell()}
        
        
        if indexPath.section == 0 {
            
            cell.confirmedStatusStackView.isHidden = false
            cell.cancelStatusStackView.isHidden = true
            
            
            cell.onDirectionButtonTapped = {
                
                print("Direction")
            }
            
            cell.onPayButtonTapped = {
                
                print("Pay")

                
            }
            
            cell.onDelayButtonTapped = {
                
                self.appointmentView.isHidden = false
                
            }
            
            cell.onCancelButtonTapped = {
                
                let alertController =  UIAlertController(title:"Cancel Appointment" , message: "Cancelling an appointment 2 hours before it’s due time will result in a 10 QAR deduction as surecharge", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title:"Cancel Booking", style: .default) { (action) in
                    //                let vc = homeStoryBoard.instantiateViewController(identifier:"CustomerAddressViewController") as! CustomerAddressViewController
                    //                self.navigationController?.pushViewController(vc, animated: true)
                }
                let dontCancelAction = UIAlertAction(title:"Don't Cancel", style: .default) { (action) in
                    
                }
                
                alertController.addAction(cancelAction)
                alertController.addAction(dontCancelAction)
                self.present(alertController, animated: true, completion:nil)
                
                
            }
            
            
        } else if indexPath.section == 1 {
            
            
            cell.cancelStatusStackView.isHidden = false
            cell.confirmedStatusStackView.isHidden = true
            
            cell.onReviewedButtonTapped = {
                
                self.reviewView.isHidden = false
            }
            
            cell.onComplainButtonTapped = {
                
                self.complainView.isHidden = false
                
            }
            
            cell.onBookAgainButtonTapped = {
                
                print("BookAgain")
                
            }
            
        }
        
        
        
        
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
 
//       appointmentView.isHidden = false
        
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

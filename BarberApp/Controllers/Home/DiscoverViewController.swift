//
//  DiscoverViewController.swift
//  BarberApp
//
//  Created by iOS8 on 09/03/20.
//  Copyright © 2020 iOS8. All rights reserved.
//

import UIKit

class DiscoverViewController: UIViewController {
    @IBOutlet weak var listBtn: UIButton!
    @IBOutlet weak var mapBtn: UIButton!
    
    @IBOutlet weak var serviceCollectionViw: UICollectionView!
    var servicesArray = ["All*" ,"Haircut", "Beard", "VIP Treatment",
                         "Home Service", "Credit Card" , "Cash"]
    var availableTimeSlots = ["01 AM", "02 AM", "03 AM" ,"10 AM" ,"11 AM", "12 PM" , "03 PM" , "04 PM", "07 PM",]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listBtn.roundCorners(corners: [.topLeft, .bottomLeft], radius: 17.5)
        mapBtn.roundCorners(corners: [.topRight, .bottomRight], radius: 17.5)

        // Do any additional setup after loading the view.
    }
    @IBAction func mapBtnClick(_ sender: Any) {
        self.mapBtn.backgroundColor = #colorLiteral(red: 0.05763856322, green: 0.2982799113, blue: 0.5071055889, alpha: 1)
        self.mapBtn.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        self.listBtn.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.listBtn.setTitleColor(#colorLiteral(red: 0.05763856322, green: 0.2982799113, blue: 0.5071055889, alpha: 1), for: .normal)
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
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
            let size = servicesArray[indexPath.item].size(withAttributes: [NSAttributedString.Key.font: UIFont(name: "Avenir-Medium", size: 16.0)! ])
            
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
            return getTimeSlots().count
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView ==  serviceCollectionViw {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"ServiceCell", for: indexPath) as? ServiceCell else {return UICollectionViewCell()}
            cell.serviceNameLbl.text = servicesArray[indexPath.item]
            return cell
        } else {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TimeSlotCell", for: indexPath) as! TimeSlotCell
            let obj = getTimeSlots()[indexPath.item]
            if availableTimeSlots.contains(obj.time) {
                cell.slotViw.backgroundColor = #colorLiteral(red: 0.2909106016, green: 0.4674310684, blue: 0.6362583041, alpha: 1)
            } else {
                cell.slotViw.backgroundColor = #colorLiteral(red: 0.8134699464, green: 0.8940644264, blue: 0.9693123698, alpha: 1)
            }
            cell.timeLbl.text =  obj.time
            
            
            return cell
        }
        
    }
    
    
    
}

extension DiscoverViewController:UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier:"DiscoverTableViewCell", for: indexPath) as? DiscoverTableViewCell else {return UITableViewCell()}
        return cell
        
        
        
    }
    
    
}
class TimeObj: NSObject {
    var time:String = ""
    var isSelected:Bool = false
}

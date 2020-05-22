//
//  BarberDetailViewController.swift
//  BarberApp
//
//  Created by iOS8 on 17/03/20.
//  Copyright © 2020 iOS8. All rights reserved.
//

import UIKit
import GoogleMaps

class BarberDetailViewController: UIViewController , GMSMapViewDelegate {
    @IBOutlet weak var tableViw: UITableView!
    
    @IBOutlet var scheduleAppintmentViw: UIView!
    
    var availableTimeSlots = ["01 AM", "02 AM", "03 AM" ,"10 AM" ,"11 AM", "12 PM" , "03 PM" , "04 PM", "07 PM",]
    var sliderImages = [UIImage(named:"barberSample"), UIImage(named:"barberSample"), UIImage(named:"barberSample")]
    override func viewDidLoad() {
        super.viewDidLoad()
     
        self.scheduleAppintmentViw.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        // Do any additional setup after loading the view.
    }
    
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
        if section == 4 || section == 2 {
            return 8
        } else {
            return 1
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 8
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier:"TopSliderTableViewCell", for: indexPath) as? TopSliderTableViewCell else {return UITableViewCell()}
            cell.slideImgArray = sliderImages as! [UIImage]
            cell.setUpViewInScrollView()
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier:"MiddleInstagramCell", for: indexPath) as? MiddleInstagramCell else {return UITableViewCell()}
            let width = (UIScreen.main.bounds.size.width - 70)/3
            cell.instaCollectionViw.tag = indexPath.section
            cell.collectionHeightConstraint.constant = (width * 2) + 10
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier:"AvailablityCell", for: indexPath) as? AvailablityCell else {return UITableViewCell()}
         
            return cell
        case 3:
            guard let cell = tableView.dequeueReusableCell(withIdentifier:"TimeScheduleCell", for: indexPath) as? TimeScheduleCell else {return UITableViewCell()}
            cell.slotsCollectionViw.tag = indexPath.section
            
            return cell
        case 4:
            guard let cell = tableView.dequeueReusableCell(withIdentifier:"ServiceDetailCell", for: indexPath) as? ServiceDetailCell else {return UITableViewCell()}
            return cell
        case 5:
          guard let cell = tableView.dequeueReusableCell(withIdentifier:"MapCell", for: indexPath) as? MapCell else {return UITableViewCell()}
          let camera = GMSCameraPosition.camera(withLatitude: 28.7041, longitude: 77.1025, zoom: 1.0)
          cell.mainViw?.delegate = self
           // Creates a marker in the center of the map.
           let marker = GMSMarker()
           let markerImage = #imageLiteral(resourceName: "selectedMarker")
           let markerView = UIImageView(image: markerImage)
           marker.iconView = markerView
           marker.position = CLLocationCoordinate2D(latitude: 28.7041, longitude: 77.1025)
           marker.title = "Delhi"
           marker.snippet = "India’s capital"
           marker.map = cell.mainViw
           cell.mainViw.camera = camera

            return cell
        case 6:
            guard let cell = tableView.dequeueReusableCell(withIdentifier:"RatingTableViewCell", for: indexPath) as? RatingTableViewCell else {return UITableViewCell()}
            cell.ratingViw.roundCorners(corners: [.topRight, .bottomLeft], radius: 8)
            return cell
        case 7:
            guard let cell = tableView.dequeueReusableCell(withIdentifier:"RecommendedTableViewCell", for: indexPath) as? RecommendedTableViewCell else {return UITableViewCell()}
           
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
            return 18
        } else   if collectionView.tag == 3{
            return getTimeSlots().count
        }  else {
            return 5
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 1 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"InstaCollectionCell", for: indexPath) as? InstaCollectionCell else {return UICollectionViewCell()}
            return cell
        } else if collectionView.tag == 3 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "detailTimeSlotCell", for: indexPath) as! TimeSlotCell
            let obj = getTimeSlots()[indexPath.item]
            if availableTimeSlots.contains(obj.time) {
                cell.slotViw.backgroundColor = #colorLiteral(red: 0.2909106016, green: 0.4674310684, blue: 0.6362583041, alpha: 1)
            } else {
                cell.slotViw.backgroundColor = #colorLiteral(red: 0.8134699464, green: 0.8940644264, blue: 0.9693123698, alpha: 1)
            }
            cell.timeLbl.text =  obj.time
            return cell
        } else if collectionView.tag == 5 {
              let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RatingCollectionViewCell", for: indexPath) as! RatingCollectionViewCell
              return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecommendedCollectionViewCell", for: indexPath) as! RecommendedCollectionViewCell
            cell.ratingViw.roundCorners(corners: [.topRight, .bottomLeft], radius: 10)
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

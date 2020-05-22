//
//  DriverHomeViewController.swift
//  BarberApp
//
//  Created by iOS8 on 23/03/20.
//  Copyright © 2020 iOS8. All rights reserved.
//

import UIKit

class BarberHomeViewController: UIViewController {
    @IBOutlet weak var homeTableViw: UITableView!
    var sectionTitles = ["Your progress" , "Today’s Bookings" , "Pending Bookings"]
    var todayBookingButtons = ["MARK AS DONE" , "CUSTOMER DIDN’T COME" , "REPORT DELAY" , "CANCEL"]
    var sectionStatus = [true, false , false]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
   @objc func expandSections(sender:UIButton)  {
    if  !sectionStatus[sender.tag] {
        sectionStatus[sender.tag] = true

    } else {
       sectionStatus[sender.tag] = false

    }
    homeTableViw.reloadData()
    }

}

extension BarberHomeViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if sectionStatus[section] {
            switch section {
            case 0:
                return 1
                case 1:
                return 1
                case 2:
                return 4
            default:
                return 0
            }
            
        } else {
            return 0
        }
        
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerViw = UIView(frame: CGRect(x:0, y: 0, width: UIScreen.main.bounds.size.width - 50, height: 60))
        let lbl = UILabel(frame:CGRect(x:25, y: 15, width: UIScreen.main.bounds.size.width - 50, height:30))
        lbl.font = UIFont(name:"HelveticaNeue-Bold", size: 20)
        lbl.text = sectionTitles[section]
        lbl.textColor = .black
        let dropdownImg = UIImageView(frame:CGRect(x:UIScreen.main.bounds.size.width - 50, y: 20, width: 20, height: 20))
        if sectionStatus[section] {
            dropdownImg.image = #imageLiteral(resourceName: "upperArrow")
        } else {
            dropdownImg.image = #imageLiteral(resourceName: "dropdown")
        }
        dropdownImg.tintColor = .darkGray
        headerViw.addSubview(lbl)
        headerViw.addSubview(dropdownImg)
        headerViw.backgroundColor = .white
        let linelbl = UILabel(frame:CGRect(x:25, y: 50
            , width:UIScreen.main.bounds.size.width - 50, height:1.5))
        linelbl.backgroundColor = #colorLiteral(red: 0.8481308411, green: 0.8481308411, blue: 0.8481308411, alpha: 1)
        let btn = UIButton(frame:CGRect(x:0, y: 0, width: UIScreen.main.bounds.size.width - 50, height: 60))
        btn.tag = section
        if section > 0 {
            headerViw.addSubview(linelbl)
        }
        headerViw.addSubview(btn)
        btn.addTarget(self, action: #selector(expandSections(sender:)), for: .touchUpInside)
        return headerViw
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier:"BarberHomeTableViewCell", for: indexPath) as? BarberHomeTableViewCell else {
                       return UITableViewCell()
                   }
                   
                   
                   return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier:"BarberBookingsTableViewCell", for: indexPath) as? BarberBookingsTableViewCell else {
                                 return UITableViewCell()
                             }
            cell.bookingStatusView.roundCorners(corners: [.topRight, .bottomLeft], radius: 10)
            return cell
            case 2:
                guard let cell = tableView.dequeueReusableCell(withIdentifier:"AcceptDeclineTableViewCell", for: indexPath) as? BarberBookingsTableViewCell else {
                                          return UITableViewCell()
                                      }
                cell.bookingStatusView.roundCorners(corners: [.topRight, .bottomLeft], radius: 10)

                return cell
            
        default:
            return UITableViewCell()
        }
       
    }
    
    
    
}
extension BarberHomeViewController: UICollectionViewDelegate, UICollectionViewDataSource  , UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return todayBookingButtons.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let size = todayBookingButtons[indexPath.item].size(withAttributes: [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 13.0)! ])
                          
            return CGSize(width:size.width + 5, height:50)
       
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"ButtonCollectionViewCell", for: indexPath) as? ButtonCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.buttonOutlet.setTitle(todayBookingButtons[indexPath.item], for: .normal)
        return cell
    }
    
    
    
}

//
//  BarberBookingViewController.swift
//  BarberApp
//
//  Created by iOS8 on 24/03/20.
//  Copyright © 2020 iOS8. All rights reserved.
//

import UIKit

class BarberBookingViewController: UIViewController {
    @IBOutlet weak var homeTableViw: UITableView!
    var sectionTitles = ["Upcoming" , "Pending" , "History"]
    var todayBookingButtons = ["MARK AS DONE" , "CUSTOMER DIDN’T COME" , "REPORT DELAY" , "CANCEL"]
    
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

}
extension BarberBookingViewController: UICollectionViewDelegate, UICollectionViewDataSource  , UICollectionViewDelegateFlowLayout{
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

extension BarberBookingViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
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
        let seeAllLbl = UILabel(frame:CGRect(x:UIScreen.main.bounds.size.width - 135, y: 20, width: 110, height: 20))
        seeAllLbl.text = "See All (29)"
        seeAllLbl.font = UIFont(name:"HelveticaNeue", size: 16)
        seeAllLbl.textColor = .darkGray
        seeAllLbl.textAlignment = .right
        headerViw.addSubview(lbl)
        if section > 0 {
        headerViw.addSubview(seeAllLbl)
        }
        headerViw.backgroundColor = .white
        let linelbl = UILabel(frame:CGRect(x:25, y: 50
            , width:UIScreen.main.bounds.size.width - 50, height:1.5))
        linelbl.backgroundColor = #colorLiteral(red: 0.8481308411, green: 0.8481308411, blue: 0.8481308411, alpha: 1)
        let btn = UIButton(frame:CGRect(x:0, y: 0, width: UIScreen.main.bounds.size.width - 50, height: 60))
        btn.tag = section
            headerViw.addSubview(linelbl)
        
        headerViw.addSubview(btn)
        return headerViw
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier:"UpcomingTableViewCell", for: indexPath) as? BarberBookingsTableViewCell else {
                       return UITableViewCell()
                   }
            cell.bookingStatusView.roundCorners(corners: [.topRight, .bottomLeft], radius: 10)

                   
                   return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier:"PendingTableViewCell", for: indexPath) as? BarberBookingsTableViewCell else {
                                 return UITableViewCell()
                             }
            cell.bookingStatusView.roundCorners(corners: [.topRight, .bottomLeft], radius: 10)
            return cell
            case 2:
                guard let cell = tableView.dequeueReusableCell(withIdentifier:"PendingTableViewCell", for: indexPath) as? BarberBookingsTableViewCell else {
                                          return UITableViewCell()
                                      }
                cell.bookingStatusView.roundCorners(corners: [.topRight, .bottomLeft], radius: 10)

                return cell
            
        default:
            return UITableViewCell()
        }
       
    }
    
    
    
}

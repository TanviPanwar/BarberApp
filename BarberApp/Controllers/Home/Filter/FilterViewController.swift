//
//  FilterViewController.swift
//  BarberApp
//
//  Created by iOS8 on 09/03/20.
//  Copyright © 2020 iOS8. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController {
    @IBOutlet weak var filterCollectionVow: UICollectionView!
    
    var serviceArray = ["Regular haircurt", "Beard Cut" ,"Hair Trimming", "Waxing" , "Face Mask", "Hair Colouring" ]
    var nationalityArray = ["Ukrainian", "Turkish" ,"Indian", "Pakistani" , "Bangladesh", "Egyptian" ]
    var headerTitles = ["Service Type" , "Options" , "Price", "Distance" , "Barber Nationality" , "Sort By"]
    var isMoreService = Bool()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func resetBtnClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        
    }
    @IBAction func doneBtnClicj(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func moreServiceAction()  {
        if !isMoreService {
            isMoreService = true
            serviceArray.append(contentsOf: serviceArray)
        } else {
            isMoreService = false
            let arr:[String]  = serviceArray.dropLast(serviceArray.count - 6)
            serviceArray = arr
        }
        
        filterCollectionVow.reloadData()
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


extension FilterViewController: UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
            
        case UICollectionView.elementKindSectionHeader:
            
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "FilterHeaderView", for: indexPath) as! FilterHeaderView
            
            headerView.headerTitle.text = headerTitles[indexPath.section]
            return headerView
            
        case UICollectionView.elementKindSectionFooter:
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "FilterFooterView", for: indexPath) as! FilterHeaderView
            if indexPath.section == 0 {
                footerView.dropdown.isHidden = false
                footerView.moreServiceLbl.isHidden = false
                footerView.moreServiceBtn.isHidden = false
                if isMoreService {
                    footerView.moreServiceLbl.text = "less services"
                } else {
                    footerView.moreServiceLbl.text = "more services"
                }
                footerView.moreServiceBtn.addTarget(self, action: #selector(moreServiceAction), for: .touchUpInside)
                
            } else {
                footerView.dropdown.isHidden = true
                footerView.moreServiceLbl.isHidden = true
                footerView.moreServiceBtn.isHidden = true
            }
            return footerView
            
        default:
            
            
            assert(false, "Unexpected element kind")
        }
        
         return  UICollectionReusableView()
        
        
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return headerTitles.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return serviceArray.count
        case 1:
            return 1
        case 2:
            return 1
        case 3:
            return 1
        case 4:
            return nationalityArray.count
        case 5:
            return 1
        default:
            return 0
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0 :
            let size = serviceArray[indexPath.item].size(withAttributes: [NSAttributedString.Key.font: UIFont(name: "Avenir-Medium", size: 13.0)! ])
            
            return CGSize(width:size.width + 40, height:35)
            
        case 1 :
            return CGSize(width:UIScreen.main.bounds.size.width - 40, height:112)
            
        case 2 :
            return CGSize(width:UIScreen.main.bounds.size.width - 40, height:52)
            
        case 3 :
            return CGSize(width:UIScreen.main.bounds.size.width - 40, height:52)
        case 4 :
            let size = nationalityArray[indexPath.item].size(withAttributes: [NSAttributedString.Key.font: UIFont(name: "Avenir-Medium", size: 13.0)! ])
            return CGSize(width:size.width + 40, height:35)
        case 5 :
            return CGSize(width:UIScreen.main.bounds.size.width - 40, height:112)
        default:
            return CGSize.zero
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize(width: UIScreen.main.bounds.size.width - 40, height: 65)
        } else {
            return CGSize(width: UIScreen.main.bounds.size.width - 40, height: 30)
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0 :
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"FilterCollectionViewCell", for: indexPath)  as? FilterCollectionViewCell else {
                return UICollectionViewCell()
            }
            if indexPath.item % 2 == 0 {
                cell.serviceNameLbl.textColor = .white
                cell.outerViw.backgroundColor = #colorLiteral(red: 0.1309883595, green: 0.2987812161, blue: 0.5047755837, alpha: 1)
            } else {
                cell.outerViw.backgroundColor = #colorLiteral(red: 0.8758473396, green: 0.9036368132, blue: 0.9300265908, alpha: 1)
                cell.serviceNameLbl.textColor = .black
            }
            
            cell.serviceNameLbl.text = serviceArray[indexPath.item]
            
            return cell
        case 1:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"OptionsCollectionViewCell", for: indexPath)  as? OptionsCollectionViewCell else {
                return UICollectionViewCell()
            }
            return cell
            
        case 2:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"PriceCollectionViewCell", for: indexPath)  as? PriceCollectionViewCell else {
                return UICollectionViewCell()
            }
            return cell
        case 3:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"DistanceCollectionViewCell", for: indexPath)  as? DistanceCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.rangeSlider.minLabelFont = UIFont(name:"Avenir-Medium", size: 14)!
            cell.rangeSlider.maxLabelFont = UIFont(name:"Avenir-Medium", size: 14)!
            
            return cell
        case 4 :
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"FilterCollectionViewCell", for: indexPath)  as? FilterCollectionViewCell else {
                return UICollectionViewCell()
            }
            if indexPath.item % 2 == 0 {
                cell.serviceNameLbl.textColor = .white
                cell.outerViw.backgroundColor = #colorLiteral(red: 0.1309883595, green: 0.2987812161, blue: 0.5047755837, alpha: 1)
            } else {
                cell.outerViw.backgroundColor = #colorLiteral(red: 0.8758473396, green: 0.9036368132, blue: 0.9300265908, alpha: 1)
                cell.serviceNameLbl.textColor = .black
            }
            
            cell.serviceNameLbl.text = nationalityArray[indexPath.item]
            
            return cell
            
            
        case 5:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"SortCollectionViewCell", for: indexPath)  as? SortCollectionViewCell else {
                return UICollectionViewCell()
            }
            return cell
        default:
            return UICollectionViewCell()
        }
        
    }
    
}
//D

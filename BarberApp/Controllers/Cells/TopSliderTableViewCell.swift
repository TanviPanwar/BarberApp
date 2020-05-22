//
//  TopSliderTableViewCell.swift
//  BarberApp
//
//  Created by iOS8 on 17/03/20.
//  Copyright © 2020 iOS8. All rights reserved.
//

import UIKit
import GoogleMaps
import HCSStarRatingView
import SDWebImage

class TopSliderTableViewCell: UITableViewCell , UIScrollViewDelegate{
    @IBOutlet weak var nationalityLbl: UILabel!
    
    @IBOutlet weak var shopTypeLbl: UILabel!
    @IBOutlet weak var avgRatingLbl: UILabel!
    @IBOutlet weak var numberOfCustomerLbl: UILabel!
    @IBOutlet weak var salonOpenStatusLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var barberNameLbl: UILabel!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var likeStatusBtn: UIButton!
    @IBOutlet weak var serviceTypeLbl: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var sliderViw: UIView!
    var slideImgArray = [String]()
    var scrollViw = UIScrollView()
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }
    
    func setUpViewInScrollView()  {
        self.scrollViw = UIScrollView(frame:CGRect( x:0, y: 0, width: UIScreen.main.bounds.size.width, height: sliderViw.frame.size.height))
        scrollViw.delegate = self
        var height = CGFloat()
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            let topPadding = window!.safeAreaInsets.top
            if topPadding > 20 {
                height = topPadding - 20
            }
        }
        for i in 0..<slideImgArray.count
        {
            
            let imageView :UIImageView = UIImageView(frame: CGRect(x: CGFloat(i) *  UIScreen.main.bounds.size.width , y: 0, width: UIScreen.main.bounds.size.width, height: sliderViw.frame.size.height - height))
            imageView.sd_setImage(with: URL(string: slideImgArray[i]), completed: nil)
            imageView.contentMode = .scaleToFill
            let viw = UIView(frame: CGRect(x: CGFloat(i) *  UIScreen.main.bounds.size.width , y: 0, width: UIScreen.main.bounds.size.width, height: sliderViw.frame.size.height - height))
            viw.backgroundColor = UIColor.black.withAlphaComponent(0.45)
            self.scrollViw.addSubview(imageView)
           self.scrollViw.addSubview(viw)
        }
       // scrollViw.backgroundColor = .white
        pageControl.numberOfPages = slideImgArray.count
        scrollViw.isPagingEnabled = true
        scrollViw.showsHorizontalScrollIndicator = false
        scrollViw.showsVerticalScrollIndicator = false
        scrollViw.contentSize = CGSize(width:  UIScreen.main.bounds.size.width * CGFloat(slideImgArray.count), height: sliderViw.frame.size.height - height)
        sliderViw.addSubview(scrollViw)
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}


class MiddleInstagramCell: UITableViewCell {
    
    @IBOutlet weak var instaPhotoTitleLbl: UILabel!
    @IBOutlet weak var aboutDescriptionLbl: UILabel!
    @IBOutlet weak var aboutTitleLbl: UILabel!
    @IBOutlet weak var instaCollectionViw: UICollectionView!
    @IBOutlet weak var collectionHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var pageControl: UIPageControl!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
class InstaCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: RoundedImageView!
    
}
class TimeScheduleCell: UITableViewCell {
    
    @IBOutlet weak var slotsCollectionViw: UICollectionView!
    
    
    @IBOutlet weak var totalPriceLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
class AvailablityCell: UITableViewCell {
    
    @IBOutlet weak var availableTimeLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
class ServiceDetailCell: UITableViewCell {
    
    @IBOutlet weak var serviceSwitchBtn: UISwitch!
    @IBOutlet weak var servicePriceLbl: UILabel!
    @IBOutlet weak var serviceNameLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

class MapCell: UITableViewCell {
    
    @IBOutlet weak var mainViw: GMSMapView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
class RatingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var ratingCollectionView: UICollectionView!
    @IBOutlet weak var avgRatingLbl: UILabel!
    @IBOutlet weak var ratingViw: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
class RatingCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var commentLbl: UILabel!
    @IBOutlet weak var ratingView: HCSStarRatingView!
    @IBOutlet weak var userNameLbl: UILabel!
    
}
class RecommendedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var seeAllBtn: UIButton!
    @IBOutlet weak var recommendedCollection: UICollectionView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
class RecommendedCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var avgRatingLbl: UILabel!
    @IBOutlet weak var closeTimeLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var imageView: RoundedImageView!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var ratingViw: UIView!
    
    @IBOutlet weak var salonTimeStatusLbl: UILabel!
}

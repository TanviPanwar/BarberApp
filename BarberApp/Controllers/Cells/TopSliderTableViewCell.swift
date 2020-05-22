//
//  TopSliderTableViewCell.swift
//  BarberApp
//
//  Created by iOS8 on 17/03/20.
//  Copyright © 2020 iOS8. All rights reserved.
//

import UIKit
import GoogleMaps

class TopSliderTableViewCell: UITableViewCell , UIScrollViewDelegate{
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var sliderViw: UIView!
    var slideImgArray = [UIImage]()
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
            imageView.image = slideImgArray[i]
            imageView.contentMode = .scaleToFill
            let viw = UIView(frame: CGRect(x: CGFloat(i) *  UIScreen.main.bounds.size.width , y: 0, width: UIScreen.main.bounds.size.width, height: sliderViw.frame.size.height - height))
            viw.backgroundColor = UIColor.black.withAlphaComponent(0.45)
            self.scrollViw.addSubview(imageView)
            self.scrollViw.addSubview(viw)
        }
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
    
    
}
class TimeScheduleCell: UITableViewCell {
    
    @IBOutlet weak var slotsCollectionViw: UICollectionView!
    
    
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
    
    
}
class RecommendedTableViewCell: UITableViewCell {
    
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
    
    @IBOutlet weak var ratingViw: UIView!
    
}

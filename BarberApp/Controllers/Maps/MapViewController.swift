//
//  MapViewController.swift
//  BarberApp
//
//  Created by iOS6 on 17/03/20.
//  Copyright © 2020 iOS8. All rights reserved.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController, GMSMapViewDelegate {
    
    @IBOutlet weak var filterBtn: UIButton!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var listBtn: UIButton!
    @IBOutlet weak var mapBtn: UIButton!
    @IBOutlet weak var informationView: UIView!
    @IBOutlet weak var barberImageView: UIImageView!
    @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var barberNameLabel: UILabel!
    @IBOutlet weak var barberAddressLabel: UILabel!
    @IBOutlet weak var barberCountryLabel: UILabel!
    @IBOutlet weak var barberServiceLabel: UILabel!
    @IBOutlet weak var openStatusLabel: UILabel!
    @IBOutlet weak var closeStatusLabel: UILabel!
    
    
    
    
    var mapView : GMSMapView?
    var markerBool = Bool()
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
     let camera = GMSCameraPosition.camera(withLatitude: 28.7041, longitude: 77.1025, zoom: 1.0)
     mapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: mainView.frame.size.width, height: mainView.frame.size.height), camera: camera)
     mainView.addSubview(mapView!)
     mapView?.delegate = self

      // Creates a marker in the center of the map.
      let marker = GMSMarker()
      let markerImage = #imageLiteral(resourceName: "markerMap")
      let markerView = UIImageView(image: markerImage)
      marker.iconView = markerView
      marker.position = CLLocationCoordinate2D(latitude: 28.7041, longitude: 77.1025)
      marker.title = "Delhi"
      marker.snippet = "India’s capital"
      marker.map = mapView
      seupUI()

        
    }
    
   // MARK: - Custom Methods
    
    func seupUI(){
        
        listBtn.roundCorners(corners: [.topLeft,.bottomLeft], radius: listBtn.frame.size.height)
        mapBtn.roundCorners(corners: [.topRight,.bottomRight], radius: mapBtn.frame.size.height)
        
        informationView.roundCorners(corners: [.allCorners], radius: 10)
        barberImageView.roundCorners(corners: [.allCorners], radius: 10)
        
        ratingView.roundCorners(corners: [.bottomLeft], radius: 6)
        
    }
    
     // MARK: - MapView Delegates
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        print("You tapped : \(marker.position.latitude),\(marker.position.longitude)")
        
        if !markerBool {
            
            let markerImage = #imageLiteral(resourceName: "selectedMarker")
            let markerView = UIImageView(image: markerImage)
            marker.iconView = markerView
            informationView.isHidden = false
            markerBool = true
            
        } else if markerBool {
            
            let markerImage = #imageLiteral(resourceName: "markerMap")
            let markerView = UIImageView(image: markerImage)
            marker.iconView = markerView
            informationView.isHidden = true
            markerBool = false    
            
        }
        
        return true // or false as needed.
    }
    
    
    // MARK: - IB Actions
    
    @IBAction func filterBtnAction(_ sender: Any) {
        
        if #available(iOS 13.0, *) {
            
            let vc = homeStoryBoard.instantiateViewController(identifier:"FilterViewController") as! FilterViewController
            self.present(vc, animated: true, completion: nil)

        } else {
            // Fallback on earlier versions
            
            let vc = homeStoryBoard.instantiateViewController(withIdentifier:"FilterViewController") as! FilterViewController
            self.present(vc, animated: true, completion: nil)

        }
        
    }
    
    @IBAction func listBtnAction(_ sender: Any) {
        
        
        if #available(iOS 13.0, *) {
                  
                  let vc = homeStoryBoard.instantiateViewController(identifier:"DiscoverViewController") as! DiscoverViewController
                
            self.navigationController?.pushViewController(vc, animated: true)
                  
              } else {
                  // Fallback on earlier versions
                  
                  let vc = homeStoryBoard.instantiateViewController(withIdentifier:"DiscoverViewController") as! DiscoverViewController
             self.navigationController?.pushViewController(vc, animated: true)
            
        }
        
        
    }
    
    @IBAction func mapBtnAction(_ sender: Any) {
        
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

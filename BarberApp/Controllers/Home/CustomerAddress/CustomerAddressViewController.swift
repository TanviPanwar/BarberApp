//
//  CustomerAddressViewController.swift
//  BarberApp
//
//  Created by iOS8 on 19/03/20.
//  Copyright © 2020 iOS8. All rights reserved.
//

import UIKit
import GoogleMaps

class CustomerAddressViewController: UIViewController , GMSMapViewDelegate {

    @IBOutlet weak var mapView: GMSMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
               let camera = GMSCameraPosition.camera(withLatitude: 28.7041, longitude: 77.1025, zoom: 1.0)
                mapView.delegate = self
                // Creates a marker in the center of the map.
                let marker = GMSMarker()
                let markerImage = #imageLiteral(resourceName: "selectedMarker")
                let markerView = UIImageView(image: markerImage)
                marker.iconView = markerView
                marker.position = CLLocationCoordinate2D(latitude: 28.7041, longitude: 77.1025)
                marker.title = "Delhi"
                marker.snippet = "India’s capital"
                marker.map = mapView
               mapView.camera = camera
        // Do any additional setup after loading the view.
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveBtnAction(_ sender: Any) {
        
        if #available(iOS 13.0, *) {
            let vc = homeStoryBoard.instantiateViewController(identifier: "ThankYouViewController") as! ThankYouViewController
            self.present(vc, animated: true, completion: nil)
            
        } else {
            // Fallback on earlier versions
            
            let vc = homeStoryBoard.instantiateViewController(withIdentifier: "ThankYouViewController") as! ThankYouViewController
            self.present(vc, animated: true, completion: nil)
        }
        
        
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

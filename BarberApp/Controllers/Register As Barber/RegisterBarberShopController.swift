//
//  RegisterBarberShopController.swift
//  BarberApp
//
//  Created by iOS8 on 20/03/20.
//  Copyright © 2020 iOS8. All rights reserved.
//

import UIKit
import GoogleMaps
import Alamofire


class RegisterBarberShopController: UIViewController , UITextViewDelegate, GMSMapViewDelegate, CLLocationManagerDelegate {
    
    
    @IBOutlet weak var barberShopNameTextField: UITextField!
    @IBOutlet weak var vistitTimeTextField: UITextField!
    @IBOutlet weak var mapViw: GMSMapView!
    
    @IBOutlet var pickerInputView: UIView!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var cancelToolBarBtn: UIBarButtonItem!
    @IBOutlet weak var doneToolBarBtn: UIBarButtonItem!
    
    let format =  DateFormatter()
    var marker = GMSMarker()
    var locationManager = CLLocationManager()

    var lat = Double()
    var long = Double()
    var address =  String()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        self.mapViw?.isMyLocationEnabled = true

        
                    //let camera = GMSCameraPosition.camera(withLatitude: 28.7041, longitude: 77.1025, zoom: 1.0)
                 mapViw?.delegate = self
        
                 // Creates a marker in the center of the map.
                 //let marker = GMSMarker()
                 let markerImage = #imageLiteral(resourceName: "selectedMarker")
                 let markerView = UIImageView(image: markerImage)
                 marker.iconView = markerView
                // marker.position = CLLocationCoordinate2D(latitude: 30.7333, longitude: 76.7794)
                 marker.title = "Delhi"
                 marker.snippet = "India’s capital"
                 marker.map = mapViw
               // mapViw.camera = camera
              self.locationManager.delegate = self

              self.locationManager.startUpdatingLocation()
        
        showPicker()
        // Do any additional setup after loading the view.
    }
    
    //MARK:-
    //MARK:- TextField Delegate
    

    // MARK: - TextField Delegates

       func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
           
           if textField == barberShopNameTextField {
            
               let maxLength = 50
               let currentString: NSString = textField.text! as NSString
               let newString: NSString =
                   currentString.replacingCharacters(in: range, with: string) as NSString
               return newString.length <= maxLength
               
           }
        
        return true
        
    }
    
     //MARK:- GoogleMaps Delegtes
    
//   @objc func moveMarker(){
//       self.lat += 0.0017
//       CATransaction.begin()
//       CATransaction.setValue(2.0, forKey: kCATransactionAnimationDuration)
//       CATransaction.setCompletionBlock {
//           self.marker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
//       }
//       mapViw.animate(to: GMSCameraPosition.camera(withLatitude: self.lat, longitude: self.long, zoom: 15))
//       marker.position = CLLocationCoordinate2D(latitude: self.lat, longitude: self.long)
//       CATransaction.commit()
//       marker.map = mapViw
//   }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

       let location = locations.last

      let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom:1)
    
      marker.position = CLLocationCoordinate2D(latitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!)
        
//         var bounds = GMSCoordinateBounds()
//         bounds = bounds.includingCoordinate(marker.position)


      // self.mapViw.animate(to: camera)
        marker.map = mapViw

        mapViw.camera = camera
       // mapViw.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 100.0))
        lat = marker.position.latitude
        long = marker.position.longitude
        

       //Finally stop updating location otherwise it will come again and again in this delegate
      // self.locationManager.stopUpdatingLocation()

   }
    
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        marker.position = position.target
        print(marker.position)
        lat = marker.position.latitude
        long = marker.position.longitude
    }
    
    
    
    
      //MARK:- IB Actions
    

    @IBAction func backAction(_ sender: Any) {
       // self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func continueBtnAction(_ sender: Any) {
        
        
        
        
        if barberShopNameTextField.text!.isEmpty {
            
           ProjectManager.sharedInstance.showAlertwithTitle(title: "", desc: "Barbershop name is required.", vc: self)
            
            
        } else if vistitTimeTextField.text!.isEmpty {
            
           ProjectManager.sharedInstance.showAlertwithTitle(title: "", desc: "Preferred visit time is required.", vc: self)
            
            
        } else {
            
            let cityCoords = CLLocation(latitude: lat, longitude: long)
            getAdressName(coords: cityCoords)
            
            //saveSaloonAddresseApi()
        }
    
        
    }
    
    @IBAction func cancelBtnAction(_ sender: Any) {
        
        self.view.endEditing(true)
        
    }
    
    @IBAction func doneBtnAction(_ sender: Any) {
        
        format.dateFormat = "hh:mm a"
        vistitTimeTextField.text = format.string(from: datePicker.date)
        
        self.view.endEditing(true)
        
    }
        
    
        //MARK:- Custom Methods
        
        func showPicker()
        {
            vistitTimeTextField.inputView = pickerInputView
            vistitTimeTextField.inputAccessoryView = nil
 
        }
    
    func getAdressName(coords: CLLocation) {

      CLGeocoder().reverseGeocodeLocation(coords) { (placemark, error) in
        
              if error != nil {
                  print("Hay un error")
                
              } else {

                  let place = placemark! as [CLPlacemark]
                  if place.count > 0 {
                      let place = placemark![0]
                      var adressString : String = ""
                    
                    if place.subLocality != nil {
                        adressString = adressString + place.subLocality! + ", "
                    }
                    
                      if place.thoroughfare != nil {
                          adressString = adressString + place.thoroughfare! + ", "
                      }
                      if place.subThoroughfare != nil {
                          adressString = adressString + place.subThoroughfare! + ", "
                      }
                      if place.locality != nil {
                          adressString = adressString + place.locality! + " , "
                      }
                      if place.postalCode != nil {
                          adressString = adressString + place.postalCode! + ", "
                      }
                      if place.subAdministrativeArea != nil {
                          adressString = adressString + place.subAdministrativeArea! + ", "
                      }
                      if place.country != nil {
                          adressString = adressString + place.country!
                      }

                    self.address = adressString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                    print(self.address)
                    
                    self.saveSaloonAddresseApi()
                    
                  }
              }
          }
    }
    
    
    
     //MARK:- Api Methods
    
        func saveSaloonAddresseApi()
        {
            if ProjectManager.sharedInstance.isInternetAvailable()
            {
                if let apiToken = UserDefaults.standard.value(forKey: DefaultsIdentifier.apiToken) as? String {
                    
            
                    
                    let shopName = (barberShopNameTextField.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
                    let visitTime = (vistitTimeTextField.text?.trimmingCharacters(in: CharacterSet.whitespaces))!

                    
                    
                    
                    let params = ["saloon_name":shopName,
                    "saloon_location":address,
                    "preffered_visit_time":visitTime,
                    "saloon_lat":lat,
                    "saloon_lon":long,
] as [String: Any]
                    print(params)
                    
                    DispatchQueue.main.async {
                          ProjectManager.sharedInstance.showLoader(vc: self)
                    }
                    
                    let headers = [
                        "Authorization": "Bearer " + apiToken]
                    
                    //"Accept": "application/json"
                    print(headers)
                    
                    Alamofire.request(Base_Url+saveSaloonAddressUrl , method: .post,  parameters: params, encoding: URLEncoding.default, headers:headers)
                        .responseJSON { response in
                            
                             ProjectManager.sharedInstance.stopLoader()
                            // check for errors
                            guard response.result.error == nil else {
                                // got an error in getting the data, need to handle it
                                print("error calling GET on /todos/1")
                                print(response.result.error!)
                                return
                            }
                            print(response.result.value!)
                            // make sure we got some JSON since that's what we expect
                            guard let json = response.result.value as? [String: Any] else {
                                print("didn't get todo object as JSON from API")
                                if let error = response.result.error {
                                    print("Error: \(error)")
                                }
                                return
                            }
                            print(json)
                            let status = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"status", dict: json as NSDictionary)
                            let msg = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"message", dict: json as NSDictionary)
                            if status.boolValue {
                                
                                if let data = json["data"] as? [String: Any] {
                                    
                                    //                                let objc = ProjectManager.sharedInstance.GetLoginDataObjects(dict: data)
                                    
                                    
                                    var vc = CompleteProfileViewController()
                                    
                                    if #available(iOS 13.0, *) {
                                        
                                        vc = mainStoryBoard.instantiateViewController(identifier: "CompleteProfileViewController") as! CompleteProfileViewController
                                        
                                    } else {
                                        // Fallback on earlier versions
                                        
                                         vc = mainStoryBoard.instantiateViewController(withIdentifier: "CompleteProfileViewController") as! CompleteProfileViewController
                                        
                                    }
                                    
                                    vc.freelanceBool = false
                                    self.present(vc, animated: true, completion: nil)
                                    
                                }
                                 
                                
                            } else {
                                
                                DispatchQueue.main.async {
                                    ProjectManager.sharedInstance.showServerError(viewController: self)
                                    
                                }
                            }
                    }
                    
                }
                
            }
                
            else {
                DispatchQueue.main.async(execute: {
                    
                    ProjectManager.sharedInstance.showAlertwithTitle(title: "Internet connection lost", desc: "Please check your internet connection.", vc: self)
                })
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

//
//  AdditionalInfoViewController.swift
//  BarberApp
//
//  Created by iOS6 on 19/03/20.
//  Copyright © 2020 iOS8. All rights reserved.
//

import UIKit
import AssetsPickerViewController
import Photos
import CoreServices
import MobileCoreServices
import AVFoundation
import AVKit
import MediaPlayer
import Alamofire
import IQKeyboardManagerSwift

class AdditionalInfoViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate , UINavigationControllerDelegate, UIDocumentPickerDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UITextViewDelegate, getTokenDelegate {
    
    
    func getAccessToken(code: String) {
        tokenApi(code: code)
    }
    
    
    
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var addInfoTableView: UITableView!
    @IBOutlet weak var mediaCollectionView: UICollectionView!
    @IBOutlet weak var addMediaBtn: UIButton!
    @IBOutlet weak var aboutView: UIView!
    
    @IBOutlet weak var aboutTextView: IQTextView!
    
    //@IBOutlet weak var aboutTextView: UITextView!
    
    @IBOutlet weak var aboutCountLabel: UILabel!
    @IBOutlet weak var motherToungeTextfield: UITextField!
    @IBOutlet weak var secondLanguageTextField: UITextField!
    @IBOutlet weak var thirdLanguageTextField: UITextField!
    @IBOutlet weak var connectInstagramBtn: UIButton!
    @IBOutlet weak var uploadFrontQatarBtn: UIButton!
    @IBOutlet weak var uploadBackQatarBtn: UIButton!
    @IBOutlet weak var uploadPassportPhotoBtn: UIButton!
    @IBOutlet weak var setupScheduleBtn: UIButton!
    
    @IBOutlet var pickerInputView: UIView!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var cancelToolBarBtn: UIBarButtonItem!
    @IBOutlet weak var doneToolBarBtn: UIBarButtonItem!
    
    let kHeaderSectionTag: Int = 6900;
    var i: Int = 0
    var answeredQuestionsArray: Array<Any> = []
    var sectionItems: Array<Any> = []
    //let section  = headerView?.tag
    var expandedSectionHeaderNumber: Int = -1
    var expandedSectionHeader: UITableViewHeaderFooterView!
    var headerView : UIView?

    
    var freelanceBool = Bool()
    var index = Int()
    var assets = [PHAsset]()
    var urlsAarray = [URL]()
    var myPickerController = UIImagePickerController()
    var imageArray = [UIImage]()
    var totlaImageArray = [UIImage]()

    var imageData = [Data]()

    var addBool = Bool()
    var mediaBool = Bool()
    var selectedIndex = Int()
    var selectedIndexArray = [Int]()
    var deletedIndexArray = [Int]()

    var mediaIndexArray = [Int]()
    var Mediaindex = 0
    var btnTag = Int()
    var LanguageArray = [CountryObject]()
    var uploadTag = Int()
    var frontIDData = Data()
    var backIDData = Data()
    var passportData = Data()
    var instagramToken = String()
    var userLanguage = String()
    var secongLanguage = String()
    var thirdLanguage = String()
    var addinfoProfileObjc = AdditionalInfoObject()
    var sectionArray = ["Upload front Qatar ID*","Upload back Qatar ID*","Upload passport cover photo*"]
    var frontImage = UIImage()
    var backImage = UIImage()
    var passImage = UIImage()
    var uniqueImageArray = [UIImage]()
    var profileBool = Bool()
    var nameStr = String()
    var maxUploadSize = String()
    var maxSize = Float()
    
   




    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        if profileBool {
            
            saveBtn.isHidden = false
            setupScheduleBtn.isHidden = true
            
        } else {
            
            saveBtn.isHidden = true
            setupScheduleBtn.isHidden = false


        }
        ProjectManager.sharedInstance.tokenDelegate = self
        
        if UserDefaults.standard.value(forKey: "user_Name") != nil {
            
            
            let str =  UserDefaults.standard.value(forKey: "user_Name") as? String
            nameLabel.text =  "About " + str!
            
        }
        
        showPicker()
        loadJson(filename: "languages")
        getAddInfoApi()
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    //MARK:- TextField Delegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == motherToungeTextfield {
            
            btnTag = textField.tag

                showPicker()
                pickerView.reloadAllComponents()
        
            
        } else if textField == secondLanguageTextField {
            
            
            btnTag = textField.tag
            showPicker()

            
        } else if textField == thirdLanguageTextField {
            
             btnTag = textField.tag
            showPicker()
            
            
        }
        
    }
    
//  func updateCharacterCount() {
//     let summaryCount = aboutTextView.text.count
//
//     aboutCountLabel.text = "\((0) + summaryCount)"
//
//  }
//
//  func textViewDidChange(_ textView: UITextView) {
//     self.updateCharacterCount()
//  }
//
     func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool{
        guard let textview = textView.text else { return true }

        
        let length = textview.count + text.count - range.length

        // create an Integer of 55 - the length of your TextField.text to count down
        let count = 500 - length

        // set the .text property of your UILabel to the live created String
        
        aboutCountLabel.text =  String(count)

        // if you want to limit to 55 charakters
        // you need to return true and <= 55

         return length <= 499
        
        
//        let str = (textView.text + text)
//               if str.count <= 499 {
//                aboutCountLabel.text =  String(str.count)
//
//
//                   return true
//               }
//               return false
//
//
        
   
     }
    
    
    
    // MARK: - Custom Methods
    
    func setupUI() {
        
        
       // nameLabel.text = "About " + userName
        
        addMediaBtn.roundCorners(corners: [.allCorners], radius: addMediaBtn.frame.size.height/2)
        aboutView.setBorder(width: 1, color: #colorLiteral(red: 0.8117647059, green: 0.800083518, blue: 0.7998213172, alpha: 1))
        
        
        aboutTextView.text = addinfoProfileObjc.about
        
        if aboutTextView.text.isEmpty {
            
            aboutCountLabel.text = "500"

        } else {
            
           aboutCountLabel.text = "\(500 - aboutTextView.text.count)"
            
        }
        
        if LanguageArray.contains(where: {$0.code == addinfoProfileObjc.user_language}) {
            // it exists, do something
            
            let index = LanguageArray.firstIndex(where: { $0.code == addinfoProfileObjc.user_language })
            motherToungeTextfield.text = LanguageArray[index!].countryName
            
        }
        if LanguageArray.contains(where: {$0.code == addinfoProfileObjc.second_language}) {
            // it exists, do something
            
            let index1 = LanguageArray.firstIndex(where: { $0.code == addinfoProfileObjc.second_language })
            secondLanguageTextField.text = LanguageArray[index1!].countryName
            
        }
        if LanguageArray.contains(where: {$0.code == addinfoProfileObjc.third_language}) {
            // it exists, do something
            
            let index2 = LanguageArray.firstIndex(where: { $0.code == addinfoProfileObjc.third_language })
            thirdLanguageTextField.text = LanguageArray[index2!].countryName
            
        }
        
    }
    
    @objc func showPicker()
    {
        motherToungeTextfield.inputView = pickerInputView
        motherToungeTextfield.inputAccessoryView = nil
        
        secondLanguageTextField.inputView = pickerInputView
        secondLanguageTextField.inputAccessoryView = nil
        
        thirdLanguageTextField.inputView = pickerInputView
        thirdLanguageTextField.inputAccessoryView = nil
     
        
    }
    
    
     func loadJson(filename fileName: String){
           if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
               do {
                   let data = try Data(contentsOf: url)
                   let object = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                   if let array = object as? NSArray {
                       print(array)
                       self.LanguageArray = ProjectManager.sharedInstance.GetCountriesIDObjects(array: array)
                    
                    self.pickerView.reloadAllComponents()

                   }
               } catch {
                   print("Error!! Unable to parse  \(fileName).json")
               }
           }
    
       }
    
    
    func singlePicker() {
        
        self.addBool = true
        
        let alertController = UIAlertController(title:"", message:"", preferredStyle: .actionSheet)
        let cameraAction =  UIAlertAction(title:"Camera", style:.default) { (action) in
            self.openCamera()
        }
        let galleryAction = UIAlertAction(title:"Gallery", style:.default) { (action) in
            self.photoLibrary()
        }
        let cancelAction = UIAlertAction(title:"Cancel", style: .cancel, handler: nil)
        alertController.addAction(cameraAction)
        alertController.addAction(galleryAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func openCamera(){
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            myPickerController.delegate = self
            myPickerController.sourceType = .camera
            myPickerController.mediaTypes = [kUTTypeImage] as [String]
            self.present(myPickerController, animated: true, completion: nil)
        }
    }
    func photoLibrary(){
        
        if addBool {
            
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                      let myPickerController = UIImagePickerController()
                      myPickerController.delegate = self
                     // myPickerController.sourceType = .photoLibrary
                      myPickerController.sourceType = .savedPhotosAlbum

                      self.present(myPickerController, animated: true, completion: nil)
                  }
            addBool = false
            
        } else {
       // if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
           let picker = AssetsPickerViewController()
            picker.pickerDelegate = self
            present(picker, animated: true, completion: nil)
       // }
            
        }
    }
    
    func getAssetThumbnail(asset: PHAsset) -> UIImage {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var thumbnail = UIImage()
        option.isSynchronous = true
        manager.requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFill, options: option, resultHandler: {(result, info)->Void in
                thumbnail = result!
        })
        return thumbnail
    }
    
    
    
    // MARK: - IB Actions
    
    
    @IBAction func backBtnAction(_ sender: Any) {
        
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func saveBtnAction(_ sender: Any) {
            
            
            if aboutTextView.text!.isEmpty {
                
                ProjectManager.sharedInstance.showAlertwithTitle(title: "", desc: "About  is required.", vc: self)
                
                
            }
    //        else if instagramToken.isEmpty  {
    //
    //            ProjectManager.sharedInstance.showAlertwithTitle(title: "", desc: "Connect to   Instagram is required", vc: self)
    //
    //
    //        }
            else if addinfoProfileObjc.user_language.isEmpty  {
                
                ProjectManager.sharedInstance.showAlertwithTitle(title: "", desc: "Mother tounge is required", vc: self)
                
                
            } else if addinfoProfileObjc.frontID.isEmpty  {
                
                ProjectManager.sharedInstance.showAlertwithTitle(title: "", desc: "Front Qatar ID is required", vc: self)
                
                
            } else if addinfoProfileObjc.backID.isEmpty  {
                
                ProjectManager.sharedInstance.showAlertwithTitle(title: "", desc: "Back Qatar ID is required", vc: self)
                
                
            } else if addinfoProfileObjc.passID.isEmpty  {
                
                ProjectManager.sharedInstance.showAlertwithTitle(title: "", desc: "Passport cover photo is required", vc: self)
                
                
            } else {
            
                saveAddInfo()
            
    //        if !freelanceBool {
    //            if #available(iOS 13.0, *) {
    //                let vc = mainStoryBoard.instantiateViewController(identifier: "ReceiveJobsViewController") as! ReceiveJobsViewController
    //                self.present(vc, animated: true, completion: nil)
    //            } else {
    //                // Fallback on earlier versions
    //                let vc = mainStoryBoard.instantiateViewController(withIdentifier: "ReceiveJobsViewController") as! ReceiveJobsViewController
    //
    //                self.present(vc, animated: true, completion: nil)
    //
    //            }
    //
    //        } else {
    //
    //
    //        }
                
            }
            
            
        }
    
    
    @IBAction func addMediaBtnAction(_ sender: Any) {
        
//        if imageArray.count == 9 {
//
//            imageArray.removeAll()
//            mediaCollectionView.reloadData()
//
//        } else {
//
//
//        }
        
        
        let alertController = UIAlertController(title:"", message:"", preferredStyle: .actionSheet)
        let cameraAction =  UIAlertAction(title:"Camera", style:.default) { (action) in
            self.openCamera()
        }
        let galleryAction = UIAlertAction(title:"Gallery", style:.default) { (action) in
            self.photoLibrary()
        }
        let cancelAction = UIAlertAction(title:"Cancel", style: .cancel, handler: nil)
        //alertController.addAction(cameraAction)
        alertController.addAction(galleryAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    @IBAction func connectInstagramBtnAction(_ sender: Any) {
        
        
        if #available(iOS 13.0, *) {
            
            let vc = mainStoryBoard.instantiateViewController(identifier: "InstgramLoginWebViewController") as! InstgramLoginWebViewController
            self.present(vc, animated: true, completion: nil)
            
        } else {
            
            // Fallback on earlier versions
            let vc = mainStoryBoard.instantiateViewController(withIdentifier: "InstgramLoginWebViewController") as! InstgramLoginWebViewController
            self.present(vc, animated: true, completion: nil)
            
        }
        
    }
    
    
    @IBAction func uploadFrontQatarIDBtnAction(_ sender: Any) {
        
        uploadTag = 1
        singlePicker()

    }
    
    @IBAction func uploadBacktQatarIDBtnAction(_ sender: Any) {
        
        uploadTag = 2
        singlePicker()

    }
    
    @IBAction func uploadPassportPhotoBtnAction(_ sender: Any) {
        
        uploadTag = 3
        singlePicker()

    }
    
    @IBAction func setupScheduleBtnAction(_ sender: Any) {
        
        
        if aboutTextView.text!.isEmpty {
            
            ProjectManager.sharedInstance.showAlertwithTitle(title: "", desc: "About  is required.", vc: self)
            
            
        }
//        else if instagramToken.isEmpty  {
//
//            ProjectManager.sharedInstance.showAlertwithTitle(title: "", desc: "Connect to   Instagram is required", vc: self)
//
//
//        }
        else if addinfoProfileObjc.user_language.isEmpty  {
            
            ProjectManager.sharedInstance.showAlertwithTitle(title: "", desc: "Mother tounge is required", vc: self)
            
            
        } else if addinfoProfileObjc.frontID.isEmpty   //qtr_front_id
        
        {
            
            ProjectManager.sharedInstance.showAlertwithTitle(title: "", desc: "Front Qatar ID is required", vc: self)
            
            
        } else if addinfoProfileObjc.backID.isEmpty    //qtr_back_id
        
        {
            
            ProjectManager.sharedInstance.showAlertwithTitle(title: "", desc: "Back Qatar ID is required", vc: self)
            
            
        } else if addinfoProfileObjc.passID.isEmpty  {  //passport
            
            ProjectManager.sharedInstance.showAlertwithTitle(title: "", desc: "Passport cover photo is required", vc: self)
            
            
        } else {
        
            saveAddInfo()
        
//        if !freelanceBool {
//            if #available(iOS 13.0, *) {
//                let vc = mainStoryBoard.instantiateViewController(identifier: "ReceiveJobsViewController") as! ReceiveJobsViewController
//                self.present(vc, animated: true, completion: nil)
//            } else {
//                // Fallback on earlier versions
//                let vc = mainStoryBoard.instantiateViewController(withIdentifier: "ReceiveJobsViewController") as! ReceiveJobsViewController
//
//                self.present(vc, animated: true, completion: nil)
//
//            }
//
//        } else {
//
//
//        }
            
        }
        
        
    }
    
    
    @IBAction func cancelBtnAction(_ sender: Any) {
              
              self.view.endEditing(true)
              
          }
          
          @IBAction func doneBtnAction(_ sender: Any) {
           
           let row = pickerView.selectedRow(inComponent: 0)

           
           if btnTag == 1 {
            
            motherToungeTextfield.text = LanguageArray[row].countryName
            addinfoProfileObjc.user_language = LanguageArray[row].code
               
               
               
           } else if btnTag == 2 {
            
              secondLanguageTextField.text = LanguageArray[row].countryName
              addinfoProfileObjc.second_language = LanguageArray[row].code


               
           } else if btnTag == 3 {
            
              thirdLanguageTextField.text = LanguageArray[row].countryName
              addinfoProfileObjc.third_language = LanguageArray[row].code
 

               
           }
           
             self.view.endEditing(true)

           
       }
    
    
     //MARK:-Api Methods
    
    func tokenApi(code: String) {
           
           
           let urlString = "https://api.instagram.com/oauth/access_token"

           let appendedURI = "client_id=\(INSTAGRAM_IDS.INSTAGRAM_CLIENT_ID)&client_secret=\(INSTAGRAM_IDS.INSTAGRAM_CLIENTSERCRET)&grant_type=authorization_code&redirect_uri=\(INSTAGRAM_IDS.INSTAGRAM_REDIRECT_URI)&code=\(code)"

               let url = URL(string: urlString)!

               let session = URLSession.shared
               var request = URLRequest(url: url)
               request.httpMethod = "Post"
               request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField:"Content-Type");
               request.cachePolicy = URLRequest.CachePolicy.reloadIgnoringCacheData
               request.httpBody = appendedURI.data(using: .utf8)


           let task = session.dataTask(with: request) { (data, response, error) in
                       if error == nil {
                       let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                       print("result=",dataString!)
                           do {

                           if let accDetail = try JSONSerialization.jsonObject(with: data!, options: []) as? [String : Any] {

                               let accessToken = accDetail["access_token"] as! String

                               let userID = accDetail["user_id"] as! Int64

                              // completion("success", accessToken, userID)
                            
                            self.longTokenApi(token: accessToken)

                           }

                       }catch let error {



                       }
                   }

               }
               task.resume()
        
  
           
    }
    
        func longTokenApi(token: String) {
               
            let urlString = String(format: "%@?client_secret=%@&access_token=%@&grant_type=ig_exchange_token", arguments: [INSTAGRAM_IDS.INSTAGRAM_GRAPHAPI,INSTAGRAM_IDS.INSTAGRAM_CLIENTSERCRET,token])
            
        

                   let url = URL(string: urlString)!

                   let session = URLSession.shared
                   var request = URLRequest(url: url)
                   request.httpMethod = "Get"
                   request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField:"Content-Type");
                   request.cachePolicy = URLRequest.CachePolicy.reloadIgnoringCacheData
 
               let task = session.dataTask(with: request) { (data, response, error) in
                           if error == nil {
                           let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                           print("result=",dataString!)
                               do {

                               if let accDetail = try JSONSerialization.jsonObject(with: data!, options: []) as? [String : Any] {

                                   let accessToken = accDetail["access_token"] as! String
                                   let tokenType = accDetail["token_type"] as! String
                                   let expiresIn = accDetail["expires_in"] as! Int64
                                   self.instagramToken = accessToken

                                  // completion("success", accessToken, userID)

                               }

                           }catch let error {



                           }
                       }

                   }
                   task.resume()
               
               
               
              // }
               
            //}
               
        }
    
    
    func saveAddInfo() {
        
        
        if ProjectManager.sharedInstance.isInternetAvailable()
        {
            
            
            if let apiToken = UserDefaults.standard.value(forKey: DefaultsIdentifier.apiToken) as? String {
                
                 let about = (aboutTextView.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
               
                DispatchQueue.main.async {
                    ProjectManager.sharedInstance.showLoader(vc: self)
                }
                
                let headers = [
                    "Authorization": "Bearer " + apiToken, "Accept": "application/json"]
                
                var additionalPathArr = [String]()
                
                if self.addinfoProfileObjc.additional_info.count > 0 {
                for i in self.addinfoProfileObjc.additional_info {
                    
                    let parsed = i.replacingOccurrences(of: "http://13.126.46.105", with: "")
                    
                    additionalPathArr.append(parsed)
                    

                }
                    
            }
                
                let additionalPathArray = (additionalPathArr.map{String($0)}).joined(separator: ",")
                
                var params = [String: Any]()
                    
                var serviceType = String()
                
                if freelanceBool {
                    
                    serviceType = "Freelancer"
                    
                } else {
                    
                    serviceType = "Salon"

                }
                
                
                
                params = ["about":about, "user_language":addinfoProfileObjc.user_language, "second_language":addinfoProfileObjc.second_language, "third_language":addinfoProfileObjc.third_language, "service_type":serviceType, "instagram_token:":instagramToken, "additional_data_path":additionalPathArray] as[String: Any]
                
                let imageParamName = "additional_info"
                print(params)
                
                
                if totlaImageArray.count > 0 {
                    for image in totlaImageArray {
                        
                        let imageD = image.jpegData(compressionQuality: 0.1)
                        imageData.append(imageD!)
                        
                    }
                    
                }
             
                Alamofire.upload(multipartFormData: { multipartFormData in
                    // import image to request
                    
                    if self.totlaImageArray.count > 0 {
                        for i in 0...self.imageData.count - 1 {
                        
                        let imageData = self.imageData[i]
                        multipartFormData.append(imageData, withName: "\(imageParamName)[\(i)]", fileName: "\(Date().timeIntervalSince1970).jpeg", mimeType: "image/jpeg")
                    }
                        
                    } else {
                        
                        let imageData = Data()
                        multipartFormData.append(imageData, withName:  "\(imageParamName)[]", fileName: "", mimeType: "" )
                        
                        
//                        params = ["about":about, "user_language":self.addinfoProfileObjc.user_language, "second_language":self.addinfoProfileObjc.second_language, "third_language":self.addinfoProfileObjc.third_language, "service_type":"Saloon", "instagram_token:":self.instagramToken,"additional_info[]": self.imageArray, "additional_data_path":additionalPathArray]
//                        print(params)

                        
                    }
                    
                    if self.frontIDData.isEmpty {
                        
                        multipartFormData.append(self.frontIDData, withName: "qtr_front_id", fileName: "", mimeType: "" )
                        
                    } else {
                        
                        multipartFormData.append(self.frontIDData, withName: "qtr_front_id", fileName: "\(Date().timeIntervalSince1970).jpeg", mimeType: "image/jpeg" )
                        
                    }
                    
                    
                    if self.backIDData.isEmpty {
                        
                        multipartFormData.append(self.backIDData, withName: "qtr_back_id", fileName: "", mimeType: "" )
                        
                    } else {
                        
                        multipartFormData.append(self.backIDData, withName: "qtr_back_id", fileName: "\(Date().timeIntervalSince1970).jpeg", mimeType: "image/jpeg" )
                        
                    }
                    
                    if self.passportData.isEmpty {
                        
                        multipartFormData.append(self.passportData, withName: "passport", fileName: "", mimeType: "" )
                        
                    } else {
                        
                        
                        multipartFormData.append(self.passportData, withName: "passport", fileName: "\(Date().timeIntervalSince1970).jpeg", mimeType: "image/jpeg" )
                        
                    }

                    
                    for (key, value) in params {
                        multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
                    }
                }, to: Base_Url+saveAddInfoUrl, headers:headers,
                   
                   encodingCompletion: { encodingResult in

                    switch encodingResult {
                    case .success(let upload, _, _):
                        upload.responseJSON { response in
                            
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
                                    
                                    if self.profileBool {
                                        
                                        self.dismiss(animated: true, completion: nil)
                                        
                                        
                                    } else {
                                    
                                    if !self.freelanceBool {
                                        if #available(iOS 13.0, *) {
                                            let vc = mainStoryBoard.instantiateViewController(identifier: "ReceiveJobsViewController") as! ReceiveJobsViewController
                                            self.present(vc, animated: true, completion: nil)
                                        } else {
                                            // Fallback on earlier versions
                                            let vc = mainStoryBoard.instantiateViewController(withIdentifier: "ReceiveJobsViewController") as! ReceiveJobsViewController
                                            
                                            self.present(vc, animated: true, completion: nil)
                                            
                                        }
                                        
                                    } else {
                                        
                                        
                                        if #available(iOS 13.0, *) {
                                            let vc = mainStoryBoard.instantiateViewController(identifier: "ReceiveJobsViewController") as! ReceiveJobsViewController
                                            vc.freelanceBool = true

                                            self.present(vc, animated: true, completion: nil)
                                        } else {
                                            // Fallback on earlier versions
                                            let vc = mainStoryBoard.instantiateViewController(withIdentifier: "ReceiveJobsViewController") as! ReceiveJobsViewController
                                            
                                            vc.freelanceBool = true
                                            self.present(vc, animated: true, completion: nil)
                                            
                                        }

                                        
                                        
                                        
                                    }
                                }
                                    
                                }
                                
                                
                            } else {
                                
                                DispatchQueue.main.async {
                                    ProjectManager.sharedInstance.showServerError(viewController: self)
                                    
                                }
                            }
                            
                        }
                    case .failure(let error):
                        print(error)
                        ProjectManager.sharedInstance.stopLoader()

                    }
                    
                })
                
            }
            
        }
            
        else {
            DispatchQueue.main.async(execute: {
                
                ProjectManager.sharedInstance.showAlertwithTitle(title: "Internet connection lost", desc: "Please check your internet connection.", vc: self)
            })
        }
        
    }
    
    func getAddInfoApi()
    {
        if ProjectManager.sharedInstance.isInternetAvailable()
        {
            if let apiToken = UserDefaults.standard.value(forKey: DefaultsIdentifier.apiToken) as? String {
                
                // if apiToken != nil {
                
                
                
                DispatchQueue.main.async {
                     ProjectManager.sharedInstance.showLoader(vc: self)
                }
                
                let headers = [
                    "Authorization": "Bearer " + apiToken]
                
                //"Accept": "application/json"
                print(headers)
                
                Alamofire.request(Base_Url+getAddInfoUrl , method: .post,  parameters: nil, encoding: URLEncoding.default, headers:headers)
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
                        self.maxUploadSize = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"max_upload_filesize", dict: json as NSDictionary) as String
                        
                        
                        if status.boolValue {
                            
                            if let data = json["data"] as? [String: Any] {
                                
                                let objc = ProjectManager.sharedInstance.GetAdditionalInfoObjects(dict: data)
                                self.addinfoProfileObjc = objc
                                
                                
                                if self.addinfoProfileObjc.additional_info.count > 0 {
                                for imageStr in self.addinfoProfileObjc.additional_info {

                                    if let url = URL(string: imageStr) {
                                        if let data = try? Data(contentsOf: url)
                                    {
                                        let image  = UIImage(data: data)!
                                        self.imageArray.append(image)

                                    }

                                    }


                                }

                            }
                                
                                
                                self.setupUI()
                                self.addInfoTableView.reloadData()
                                self.mediaCollectionView.reloadData()
                                
                                
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
    
    
    
    
    
    
     //MARK:- PickerView DataSources
       
       func numberOfComponents(in pickerView: UIPickerView) -> Int {
           return 1
       }
       
       func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
           
         return LanguageArray.count
          
       }
       
       
       func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView
       {
           let pickerLabel = UILabel()
        
           pickerLabel.text = LanguageArray[row].countryName
           pickerLabel.lineBreakMode = .byWordWrapping
           pickerLabel.numberOfLines = 0
           pickerLabel.sizeToFit()
           
           pickerLabel.textAlignment = NSTextAlignment.center
           return pickerLabel
       }
       
       
       func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
           
       }
       
       func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
         
           
           return 30.0
       }
    
    
    // MARK: - CollectionView Delegates
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        
        return CGSize(width: (UIScreen.main.bounds.size.width - 60)/3, height: 110 )
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"additionalInfoCell", for: indexPath) as? AdditionalInfoCollectionViewCell else {return UICollectionViewCell()}
        
        cell.imageView.setBorder(width: 1, color: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1))
        

        
        
        
        
        if imageArray.count > 0 {

            if imageArray.count <= indexPath.row {
                
               // cell.imageView.image = #imageLiteral(resourceName: "barberSample")

            } else {
            
                if selectedIndexArray.contains(indexPath.row) {

//                    cell.imageView.image = imageArray[indexPath.row]
//                    cell.addBtn.setImage(#imageLiteral(resourceName: "Cross-1"), for: .normal)


                } else {
                    
                    
                    

                   // if cell.imageView.image == nil {
                        
                        cell.imageView.image = imageArray[indexPath.row]
                        cell.addBtn.setImage(#imageLiteral(resourceName: "Cross-1"), for: .normal)
                    
//                        if self.addinfoProfileObjc.additional_info.count > 0 {
//                        if !self.addinfoProfileObjc.additional_info[indexPath.row].isEmpty {
//
//                            self.addinfoProfileObjc.additional_info.remove(at: indexPath.row)
//                        }
//                            
//                    }

//
//                    } else {
//
//
//                    }

                    
                    
//                    cell.imageView.image = imageArray[indexPath.row]
//                    cell.addBtn.setImage(#imageLiteral(resourceName: "Cross-1"), for: .normal)

                        
                   

                }
                    
                    
                



            }
            
            
            
        }
            
            /* For AddInfo Urls */
            
//        if self.addinfoProfileObjc.additional_info.count > 0 {
//
//
//
//            if addinfoProfileObjc.additional_info.count <= indexPath.row {
//
//                // cell.imageView.image = #imageLiteral(resourceName: "barberSample")
//
//            } else {
//
//                for i in self.addinfoProfileObjc.additional_info {
//                cell.imageView!.sd_setImage(with: URL(string :self.addinfoProfileObjc.additional_info[indexPath.row] )) { (image, error, cache, url) in
//
//                }
//                cell.addBtn.setImage(#imageLiteral(resourceName: "Cross-1"), for: .normal)
//
//
//                }
//
//            }
//        }
            
            
            
        
        else {

           // cell.imageView.image = nil

        }
                
        
        
        
        
        cell.onAddButtonTapped = {
            
            
            self.uploadTag = 4
            
            if cell.imageView.image == nil {
                
                
                cell.addBtn.setImage(#imageLiteral(resourceName: "Cross-1"), for: .normal)
                self.selectedIndex = indexPath.row
                self.singlePicker()
                
                
            } else {
                
                
                if let index = self.imageArray.firstIndex(where: {$0 == cell.imageView.image}) {
                    
                    self.imageArray.remove(at: index)
                    
                    if self.addinfoProfileObjc.additional_info.count > 0 {
                        
                        if self.addinfoProfileObjc.additional_info.indices.contains(index) {
                        self.addinfoProfileObjc.additional_info.remove(at: index)

                    }
                    
                }
                    
            }
                
                if let index = self.totlaImageArray.firstIndex(where: {$0 == cell.imageView.image}) {
                    
                    self.totlaImageArray.remove(at: index)
                }
                
           
            // self.imageArray.remove(at: indexPath.row)
            if self.selectedIndexArray.contains(indexPath.row) {

                if let index = self.selectedIndexArray.firstIndex(where: {$0 == indexPath.row}) {
                        
                        self.selectedIndexArray.remove(at: index)
                    }
                }
                cell.addBtn.setImage(#imageLiteral(resourceName: "Add-1"), for: .normal)
                cell.imageView.image = nil
                
                if (self.deletedIndexArray.contains(indexPath.row)) {
                    
                    
                } else {
                    
                    self.deletedIndexArray.append(indexPath.row)
                    
                }
                
                
                
//                if self.addinfoProfileObjc.additional_info.count > 0 {
//                if !self.addinfoProfileObjc.additional_info[indexPath.row].isEmpty {
//
//                    self.addinfoProfileObjc.additional_info.remove(at: indexPath.row)
//                }
//
//            }
                
                
            
            }
        }
        
        
        
        
        return cell
        
    }
    
    
    // MARK: - TableView Delegates
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            
            if addinfoProfileObjc.frontID == "" {
                
                return 0
                
            } else {
                
                return 1
            }
            
        } else  if section == 1 {
            
            if addinfoProfileObjc.backID == "" {
                
                return 0
                
            } else {
                
                return 1
            }
            
        } else {
            
            if addinfoProfileObjc.passID == "" {
                
                return 0
                
            } else {
                
                return 1
            }
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        guard let cell = addInfoTableView.dequeueReusableCell(withIdentifier:"addInfoTableCell", for: indexPath) as? AdditionalInfoTableViewCell else {return UITableViewCell()}
        
        
        if indexPath.section == 0 {
            
            if !self.addinfoProfileObjc.frontID.isEmpty {
                
                if !self.addinfoProfileObjc.qtr_front_id.isEmpty {
                    
                    cell.cellImageView!.sd_setImage(with: URL(string :self.addinfoProfileObjc.qtr_front_id )) { (image, error, cache, url) in
                        
                    }            } else {
                    
                    cell.cellImageView.image = self.frontImage
                    
                    
                }
                
            }else {
                
                cell.cellImageView.image = nil
                
                
                
            }
            
        } else if indexPath.section == 1 {
            
            if !self.addinfoProfileObjc.backID.isEmpty {
                
                if !self.addinfoProfileObjc.qtr_back_id.isEmpty {
                    
                    
                    cell.cellImageView!.sd_setImage(with: URL(string :self.addinfoProfileObjc.qtr_back_id )) { (image, error, cache, url) in
                        
                    }
                } else {
                    
                    cell.cellImageView.image = backImage
                    
                }
            } else {
                
                cell.cellImageView.image = nil
                
                
                
            }
            
        } else if indexPath.section == 2 {
            
            if !self.addinfoProfileObjc.passID.isEmpty {
                
                if !self.addinfoProfileObjc.passport.isEmpty {
                    cell.cellImageView!.sd_setImage(with: URL(string :self.addinfoProfileObjc.passport )) { (image, error, cache, url) in
                        
                    }
                } else {
                    cell.cellImageView.image = passImage
                    
                    
                }
            } else {
                
                cell.cellImageView.image = nil
            }
            
        } else {
            
            
            
        }
        
        cell.deleteBtn.tag = indexPath.section
        
        cell.onDeleteButtonTapped = {
            
            
            
            if indexPath.section == 0 || indexPath.section == 1 || indexPath.section == 2 {
                
                
                if let sectionHeader = self.headerView {
                    

                    let headerHeight:CGFloat
                    
                    
                    headerHeight = 80.0
                    
                    
                    UIView.animate(withDuration: 0.3, animations: {
                        self.addInfoTableView?.beginUpdates()
                        sectionHeader.frame.size.height = headerHeight
                        self.addInfoTableView?.endUpdates()
                    } )
                    
                    if indexPath.section == 0 {
                        
                        self.addinfoProfileObjc.frontID = ""
                        self.frontImage = UIImage()
                        
                    } else if indexPath.section == 1 {
                        
                        self.addinfoProfileObjc.backID = ""
                        self.backImage = UIImage()

                        
                        
                    } else if indexPath.section == 2 {
                        
                        self.addinfoProfileObjc.passID = ""
                        self.passImage = UIImage()

                        
                    }
                    
                    self.addInfoTableView.reloadData()
                    
                    
                }
                
                
            }
            
            
            
        }
        
        return cell
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        
        if section == 0 {
            
            if addinfoProfileObjc.frontID == "" {
                
                return 80
            } else {
                
                return 30
            }
            
        } else  if section == 1 {
            
            if addinfoProfileObjc.backID == "" {
                
                return 80
            } else {
                
                return 30
            }
            
        } else {
            
            if addinfoProfileObjc.passID == "" {
                
                return 80
            } else {
                
                return 30
            }
        }
        
    }
       
       func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
           
           return 2
       }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    
    //        if section == 0 {
    
        let obj = sectionArray[section]
    
        headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 80))
        
        let label = UILabel(frame: CGRect(x: 25, y: 20, width: UIScreen.main.bounds.width - 100 , height: 21))
        label.font = UIFont(name:"Helvetica Neue Bold", size: 17)
        // label.numberOfLines = 2
        label.text = obj
                
        let uploadBtn =   UIButton(frame: CGRect(x: 25, y: label.frame.origin.y + label.frame.size.height + 4, width: UIScreen.main.bounds.width - 50, height: 38)) // label.frame.origin.x + size.width + 170
        uploadBtn.setTitle("Upload image", for: .normal)
        uploadBtn.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        uploadBtn.titleLabel?.font =  UIFont(name: "Helvetica Neue", size: 22)
        uploadBtn.contentHorizontalAlignment = .left

        uploadBtn.addTarget(self, action: #selector(uploadBtnAction), for: .touchUpInside)
        uploadBtn.tag = section
        
        let uploadBtnImage = UIImageView(frame: CGRect(x: UIScreen.main.bounds.width - 60, y: label.frame.origin.y + label.frame.size.height + 15, width: 29, height: 20)) // label.frame.origin.x + size.width + 170
        uploadBtnImage.image = #imageLiteral(resourceName: "upload")
        uploadBtnImage.tag = section
        
        let line = UIView(frame: CGRect(x: 25, y: uploadBtn.frame.origin.y + uploadBtn.frame.size.height + 6, width: UIScreen.main.bounds.width - 50, height: 1))
        
        line.backgroundColor = #colorLiteral(red: 0.8587478995, green: 0.8588719964, blue: 0.858720839, alpha: 1)
        line.tag = section
        
        
        
        headerView!.addSubview(label)
        headerView!.addSubview(uploadBtn)
        headerView!.addSubview(uploadBtnImage)
        headerView!.addSubview(line)

        
        
        
        if section == 0 {
           
            if addinfoProfileObjc.frontID != "" {
                
                uploadBtn.isHidden =  true
                uploadBtnImage.isHidden =  true
                line.isHidden =  true


            
            } else {
                
                uploadBtn.isHidden =  false
                uploadBtnImage.isHidden =  false
                line.isHidden =  false

                
            }
            
        } else if section == 1 {
            
            if addinfoProfileObjc.backID != "" {
                
                uploadBtn.isHidden =  true
                uploadBtnImage.isHidden =  true
                line.isHidden =  true


            
            } else {
                
                uploadBtn.isHidden =  false
                uploadBtnImage.isHidden =  false
                line.isHidden =  false

                
            }
            
        } else if section == 2 {
            
            if addinfoProfileObjc.passID != "" {
                
                uploadBtn.isHidden =  true
                uploadBtnImage.isHidden =  true
                line.isHidden =  true


            
            } else {
                
                uploadBtn.isHidden =  false
                uploadBtnImage.isHidden =  false
                line.isHidden =  false

                
            }
            
        }
        
        headerView!.tag = section
        headerView!.isUserInteractionEnabled = true
           
        return headerView
        
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
         
         let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 2))
         
         return headerView
         
     }
    
    func tableViewExpandSection(_ section: Int, imageView: UIImageView) {
           let sectionData = self.sectionArray
           if (sectionData.count == 0) {
               self.expandedSectionHeaderNumber = -1;
               
               return;
           } else {
               UIView.animate(withDuration: 0.4, animations: {
                   imageView.transform = CGAffineTransform(rotationAngle: (180.0 * CGFloat(Double.pi)) / 180.0)
               })
               var indexesPath = [IndexPath]()
               for i in 0 ..< sectionData.count {
                   let index = IndexPath(row: i, section: section)
                   indexesPath.append(index)
               }
               self.expandedSectionHeaderNumber = section
               self.addInfoTableView!.beginUpdates()
               self.addInfoTableView!.insertRows(at: indexesPath, with: UITableView.RowAnimation.fade)
               self.addInfoTableView!.endUpdates()
           }
       }
       
       func tableViewCollapeSection(_ section: Int, imageView: UIImageView) {
           let sectionData = self.sectionArray[section]
           
           self.expandedSectionHeaderNumber = -1;
           if (sectionData.count == 0) {
               return;
           } else {
               UIView.animate(withDuration: 0.4, animations: {
                   imageView.transform = CGAffineTransform(rotationAngle: (0.0 * CGFloat(Double.pi)) / 180.0)
               })
               var indexesPath = [IndexPath]()
               for i in 0 ..< sectionData.count {
                   let index = IndexPath(row: i, section: section)
                   indexesPath.append(index)
               }
               self.addInfoTableView!.beginUpdates()
               self.addInfoTableView!.deleteRows(at: indexesPath, with: UITableView.RowAnimation.fade)
               self.addInfoTableView!.endUpdates()
           }
       }
    
    
    
     @objc func uploadBtnAction(sender: UIButton!) {

        
        if sender.tag == 0 || sender.tag == 1 || sender.tag == 2 {
            
            self.uploadTag = sender.tag
            singlePicker()

    
//          if let sectionHeader = headerView {
//
//            let headerHeight:CGFloat
//
//
//            headerHeight = 30.0
//
//
//            UIView.animate(withDuration: 0.3, animations: {
//                self.addInfoTableView?.beginUpdates()
//                sectionHeader.frame.size.height = headerHeight
//                self.addInfoTableView?.endUpdates()
//            } )
//
//
//            if sender.tag == 0 {
//
//                addinfoProfileObjc.frontID = "0"
//                addinfoProfileObjc.qtr_front_id = ""
//
//
//            } else if sender.tag == 1 {
//
//                addinfoProfileObjc.backID = "1"
//                addinfoProfileObjc.qtr_back_id = ""
//
//
//
//            }else if sender.tag == 2 {
//
//                addinfoProfileObjc.passID = "2"
//                addinfoProfileObjc.passport = ""
//
//
//            }
//
//
//        }
            

            
        }
        
        
        
       // addInfoTableView.reloadData()
        
        
        
    }
    
    
    func addImage() {
        
          if let sectionHeader = headerView {
            
            let headerHeight:CGFloat
            
            
            headerHeight = 30.0
            
            
            UIView.animate(withDuration: 0.3, animations: {
                self.addInfoTableView?.beginUpdates()
                sectionHeader.frame.size.height = headerHeight
                self.addInfoTableView?.endUpdates()
            } )
            
            
            if uploadTag == 0 {
                
                addinfoProfileObjc.frontID = "0"
                addinfoProfileObjc.qtr_front_id = ""

                
            } else if uploadTag == 1 {
                
                addinfoProfileObjc.backID = "1"
                addinfoProfileObjc.qtr_back_id = ""

                
                
            }else if uploadTag == 2 {
                
                addinfoProfileObjc.passID = "2"
                addinfoProfileObjc.passport = ""

                
            }
            
            
        }
        
        addInfoTableView.reloadData()

        
        
    }
    
    // MARK:- UIDocumentPickerViewController Delegates
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        print(urls)
        self.index = 0
        self.assets.removeAll()
        self.urlsAarray.removeAll()
        var getSizeChk = Bool()
        if urls.count > 0 {
            
            
            for i in urls {
                self.urlsAarray.append(i)

            }

            
        }
        else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("Cancel")
    }
    
}








//MARK:- Image Picker
//extension AdditionalInfoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//
//
//
//    //Show alert to selected the media source type.
//    private func showAlert() {
//
//        let alert = UIAlertController(title: "Image Selection", message: "From where you want to pick this image?", preferredStyle: .actionSheet)
//        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action: UIAlertAction) in
//            self.getImage(fromSourceType: .camera)
//        }))
//        alert.addAction(UIAlertAction(title: "Photo Album", style: .default, handler: {(action: UIAlertAction) in
//            self.getImage(fromSourceType: .photoLibrary)
//        }))
//        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
//        self.present(alert, animated: true, completion: nil)
//    }
//
//    //get image from source type
//    private func getImage(fromSourceType sourceType: UIImagePickerController.SourceType) {
//
//        //Check is source type available
//        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
//
//            let imagePickerController = UIImagePickerController()
//            imagePickerController.delegate = self
//            imagePickerController.sourceType = sourceType
//            self.present(imagePickerController, animated: true, completion: nil)
//        }
//    }
//
//    //MARK:- UIImagePickerViewDelegate.
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//
//        self.dismiss(animated: true) { [weak self] in
//
//            guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
//            //Setting image to your image view
//            self?.profileImgView.image = image
//        }
//    }
//
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        picker.dismiss(animated: true, completion: nil)
//    }
//
//}

extension AdditionalInfoViewController: AssetsPickerViewControllerDelegate {

    
    func assetsPickerCannotAccessPhotoLibrary(controller: AssetsPickerViewController) {
        
    }
    
    func assetsPickerDidCancel(controller: AssetsPickerViewController) {
        
    }
    
    
    func assetsPicker(controller: AssetsPickerViewController, didDismissByCancelling byCancel: Bool) {
        print("dismiss \(byCancel)")
        if !byCancel {
            let assets = self.assets
            self.urlsAarray.removeAll()
            self.assets.removeAll()
            var getSizeChk = Bool()

            
        

            for i in assets {
                
                if i.mediaType == .image {
                let resources = PHAssetResource.assetResources(for: i) // your PHAsset

               
                
//                self.assets.append(i)
//                let image =    self.getAssetThumbnail(asset: i)
//                self.imageArray.append(image)
//                self.totlaImageArray.append(image)
                    
                    

                    var sizeOnDisk: Int64? = 0

                    if let resource = resources.first {
                        let unsignedInt64 = resource.value(forKey: "fileSize") as? CLong
                        sizeOnDisk = Int64(bitPattern: UInt64(unsignedInt64!))
                        print(sizeOnDisk!)
                        let sizeInMb:Float = (Float(sizeOnDisk!)/Float(1024))/Float(1024)
                        if maxUploadSize.isEmpty {
                            
                            maxSize = 5
                            
                        } else {
                            
                        let sizeStr = maxUploadSize.dropLast(2)
                        maxSize = Float(String(sizeStr))!
                            
                        }
                        
                        if sizeInMb < 5 || sizeInMb == 5 {
                            self.assets.append(i)
                            let image =  self.getAssetThumbnail(asset: i)
                            self.imageArray.append(image)
                            self.totlaImageArray.append(image)
                            
                            
                            
                            
                        }
                        else {
                            getSizeChk = true
                        }
                        print(sizeInMb)
                    }
                    
                    
                    


                    
                } else {
                    
                  
                }
              
            }
            
            if getSizeChk {
                
                if maxUploadSize.isEmpty {
                    
                    maxUploadSize = "5 MB"
                }

                let alertController = UIAlertController(title:"Message", message:"Some of the files size is greater than \(maxUploadSize)", preferredStyle: .alert)
                let okAction =  UIAlertAction(title:"OK", style:.default) { (action) in

                }
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)

            }
            
           self.mediaCollectionView.reloadData()
            
           //  self.uploadPopup()
            //  self.sendData()
        }
        
    }
    
    
    
    func assetsPicker(controller: AssetsPickerViewController, selected assets: [PHAsset]) {
        // do your job with selected assets
        
        self.index = 0
        self.assets = assets
        print(assets.count)
        
        
        if addinfoProfileObjc.additional_info.count > 0 {
            let totalCount =  9 - self.addinfoProfileObjc.additional_info.count
            
            
            if assets.count > totalCount {
                
                
                let proCount  = assets.count - totalCount
                //for i in 0...proCount - 1 {
                    
                    if self.addinfoProfileObjc.additional_info.count > 0 {
                        
                        
                        self.imageArray.removeSubrange(0...proCount - 1)
                        self.addinfoProfileObjc.additional_info.removeSubrange(0...proCount - 1)
//                        self.addinfoProfileObjc.additional_info.remove(at: i)
//                        self.imageArray.remove(at: i)
                        
                    }
                    
                    
               // }
                
                print(self.imageArray)
                print(self.addinfoProfileObjc.additional_info)

                
            }
            
        }
        
        
        if addinfoProfileObjc.additional_info.count == 0 {
        
        if imageArray.count > 0 {
           
            let remCount = 9 - imageArray.count
            
            if   assets.count >   remCount {
                
                let procount = assets.count - remCount
                //for i in 0...procount - 1 {
                    
                    if self.imageArray.count > 0 {
                        
                        self.imageArray.removeSubrange(0...procount - 1)
                        self.totlaImageArray.removeSubrange(0...procount - 1)

//                        self.imageArray.remove(at: i)
//                        self.totlaImageArray.remove(at: i)
                        
                        
                        
                    }
                    
                    
               // }
                
            }
            
        }
        
    }
        
        
        
//        for i in assets {
//
//            self.assets.append(i)
//            let image =    self.getAssetThumbnail(asset: i)
//            self.totlaImageArray.append(image)
//
//
//        }
        
        
        print(self.addinfoProfileObjc.additional_info)
        print(self.imageArray)

        
    }
    
    func assetsPicker(controller: AssetsPickerViewController, shouldSelect asset: PHAsset, at indexPath: IndexPath) -> Bool {
        
        if controller.selectedAssets.count > 8 {
            // do your job here
            
            print(controller.selectedAssets.count)
            ProjectManager.sharedInstance.showAlertwithTitle(title: "Alert", desc: "Youn can select upto 9 images", vc: self)
            
            return false
        }
        
        return true
    }
    
    func assetsPicker(controller: AssetsPickerViewController, didSelect asset: PHAsset, at indexPath: IndexPath) {
        
    }
    
    func assetsPicker(controller: AssetsPickerViewController, shouldDeselect asset: PHAsset, at indexPath: IndexPath) -> Bool {
        
        return true
        
    }
    func assetsPicker(controller: AssetsPickerViewController, didDeselect asset: PHAsset, at indexPath: IndexPath) {}

    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        self.dismiss(animated: true) { [weak self] in
            
            guard (info[UIImagePickerController.InfoKey.originalImage] as? UIImage) != nil else { return }
         
            let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            
            if self?.uploadTag == 0 {
                
                self?.frontIDData = image.jpegData(compressionQuality: 0.1)!
                self?.addinfoProfileObjc.qtr_front_id = ""    //"0"
                self?.frontImage = image
                
                self?.addImage()
                
                
                
                
                
                
                
                
                
                
                //self?.addInfoTableView.reloadData()

                
                
            } else if self?.uploadTag == 1 {
                
                self?.backIDData = image.jpegData(compressionQuality: 0.1)!
                self?.addinfoProfileObjc.qtr_back_id = "" // "1"
                self?.backImage = image
                
                self?.addImage()

                //self?.addInfoTableView.reloadData()


                
//                let index = NSIndexPath(row:0, section: 1)
//                let cell = self!.addInfoTableView.cellForRow(at: index as IndexPath) as! AdditionalInfoTableViewCell
//
//                cell.cellImageView.image = image
                
            } else if self?.uploadTag == 2 {
                
                self?.passportData = image.jpegData(compressionQuality: 0.1)!
                self?.addinfoProfileObjc.passport = ""    //"2"
                self?.passImage = image
                
                self?.addImage()

                
               // self?.addInfoTableView.reloadData()


                
//                let index = NSIndexPath(row:0, section: 2)
//                let cell = self!.addInfoTableView.cellForRow(at: index as IndexPath) as! AdditionalInfoTableViewCell
//
//                cell.cellImageView.image = image
                
            } else {
                
//
                
                
                var sizeCheck = Bool()
                let imageData = image.jpegData(compressionQuality: 0.1)
                let length = imageData?.count
                let sizeInMb:Float = (Float(length!)/Float(1024))/Float(1024)
                
                if self!.maxUploadSize.isEmpty {
                    
                    self!.maxSize = 5
                    
                } else {
                    
                    let sizeStr = self!.maxUploadSize.dropLast(2)
                    self!.maxSize = Float(String(sizeStr))!
                    
                }
                
                if sizeInMb < self!.maxSize || sizeInMb == self!.maxSize {
                    
                    self?.imageArray.append(image)
                    self?.totlaImageArray.append(image)
                    
                    if (self?.selectedIndexArray.contains(self!.selectedIndex))! {
                        
                        
                    } else {
                        
                        self?.selectedIndexArray.append(self!.selectedIndex)
                        
                    }
                    
                    let index = NSIndexPath(row: self!.selectedIndex, section: 0)
                    let cell = self!.mediaCollectionView.cellForItem(at: index as IndexPath) as! AdditionalInfoCollectionViewCell
                    
                    cell.imageView.image = image
                    
                    
                    
                }  else {
                    
                    sizeCheck = true
                }
                
                if sizeCheck {

                    if self!.maxUploadSize.isEmpty {
                        
                        self!.maxUploadSize = "5 MB"
                    }
                    
                    let alertController = UIAlertController(title:"Message", message:"Some of the files size is greater than \(self!.maxUploadSize)", preferredStyle: .alert)
                    let okAction =  UIAlertAction(title:"OK", style:.default) { (action) in

                    }
                    alertController.addAction(okAction)
                    self!.present(alertController, animated: true, completion: nil)

                }
                
                
                
                
                
                
                
                
//
//                self?.imageArray.append(image)
//                self?.totlaImageArray.append(image)
//
//                if (self?.selectedIndexArray.contains(self!.selectedIndex))! {
//
//
//                } else {
//
//                    self?.selectedIndexArray.append(self!.selectedIndex)
//
//                }
//
//                let index = NSIndexPath(row: self!.selectedIndex, section: 0)
//                let cell = self!.mediaCollectionView.cellForItem(at: index as IndexPath) as! AdditionalInfoCollectionViewCell
//
//            cell.imageView.image = image
                
                
                
                
                
            }
            
            
            
            //self?.mediaCollectionView.reloadData()
        }
    }
    
//  func imagePickerController(_ picker: UIImagePickerController?, didFinishPicking image: UIImage?, info: [AnyHashable : Any]?) {
//
//
//         self.dismiss(animated: true) { [weak self] in
//
//             guard (info[UIImagePickerController.InfoKey.originalImage] as? UIImage) != nil else { return }
//             //Setting image to your image view
//             //self?.profileImgView.image = image
//         }
//     }
   
    

    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}

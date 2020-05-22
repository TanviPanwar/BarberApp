//
//  RegisterAsBarberController.swift
//  BarberApp
//
//  Created by iOS8 on 19/03/20.
//  Copyright © 2020 iOS8. All rights reserved.
//

import UIKit

class RegisterAsBarberController: UIViewController {
    
    var freelanceBool = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func backAction(_ sender: Any) {
        //self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
   
    @IBAction func registerAsFreelance(_ sender: Any) {
        
        var vc = CompleteProfileViewController()
        
        if #available(iOS 13.0, *) {
            
            vc = mainStoryBoard.instantiateViewController(identifier:"CompleteProfileViewController") as! CompleteProfileViewController
            
        } else {
            // Fallback on earlier versions
            
             vc = mainStoryBoard.instantiateViewController(withIdentifier:"CompleteProfileViewController") as! CompleteProfileViewController

        }
        
           freelanceBool = true
           vc.freelanceBool = freelanceBool
          self.present(vc, animated: true, completion: nil)
        
    }
    @IBAction func registerAsSaloonBarberAction(_ sender: Any) {
        
        let alertController =  UIAlertController(title:"Barbershop" , message: "Is your barbershop already registered on IHLAQ app or would you like to register your barbershop?", preferredStyle: .alert)
        let homeAction = UIAlertAction(title:"Search Existing", style: .default) { (action) in
            
            var vc = SelectBarbershopController()
            
            if #available(iOS 13.0, *) {
                 vc = homeStoryBoard.instantiateViewController(identifier:"SelectBarbershopController") as! SelectBarbershopController
                
            } else {
                // Fallback on earlier versions
                
                vc = homeStoryBoard.instantiateViewController(withIdentifier:"SelectBarbershopController") as! SelectBarbershopController
                
                
            }
            
            self.present(vc, animated: true, completion: nil)
        }
        let saloonAction = UIAlertAction(title:"New Barbershop", style: .default) { (action) in
            
             var vc = RegisterBarberShopController()
            
            if #available(iOS 13.0, *) {
                
               vc = homeStoryBoard.instantiateViewController(identifier:"RegisterBarberShopController") as! RegisterBarberShopController
                
            } else {
                // Fallback on earlier versions
                
                   vc = homeStoryBoard.instantiateViewController(withIdentifier:"RegisterBarberShopController") as! RegisterBarberShopController
                
            }
            
            self.freelanceBool = false
            self.present(vc, animated: true, completion: nil)

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

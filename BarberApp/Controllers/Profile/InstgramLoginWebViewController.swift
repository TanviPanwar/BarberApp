//
//  InstgramLoginWebViewController.swift
//  BarberApp
//
//  Created by iOS6 on 27/04/20.
//  Copyright © 2020 iOS8. All rights reserved.
//

import UIKit
import WebKit
import Alamofire

class InstgramLoginWebViewController: UIViewController, WKNavigationDelegate, WKUIDelegate, UIWebViewDelegate {
    
    
    @IBOutlet weak var loginWebView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loginWebView.navigationDelegate = self
        //loginWebView.uiDelegate = self
        
        unSignedRequest()


    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    //MARK: - unSignedRequest
    
       func unSignedRequest () {
        
        let authURL = String(format: "%@?client_id=%@&redirect_uri=%@&scope=%@&response_type=code", arguments: [INSTAGRAM_IDS.INSTAGRAM_AUTHURL,INSTAGRAM_IDS.INSTAGRAM_CLIENT_ID, INSTAGRAM_IDS.INSTAGRAM_REDIRECT_URI, INSTAGRAM_IDS.INSTAGRAM_SCOPE])
           let urlRequest =  URLRequest.init(url: URL.init(string: authURL)!)
            loginWebView.load(urlRequest)
       }

       func checkRequestForCallbackURL(request: URLRequest) -> Bool {
           
           let requestURLString = (request.url?.absoluteString)! as String
           
           if requestURLString.hasPrefix(INSTAGRAM_IDS.INSTAGRAM_REDIRECT_URI) {
               let range: Range<String.Index> = requestURLString.range(of: "#access_token=")!
               handleAuth(authToken: requestURLString.substring(from: range.upperBound))
               return false;
           }
           return true
       }
       
       func handleAuth(authToken: String)  {
           print("Instagram authentication token ==", authToken)
        
       instagramCode = String(authToken.dropLast(2))
       
        self.dismiss(animated: true, completion: {
            
            ProjectManager.sharedInstance.tokenDelegate?.getAccessToken(code: instagramCode)
        })
        
        
       }
    
    
    //MARK:- WebView Delegates
    
    private func webView(_ webView: WKWebView, shouldStartLoadWith request: URLRequest, navigation: WKNavigation!) -> Bool {
        
           return checkRequestForCallbackURL(request: request)
       }
    
    
    func webView(_ webView: WKWebView, didFinish navigation:
           WKNavigation!) {
        
           ProjectManager.sharedInstance.stopLoader()
       }
       
       func webView(_ webView: WKWebView, didStartProvisionalNavigation
           navigation: WKNavigation!) {
    
            ProjectManager.sharedInstance.showLoader(vc: self)
       }
       
       func webView(_ webView: WKWebView, didFail navigation:
           WKNavigation!, withError error: Error) {
        
          ProjectManager.sharedInstance.stopLoader()
        
       }
    
    
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {

       let urlString = navigationAction.request.url!.absoluteString
        guard let range = urlString.range(of: "code=") else {
            decisionHandler(.allow)
            return
        }




        decisionHandler(.cancel)
        

        DispatchQueue.main.async {
            self.handleAuth(authToken: urlString.substring(from: range.upperBound))
        }
        
        //return
        
        //decisionHandler(.allow)



    }

    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationResponse: WKNavigationResponse,
                 decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {

        guard let httpResponse = navigationResponse.response as? HTTPURLResponse else {
            decisionHandler(.allow)
            return
        }

        switch httpResponse.statusCode {
        case 400:
            decisionHandler(.cancel)
            DispatchQueue.main.async {
                //self.failure?(InstagramError.badRequest)
                
                
            }
        default:
            decisionHandler(.allow)
        }
    }

    

}

//
//  LoginViewController.swift
//  studyBuddy
//
//  Created by Adhyyan Narang on 4/30/17.
//  Copyright © 2017 Adhyyan Narang. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var username: UITextField!

    @IBOutlet weak var password: UITextField!
    
     @IBAction func signIn(_ sender: Any) {
        let parameters: [String: Any] = [
            "username": username.text ?? "null",
            "password": password.text ?? "null"
        ]
        
        Alamofire.request("https://library-adhyyan.herokuapp.com/api/authenticate", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { response in
                switch response.result {

                case .success(let value):
                    let json = JSON(value)
                    let path: JSONSubscriptType = "success"
                    let required = json[path].boolValue
                    if (json[path].boolValue) {
                        let path: JSONSubscriptType = "token"
                        KeychainService.savePassword(token: json[path].stringValue as NSString)
                        self.performSegue(withIdentifier: "confirmedSignIn", sender: self)
                    }else{
                        let displayMessage = json["message"].stringValue
                        let notificationAlert = UIAlertController(title: "Login Error!", message: displayMessage as! String?, preferredStyle: UIAlertControllerStyle.alert)
                        notificationAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
                        self.present(notificationAlert, animated: true, completion: nil)
                    }
                case .failure(let error):
                    print(error)
                    
                }
                
        }
        
     }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func goToSignUp(_ sender: Any) {
        self.performSegue(withIdentifier: "toSignInView", sender: self)
    }
    

}

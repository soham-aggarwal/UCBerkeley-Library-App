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
        
        Alamofire.request("http://library-adhyyan.herokuapp.com/api/authenticate", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { response in
                print(response)
                let json = JSON(response)
                let userToken = json["token"].string
                let user = User()
                user.token = userToken
                if (json["success"].boolValue){
                    self.performSegue(withIdentifier: "confirmedSignIn", sender: self)
                } else{
                    let notificationAlert = UIAlertController(title: "Login Error", message: json["message"].string, preferredStyle: UIAlertControllerStyle.alert)
                    notificationAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
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
    

}

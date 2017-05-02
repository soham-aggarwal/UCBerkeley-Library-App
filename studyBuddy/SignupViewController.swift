//
//  SignupViewController.swift
//  studyBuddy
//
//  Created by Adhyyan Narang on 4/30/17.
//  Copyright © 2017 Adhyyan Narang. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SignupViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBOutlet weak var name: UITextField!
    
    @IBOutlet weak var username: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBAction func signUpButton(_ sender: Any) {
        
        let parameters: [String: Any] = [
            "name": name.text ?? "null",
            "username": username.text ?? "null",
            "password": password.text ?? "null"
        ]
        Alamofire.request("http://library-adhyyan.herokuapp.com/api/users", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { response in
                print(response)
                let json = JSON(response)
                var x = 3
                let userToken = json["token"].string
                var user = User()
                user.token = userToken
                if (x == 1 /*correctly uploaded */){
                    self.performSegue(withIdentifier: "toPreferences", sender: self)
                } else{
                    let notificationAlert = UIAlertController(title: "Sign Up Error", message: json["message"].string, preferredStyle: UIAlertControllerStyle.alert)
                    notificationAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
                }
        }
        
    }
    
    
    
    

}

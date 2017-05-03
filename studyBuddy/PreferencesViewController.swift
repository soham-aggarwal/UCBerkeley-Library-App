//  ViewController.swift
//  studyBuddy
//
//  Created by Adhyyan Narang on 4/13/17.
//  Copyright © 2017 Adhyyan Narang. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import SwiftyJSON


class PreferencesViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var email = ""
    var username = ""
    var password = ""
    @IBOutlet weak var music: UITextField!
    
    @IBOutlet weak var doe: UITextField!
    
    @IBOutlet weak var kresge: UITextField!
    
    @IBOutlet weak var eshleman: UITextField!
    
    @IBOutlet weak var environmental: UITextField!
    
    @IBOutlet weak var mlkb: UITextField!
    
    @IBOutlet weak var mlku: UITextField!
    
    @IBAction func finishSigningUp(_ sender: Any) {
        let parameters: [String:Any] = [
            "email": email,
            "username": username,
            "password": password,
            "preferences": [
                "EngineeringLibrary": kresge.text ?? "",
                "EshlemanGroundFloor": eshleman.text ?? "",
                "EnvironmentalDesignLibrary" : environmental.text ?? "",
                "MusicLibrary": music.text ?? "",
                "MLKLowerStudyArea": mlkb.text ?? "",
                "MLKUpperStudyArea": mlku.text ?? "",
                "DoeNorthReadingRoom": doe.text ?? ""
            ]
        ]
        //let headers: HTTPHeaders = ["x-access-token": KeychainService.loadPassword() as! String]
        Alamofire.request("https://library-adhyyan.herokuapp.com/api/users", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON {response in
                switch response.result {
                case .success(let value):
                    
                    print(response.result.value)
                    let json = JSON(value)
                    let path: JSONSubscriptType = "success"
                    let required = json[path].boolValue
                    if (json[path].boolValue){
                        print("Hello")
                        self.performSegue(withIdentifier: "reSign", sender: self)
                    }else{
                        let displayMessage = json["message"].stringValue
                        let notificationAlert = UIAlertController(title: "Sign Up Error!", message: displayMessage as! String?, preferredStyle: UIAlertControllerStyle.alert)
                        notificationAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
                        self.present(notificationAlert, animated: true, completion: nil)
                    }
                case .failure(let error):
                    print("This is response")
                    print(response.result.value)
                    print(error)
                    
                }
        }
    }
    
    
    
    
}


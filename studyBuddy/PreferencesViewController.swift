//  ViewController.swift
//  studyBuddy
//
//  Created by Adhyyan Narang on 4/13/17.
//  Copyright © 2017 Adhyyan Narang. All rights reserved.
//

import UIKit
import Foundation
import Alamofire

class PreferencesViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBOutlet weak var moffitt: UITextField!
    
    @IBOutlet weak var doe: UITextField!
    
    @IBOutlet weak var kresge: UITextField!
    
    @IBOutlet weak var eshleman: UITextField!
    
    @IBOutlet weak var environmental: UITextField!
    
    @IBOutlet weak var mlkb: UITextField!
    
    @IBOutlet weak var mlku: UITextField!
    
    @IBAction func finishSigningUp(_ sender: Any) {
        let parameters: [String:Any] = [
            "moffitt": moffitt.text ?? "",
            "doe": doe.text ?? "",
            "kresge": kresge.text ?? "",
            "eshleman": eshleman.text ?? "",
            "environmental library" : environmental.text ?? "",
            "mlkb": mlkb.text ?? "",
            "mlku": mlku.text ?? ""
        ]
        
        Alamofire.request("https://library-adhyyan.herokuapp.com/api/users", method: .put, parameters: ["preferences": parameters], encoding: JSONEncoding.default, headers: nil)
            .responseJSON { response in
                print(response.request as Any)  // original URL request
                print(response.response as Any) // URL response
                print(response.result.value as Any)   // result of response serialization
        }
            self.performSegue(withIdentifier:"toRecommendation", sender: self)
    
    }
    
    
    
    
}


//
//  PreferencesViewController.swift
//  studyBuddy
//
//  Created by Soham Aggarwal on 5/2/17.
//  Copyright © 2017 Adhyyan Narang. All rights reserved.
//

import UIKit
import Foundation

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
        
        Alamofire.request(.PUT, "https://library-adhyyan.herokuapp.com/api/users/put", parameters:parameters)
            .response { (request, response, data, error) in
                println(request)
                println(response)
                println(error)
        }
    }
    
    
    
    
}

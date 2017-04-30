//
//  RecommendationMainViewController.swift
//  studyBuddy
//
//  Created by Adhyyan Narang on 4/30/17.
//  Copyright © 2017 Adhyyan Narang. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire


class RecommendationMainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var LibraryTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LibraryTableView.dataSource = self;
        LibraryTableView.delegate = self;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var retVal = 1;
        
        Alamofire.request("https://library-adhyyan.herokuapp.com/api/libraries", method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                retVal = json.count
            case .failure(let error):
                print(error)
            }
        }
        return retVal;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "libraryCell", for: indexPath) as! RecommendationTableViewCell
        Alamofire.request("https://library-adhyyan.herokuapp.com/api/libraries", method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let path: [JSONSubscriptType] = [indexPath.item, "name"]
                cell.libraryLabel.text = json[path].stringValue
            case .failure(let error):
                print(error)
            }
        }
        return cell;
    }
    
    /*
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

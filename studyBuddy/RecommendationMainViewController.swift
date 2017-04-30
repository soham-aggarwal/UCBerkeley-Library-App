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
    var retVal: Int?
    var selectedIndexPath: IndexPath?
    
    
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
        
        var size: Int = 2;
        
        Alamofire.request("https://library-adhyyan.herokuapp.com/api/libraries", method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                size = json.arrayValue.count
                self.retVal = json.arrayValue.count
            case .failure(let error):
                print(error)
            }
        }
        return size
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
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        performSegue(withIdentifier: "recommendationToInfo", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "recommendationToInfo" {
            if let destinationVC = segue.destination as? LibraryInfoViewController {
                Alamofire.request("https://library-adhyyan.herokuapp.com/api/libraries", method: .get).validate().responseJSON { response in
                    switch response.result {
                    case .success(let value):
                        let json = JSON(value)
                        let namePath: [JSONSubscriptType] = [self.selectedIndexPath!.item, "name"]
                        let descriptionPath:  [JSONSubscriptType] = [self.selectedIndexPath!.item, "description"]
                        let imagePath:[JSONSubscriptType] = [self.selectedIndexPath!.item, "image_url"]
                        destinationVC.nameLabel.text = json[namePath].stringValue
                        destinationVC.descriptionLabel.text = json[descriptionPath].stringValue
                        if let url = NSURL(string: json[imagePath].stringValue) {
                            if let data = NSData(contentsOf: url as URL) {
                                destinationVC.libraryImage.image = UIImage(data: data as Data)
                            }
                        }
                    case .failure(let error):
                        print(error)
                    }
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
}

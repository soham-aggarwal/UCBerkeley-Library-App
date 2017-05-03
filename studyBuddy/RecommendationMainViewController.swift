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
import CoreLocation


class RecommendationMainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var LibraryTableView: UITableView!
    var retVal: Int?
    var selectedIndexPath: IndexPath?
    var libModel: LibrariesModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        libModel = LibrariesModel.init()
        libModel!.table = LibraryTableView
        LibraryTableView.dataSource = self;
        LibraryTableView.delegate = self;
        if (!CLLocationManager.locationServicesEnabled()) {
            let alertController = UIAlertController(
                title: "Background Location Access Disabled",
                message: "In order to ____, please open Settings and set location access for this app to When in Use",
                preferredStyle: .alert)
            let openAction = UIAlertAction(title: "Open Settings",
                                           style: .default) { (action) in
                                            if let url = NSURL(string: UIApplicationOpenSettingsURLString) {
                                                UIApplication.shared.open(url as URL,
                                                                          options: [:],
                                                                          completionHandler: nil)
                                            }
            }
            alertController.addAction(openAction)
            let cancelAction = UIAlertAction(title: "Cancel",
                                             style: .cancel,
                                             handler: nil)
            alertController.addAction(cancelAction)
            self.present(alertController,
                         animated: true,
                         completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
        
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (libModel!.bestThree.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "libraryCell", for: indexPath) as! RecommendationTableViewCell
        cell.libraryLabel.text = libModel?.bestThree[indexPath.item].name!
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        performSegue(withIdentifier: "recommendationToInfo", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "recommendationToInfo" {
            if let destinationVC = segue.destination as? LibraryInfoViewController {
                let selectedLibrary = libModel!.bestThree[selectedIndexPath!.item]
                destinationVC.nameLabel.text = selectedLibrary.name!
                destinationVC.descriptionLabel.text = selectedLibrary.description!
                if let url = NSURL(string: selectedLibrary.image_url!) {
                    if let data = NSData(contentsOf: url as URL) {
                        destinationVC.libraryImage.image = UIImage(data: data as Data)
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

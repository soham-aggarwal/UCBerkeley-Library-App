//  Libraries.swift
//  studyBuddy
//
//  Created by Adhyyan Narang on 4/30/17.
//  Copyright © 2017 Adhyyan Narang. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import CoreLocation

class LibrariesModel: NSObject {
    
    struct Library {
        var name: String?
        var index: Int?
        var preference: Int?
        var open: Bool?
        var latitude: String?
        var longitude: String?
        var distance: Double?
        var percentageFull: Int?
        var totalScore: Int?
        
        
        init(name:String, index: Int) {
            self.name = name
            self.index = index
        }
    }
    
    var allLibraryOptions: [Library] = []
    var bestThree: [Library] = []
    let manager = CLLocationManager()

    
    //Now we need to fill up the allLibraryOptions variable.
    
    /* Make the API call to my API to get the names inside the initializer. Then inside the completion handler, call my API to getPreferences(). Then, inside the completion handler, make a function call to getDistance(). Inside the completion handler for getDistance(), make a function call to getPercentage(). Now all the information has been obtained and I can safely perform my algorithm.
     */
    
    override init() {
        Alamofire.request("https://library-adhyyan.herokuapp.com/api/libraries", method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let number = json.arrayValue.count
                for i in 0...number {
                    let namePath: [JSONSubscriptType] = [i, "name"]
                    let indexPath: [JSONSubscriptType] = [i, "index"]
                    let libraryOptionName = Library(
                        name: json[namePath].stringValue,
                        index: json[indexPath].intValue
                    )
                    self.allLibraryOptions.append(libraryOptionName)
                }
                self.getPreferences()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getPreferences() -> Void {
        let reqUrl: String = "https://library-adhyyan.herokuapp.com/api/users/" + GlobalVar.id
        Alamofire.request(reqUrl, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let number = json.arrayValue.count
                for i in 0...number {
                    let path: [JSONSubscriptType] = ["preferences", self.allLibraryOptions[i].name!]
                    let prefNumber = json[path].intValue
                    self.allLibraryOptions[i].preference = prefNumber
                    
                }
                self.getDistances()
            case .failure(let error):
                print(error)
            }
        }
    }
    

    
    func getOpenAndPercentage(){
        Alamofire.request("https://api.packd.org/locations/", method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                for i in 0..<self.allLibraryOptions.count {
                    let library: Library = self.allLibraryOptions[i]
                    let openPath: [JSONSubscriptType] = [library.index!, "is_open"]
                    let percentagePath: [JSONSubscriptType] = [library.index!, "current_percent"]
                    let latitudePath: [JSONSubscriptType] = [library.index!, "lat"]
                    let longituePath: [JSONSubscriptType] = [library.index!, "lon"]
                    self.allLibraryOptions[i].open = json[openPath].boolValue
                    self.allLibraryOptions[i].percentageFull = json[percentagePath].intValue
                    self.allLibraryOptions[i].latitude = json[openPath].stringValue
                    self.allLibraryOptions[i].longitude = json[percentagePath].stringValue
                }
                self.getDistances()
            case .failure(let error):
                print(error)
            }
        }
    }

    func getDistances() -> Void {
        //manager.delegate = self.manager
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
                                             style: .ctancel,
                                             handler: nil)
            alertController.addAction(cancelAction)
            self.present(alertController,
                         animated: true,
                         completion: nil)
        } else {
            for i in 0..<self.allLibraryOptions.count {
                let mylocation = manager.location
                let libLat = allLibraryOptions[i].latitude //Get value of lat
                let libLon = allLibraryOptions[i].longitude  //Get value of lon
                var dLati = 0.0
                var dLong = 0.0
                if let lat = libLat {
                    dLati = (lat as NSString).doubleValue
                }
                if let lon = libLon{
                    dLong = (lon as NSString).doubleValue
                }
                let libLocation = (CLLocation).init(latitude: dLati, longitude: dLong)
                let distance = mylocation?.distance(from: libLocation)
                allLibraryOptions[i].distance = distance
            }
            
        }
        
    }
    
    func recommendThree() -> [Library] {
        //first iterate through all and eliminate all those which are not open or have <20% open seats.
        var finalOptions : [Library] = []
        for library in allLibraryOptions {
            if (library.open! && library.percentageFull! < 80) {
                finalOptions.append(library)
            }
        }
        //Then scale the distances to 10
        let max: Double = findmax()
        let scalingFactor = 10/max
        for i in 0...(finalOptions.count - 1) {
            let library: Library = finalOptions[i]
            finalOptions[i].distance = library.distance! * scalingFactor
        }
        //Then put values into totalscore based on these two rankings.
        for var library in finalOptions {
            library.totalScore = Int(library.distance!) +  library.preference!
        }
        bestThree.append(finalOptions[0])
        var min: Int = 25
        for library in finalOptions {
            if (library.totalScore! < min) {
                min = library.totalScore!
                bestThree[0] = library
            }
        }
        bestThree.append(finalOptions[0])
        min = 25
        for library in finalOptions {
            if (library.totalScore! < min && library.totalScore! > bestThree[0].totalScore!) {
                min = library.totalScore!
                bestThree[0] = library
            }
        }
        bestThree.append(finalOptions[0])
        min = 25
        for library in finalOptions {
            if (library.totalScore! < min && library.totalScore! > bestThree[0].totalScore! && library.totalScore! > bestThree[1].totalScore!) {
                min = library.totalScore!
                bestThree[0] = library
            }
        }
}
    
    
    func findmax() -> Double {
        var max: Double = 0.0;
        for library in allLibraryOptions {
            if (library.distance! > max) {
                max = library.distance!
            }
        }
        return max
    }
}
    


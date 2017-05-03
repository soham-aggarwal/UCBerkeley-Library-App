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

class LibrariesModel: NSObject, CLLocationManagerDelegate {
    

    struct Library {
        var name: String?
        var index: Int?
        var description: String?
        var image_url: String?
        var preference: Int?
        var open: Bool?
        var latitude: String?
        var longitude: String?
        var distance: Double?
        var percentageFull: Int?
        var totalScore: Int?
        
        
        init(name:String, index: Int, description: String, image_url: String, latitude: String, longitude:String) {
            self.name = name
            self.index = index
            self.description = description
            self.image_url = image_url
            self.latitude = latitude
            self.longitude = longitude
        }
    }
    
    var allLibraryOptions: [Library] = []
    var bestThree: [Library] = []
    let manager = CLLocationManager()
    var table: UITableView?
    var mylocation: CLLocation?
    
    //Now we need to fill up the allLibraryOptions variable.
    
    /* Make the API call to my API to get the names inside the initializer. Then inside the completion handler, call my API to getPreferences(). Then, inside the completion handler, make a function call to getDistance(). Inside the completion handler for getDistance(), make a function call to getPercentage(). Now all the information has been obtained and I can safely perform my algorithm.
     */
    
    override init() {
        super.init()
        //self.table = tableview
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestLocation()
        let headers: HTTPHeaders = ["x-access-token":KeychainService.loadPassword() as! String]
        Alamofire.request("https://library-adhyyan.herokuapp.com/api/libraries", method: .get, headers: headers).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let number = json.arrayValue.count
                for i in 0..<number {
                    let namePath: [JSONSubscriptType] = [i, "name"]
                    let indexPath: [JSONSubscriptType] = [i, "index"]
                    let descriptionPath: [JSONSubscriptType] = [i, "description"]
                    let imagePath: [JSONSubscriptType] = [i, "image_url"]
                    let latPath: [JSONSubscriptType] = [i, "latitude"]
                    let lonPath: [JSONSubscriptType] = [i, "longitude"]
                    let libraryOptionName = Library(
                        name: json[namePath].stringValue,
                        index: json[indexPath].intValue,
                        description: json[descriptionPath].stringValue,
                        image_url: json[imagePath].stringValue,
                        latitude: json[latPath].stringValue,
                        longitude: json[lonPath].stringValue
                    )
                    self.allLibraryOptions.append(libraryOptionName)
                }
                self.getPreferences()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        mylocation = locations[locations.count - 1]
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func getPreferences() -> Void {
        let reqUrl: String = "https://library-adhyyan.herokuapp.com/api/users/" + GlobalVar.id
        let headers: HTTPHeaders = ["x-access-token":KeychainService.loadPassword() as! String]
        print(GlobalVar.id)
        Alamofire.request(reqUrl, method: .get, headers: headers).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                for i in 0..<self.allLibraryOptions.count {
                    let path: [JSONSubscriptType] = ["preferences", self.allLibraryOptions[i].name!]
                    let prefNumber = json[path].stringValue
                    self.allLibraryOptions[i].preference = Int(prefNumber)
                }
                self.getOpenAndPercentage()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    
    func getOpenAndPercentage(){
        let headers: HTTPHeaders = ["Authorization": "Token 4bbaf1d70e38e88de1b3b70debec71b5e422791e"]
        Alamofire.request("https://api.packd.org/locations/", method: .get, headers: headers).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                for i in 0..<self.allLibraryOptions.count {
                    let library: Library = self.allLibraryOptions[i]
                    let openPath: [JSONSubscriptType] = [library.index!, "is_open"]
                    let percentagePath: [JSONSubscriptType] = [library.index!, "current_percent"]
                    self.allLibraryOptions[i].open = json[openPath].boolValue
                    self.allLibraryOptions[i].percentageFull = json[percentagePath].intValue
                }
                self.getDistances()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getDistances() -> Void {
        //manager.delegate = self.manager
        for i in 0..<self.allLibraryOptions.count {
            mylocation = manager.location
            //locationManager(manager, didUpdateLocations: mylocation)
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
        self.recommendThree()
    }
    
    
    func recommendThree() {
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
        for i in 0..<finalOptions.count {
            let library = finalOptions[i]
            finalOptions[i].totalScore = Int(library.distance!) +  library.preference!
        }
        var index: Int = 0;
        var min: Int = 25
        for i in 0..<finalOptions.count {
            let library: Library = finalOptions[i]
            if (library.totalScore! < min) {
                min = library.totalScore!
                index = i;
            }
        }
        bestThree.append(finalOptions[index])
        index = 0;
        min = 25
        for i in 0..<finalOptions.count {
            let library: Library = finalOptions[i]
            if (library.totalScore! < min && library.totalScore! > bestThree[0].totalScore!) {
                min = library.totalScore!
                index = i;
            }
        }
        bestThree.append(finalOptions[index])
        index = 0;
        min = 25
        for i in 0..<finalOptions.count {
            let library: Library = finalOptions[i]
            if ((library.totalScore! < min) && (library.totalScore! > bestThree[0].totalScore!) && (library.totalScore! > bestThree[1].totalScore!)) {
                min = library.totalScore!
                index = i;
            }
        }
        bestThree.append(finalOptions[index])
        table?.reloadData()
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




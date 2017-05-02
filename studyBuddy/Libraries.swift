//  Libraries.swift
//  studyBuddy
//
//  Created by Adhyyan Narang on 4/30/17.
//  Copyright © 2017 Adhyyan Narang. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class LibrariesModel {
    
    struct Library {
        var name: String?
        var preference: Int?
        var distance: Int?
        var percentageFull: Int?
        var totalScore: Int?
        
        init(name:String) {
            self.name = name
        }
    }
    
    var allLibraryOptions: [Library] = []
    
    //Now we need to fill up the allLibraryOptions variable.
    
    /* Make the API call to my API to get the names inside the initializer. Then inside the completion handler, call my API to getPreferences(). Then, inside the completion handler, make a function call to getDistance(). Inside the completion handler for getDistance(), make a function call to getPercentage(). Now all the information has been obtained and I can safely perform my algorithm.
     */
    
    init() {
        Alamofire.request("https://library-adhyyan.herokuapp.com/api/libraries", method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let number = json.arrayValue.count
                for i in 0...number {
                    let path: [JSONSubscriptType] = [i, "name"]
                    let libraryOptionName = Library(
                        name: json[path].stringValue
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
        let reqUrl: String = "https://library-adhyyan.herokuapp.com/api/users/" + id
        Alamofire.request(reqUrl, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let number = json.arrayValue.count
                for i in 0...number {
                    let path: [JSONSubscriptType] = ["preferences", self.allLibraryOptions[i].name!]
                    let prefNumber = json[path].intValue
                    self.allLibraryOptions[i].preference = prefNumber
                    self.getDistances()
                }
                self.getPreferences()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getDistances() -> Void {
        
    }
    
}

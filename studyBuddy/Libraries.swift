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
        var open: Bool?
        var distance: Double?
        var percentageFull: Int?
        var totalScore: Int?
        
        
        init(name:String) {
            self.name = name
        }
    }
    
    var allLibraryOptions: [Library] = []
    var bestThree: [Library] = []
    
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
                    self.getDistances(i: 0)
                }
                self.getPreferences()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getDistances(i: Int) -> Void {
        if (i < allLibraryOptions.count - 1) {
            
        } else {
            getOpen()
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
        for var library in finalOptions {
            library.distance = library.distance! * scalingFactor
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
        return bestThree
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
    


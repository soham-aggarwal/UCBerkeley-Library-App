//
//  Users.swift
//  studyBuddy
//
//  Created by Adhyyan Narang on 4/13/17.
//  Copyright © 2017 Adhyyan Narang. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


class User {
    
    var json: JSON?
    
    func getLibrarySize() -> JSON {
        DispatchQueue.main.sync {
            Alamofire.request("https://library-adhyyan.herokuapp.com/api/libraries", method: .get).validate().responseJSON { response in
                switch response.result {
                case .success(let value):
                    self.json = JSON(value)
                case .failure(let error):
                    print(error)
                }
            }
        }
        return json!
    }
    
}

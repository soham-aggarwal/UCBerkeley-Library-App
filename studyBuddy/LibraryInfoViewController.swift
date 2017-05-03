//
//  LibraryInfoViewController.swift
//  studyBuddy
//
//  Created by Adhyyan Narang on 5/2/17.
//  Copyright © 2017 Adhyyan Narang. All rights reserved.
//

import UIKit

class LibraryInfoViewController: UIViewController {

    var nameString: String?
    var descriptionString: String?
    var imageSave: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        libraryImage.image = imageSave
        nameLabel.text = nameString
        descriptionLabel.text = descriptionString
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBOutlet weak var libraryImage: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    

    @IBOutlet weak var descriptionLabel: UILabel!
}

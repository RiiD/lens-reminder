//
//  ViewController.swift
//  Lens reminder
//
//  Created by Nadir on 27/07/2019.
//  Copyright © 2019 Nadir. All rights reserved.
//

import UIKit

class LensInfoViewController: StateAwareController {
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var descrLbl: UILabel!
    
    weak var lens: Lens?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let sLens = lens {
            nameLbl.text = sLens.name
            descrLbl.text = sLens.descr
            if let imageData = lens?.image, let image = UIImage(data: imageData) {
                imgView.image = image
            }
        }
    }

    @IBAction func onUse(_ sender: UIButton) {
        setSelectedLens(lens: lens)
        performSegue(withIdentifier: "unwindToMain", sender: self)
    }
}

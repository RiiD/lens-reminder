//
//  LensTableItemView.swift
//  Lens reminder
//
//  Created by Nadir on 27/07/2019.
//  Copyright © 2019 Nadir. All rights reserved.
//

import UIKit

class LensTableItemView: UITableViewCell {
    
    @IBOutlet weak var label: UILabel!
    
    public func set(label: String) {
        self.label?.text = label
    }
}

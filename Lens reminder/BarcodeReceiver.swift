//
//  BarcodeReceiver.swift
//  Lens reminder
//
//  Created by Nadir on 01/08/2019.
//  Copyright © 2019 Nadir. All rights reserved.
//

import UIKit

protocol BarcodeReceiver {
    func receive(barcode: String)
}

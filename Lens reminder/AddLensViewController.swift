//
//  ViewController.swift
//  Lens reminder
//
//  Created by Nadir on 27/07/2019.
//  Copyright © 2019 Nadir. All rights reserved.
//

import UIKit

class AddLensViewController: StateAwareController, BarcodeReceiver, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameTextView: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var recommendedLabel: UILabel!
    @IBOutlet weak var maximumLabel: UILabel!
    @IBOutlet weak var recommendedStepper: UIStepper!
    
    @IBOutlet weak var maximumStepper: UIStepper!
    
    var barcode: String?
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func onCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func onSave(_ sender: Any) {
        let _ = getLensDAL().create(
            name: nameTextView.text!,
            description: descriptionTextView.text!,
            image: imageView.image?.pngData(),
            barcode: UUID().uuidString,
            recommendedHours: Int64(recommendedStepper.value),
            maximumHours: Int64(maximumStepper.value))
        
        dismiss(animated: true, completion: nil)
    }
    @IBAction func recommendedStepperChanged(_ sender: UIStepper) {
        recommendedLabel.text = String(format: "%d hours", Int(sender.value))
    }
    @IBAction func maximumStepperChanged(_ sender: UIStepper) {
        maximumLabel.text = String(format: "%d hours", Int(sender.value))
    }
    @IBAction func onAddPhoto(_ sender: UIButton) {
        let imgPicker = UIImagePickerController()
        imgPicker.delegate = self
        
        present(imgPicker, animated: true, completion: nil)
    }
    
    func receive(barcode: String) {
        self.barcode = barcode
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = image
        }
    }
}

//
//  ViewController.swift
//  Lens reminder
//
//  Created by Nadir on 27/07/2019.
//  Copyright © 2019 Nadir. All rights reserved.
//

import UIKit
import CoreData

class LensDatabaseViewController: StateAwareController, UITableViewDelegate, UITableViewDataSource, BarcodeReceiver {
    @IBOutlet weak var tableView: UITableView!
    var lens: [Lens]?
    var selectedLens: Lens?
    @IBOutlet weak var filterTF: UITextField!
    
    func updateData() {
        if let name = filterTF.text, name != "" {
            lens = getLensDAL().search(by: name)
        } else {
            lens = getLensDAL().getAll()
        }
        
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lens?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "lens", for: indexPath) as! LensTableItemView
        if let name = lens?[indexPath.item].name {
            cell.set(label: name)
        }
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showInfo" {
            if let lens = selectedLens {
                let infoController = segue.destination as! LensInfoViewController
                infoController.lens = lens
                selectedLens = nil
            } else if let indexPath = tableView.indexPathForSelectedRow {
                let infoController = segue.destination as! LensInfoViewController
                infoController.lens = lens?[indexPath.row]
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateData()
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func receive(barcode: String) {
        if let lens = getLensDAL().get(barcode: barcode) {
            selectedLens = lens
            performSegue(withIdentifier: "showInfo", sender: nil)
        }
    }
    
    @IBAction func onFind(_ sender: Any) {
        updateData()
    }
    
}

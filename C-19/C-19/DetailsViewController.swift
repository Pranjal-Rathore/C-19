//
//  DetailsViewController.swift
//  C-19
//
//  Created by Pranjal Rathore on 02/08/20.
//  Copyright © 2020 Pranjal Rathore. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var cLabel: UILabel!
    @IBOutlet weak var aLabel: UILabel!
    @IBOutlet weak var rLabel: UILabel!
    @IBOutlet weak var dLabel: UILabel!
    @IBOutlet weak var detailView: UIView!
    
    var c = 0
    var a = 0
    var r = 0
    var d = 0
    var cont = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        detailView.layer.masksToBounds = true
        detailView.layer.cornerRadius = 10
        cLabel.text = numberFormatterInt(i: c)
        aLabel.text = numberFormatterInt(i: a)
        rLabel.text = numberFormatterInt(i: r)
        dLabel.text = numberFormatterInt(i: d)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwindToCountry"{
            let destVC = segue.destination as! CountryViewController
            countryName = cont
        }
        
    }
    
    @IBAction func detailButton(_ sender: UIButton) {
        performSegue(withIdentifier: "unwindToCountry", sender: self)
    }
    

}

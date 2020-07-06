//
//  ViewController.swift
//  ToUpper
//
//  Created by Stephen Smith on 2020-01-24.
//  Copyright © 2020 Stephen Smith. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //MARK: Properties
    @IBOutlet weak var enterText: UITextField!
    @IBOutlet weak var convertBtn: UIButton!
    @IBOutlet weak var convertedText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    //MARK: Actions
    @IBAction func doConversion(_ sender: UIButton) {
        var output : [CChar] = Array(repeating: 0, count: 255)
        //convertedText.text = (enterText.text)?.uppercased()
        mytoupper(enterText.text, &output)
        convertedText.text = String(validatingUTF8: output)
    }
}


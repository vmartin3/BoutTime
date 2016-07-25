//
//  SecondViewController.swift
//  BoutTime
//
//  Created by Vernon G Martin on 7/24/16.
//  Copyright © 2016 Vernon G Martin. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    @IBOutlet weak var finalScore: UILabel!
    var settings = GameModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        finalScore.text = "\(GameModel.correctRounds)/\(settings.numOfRounds)"
    }
}

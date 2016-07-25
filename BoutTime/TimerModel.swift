//
//  TimerModel.swift
//  BoutTime
//
//  Created by Vernon G Martin on 7/17/16.
//  Copyright © 2016 Vernon G Martin. All rights reserved.
//

import Foundation
import UIKit

struct TimerModel:Timer {
    var gameTimer: NSTimer
    var timerCounter: Int
    func startTimer(timer: UILabel) {
        gameTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        timer.text = String ("Timer: \(timerCounter)")
    }
    func stopTimer(timer: UILabel) {
        gameTimer.invalidate()
        gameTimer = 15
        timer.text = String("Timer: \(timerCounter)")
    }
}

protocol Timer{
    var gameTimer: NSTimer()
    var timerCounter: Int {set}
    func startTimer()
    func stopTimer()
    func updateTimer()
}
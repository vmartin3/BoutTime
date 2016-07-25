//
//  GameSettingsModel.swift
//  BoutTime
//
//  Created by Vernon G Martin on 7/17/16.
//  Copyright © 2016 Vernon G Martin. All rights reserved.
//

import Foundation

struct GameModel{
    var numOfRounds = 6
    var numOfOptions = 4
    var roundsPlayed = 0
    static var correctRounds = 0
}



enum positionSelection{
    case MostRecent
    case SecondSlot
    case ThirdSlot
    case Oldest
    
    func setEvent(){
        
    }
}

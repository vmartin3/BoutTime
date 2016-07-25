//
//  ViewController.swift
//  BoutTime
//
//  Created by Vernon G Martin on 7/13/16.
//  Copyright © 2016 Vernon G Martin. All rights reserved.
//

import UIKit
import GameKit
import SafariServices

class ViewController: UIViewController, SFSafariViewControllerDelegate {
    
    //Labels
    @IBOutlet weak var shakeToComplete: UILabel!
    @IBOutlet weak var mostRecentEvent: UILabel!
    @IBOutlet weak var secondEvent: UILabel!
    @IBOutlet weak var thirdEvent: UILabel!
    @IBOutlet weak var oldestEvent: UILabel!
    @IBOutlet weak var timer: UILabel!
    
    //Arrow Keys
    @IBOutlet weak var eventOneArrowDown: UIButton!
    @IBOutlet weak var eventTwoArrowUp: UIButton!
    @IBOutlet weak var eventTwoArrowDown: UIButton!
    @IBOutlet weak var eventThreeArrowUp: UIButton!
    @IBOutlet weak var eventFourArrowUp: UIButton!
    @IBOutlet weak var eventThreeArrowDown: UIButton!
    
    //More Info Buttons
    @IBOutlet weak var moreInfoFour: UIButton!
    @IBOutlet weak var moreInfoThree: UIButton!
    @IBOutlet weak var moreInfoTwo: UIButton!
    @IBOutlet weak var moreInforOne: UIButton!
    @IBOutlet weak var nextRound: UIButton!
    

    var settings = GameModel()
    var historicalEvent: [HistoricalEventModel] = []
    let eventSet = historicalEvents
    var usedEvents: [Int] = []
    var gameTimer = NSTimer()
    var timerCounter = 60
    var indexOfSelectedEvent: Int = 0
    //var choices: [UILabel] = []
    
    enum ButtonType: Int
    {
        case EventOneDown = 1
        case EventTwoUp = 2
        case EventTwoDown = 3
        case EventThreeUp = 4
        case EventThreeDown = 5
        case EventFourUp = 6
        case MoreInfoOne = 7
        case MoreInfoTwo = 8
        case MoreInfoThree = 9
        case MoreInfoFour = 10
    }
    

      @IBAction func buttonPressed(sender: AnyObject) {
        switch(ButtonType(rawValue: sender.tag)!){
        case .EventOneDown:
            mostRecentEvent.text = historicalEvent[1].event
            secondEvent.text = historicalEvent[0].event
            swap(&historicalEvent[1], &historicalEvent[0])
            
        case .EventTwoUp:
            secondEvent.text = historicalEvent[0].event
            mostRecentEvent.text = historicalEvent[1].event
            swap(&historicalEvent[0], &historicalEvent[1])
            
        case .EventTwoDown:
            secondEvent.text = historicalEvent[2].event
            thirdEvent.text = historicalEvent[1].event
            swap(&historicalEvent[2], &historicalEvent[1])
        
        case .EventThreeUp:
            thirdEvent.text = historicalEvent[1].event
            secondEvent.text = historicalEvent[2].event
            swap(&historicalEvent[1], &historicalEvent[2])
            
        case .EventThreeDown:
            thirdEvent.text = historicalEvent[3].event
            oldestEvent.text = historicalEvent[2].event
            swap(&historicalEvent[3], &historicalEvent[2])
            
        case .EventFourUp:
            oldestEvent.text = historicalEvent[2].event
            thirdEvent.text = historicalEvent[3].event
            swap(&historicalEvent[2], &historicalEvent[3])
            
        case .MoreInfoOne: loadPage(historicalEvent[0].website)
        
        case .MoreInfoTwo: loadPage(historicalEvent[1].website)
            
        case .MoreInfoThree: loadPage(historicalEvent[2].website)
            
        case .MoreInfoFour: loadPage(historicalEvent[3].website)
        }
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        GameModel.correctRounds = 0
        startTimer()
        displayQuestion()
        
        //For testing purpose uncomment the below line and other places where 'choices' is used to see correct date of the event placed
        //next to the correct text
        //choices = [mostRecentEvent,secondEvent, thirdEvent, oldestEvent]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    
    func startTimer(){
        //Starts the timer sets the decrement count to 1 and sets the text of the timer label
        gameTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        timer.text = String ("Timer: \(timerCounter)")
    }
    
    func updateTimer(){
        //Decrements timer by a count of 1
        timerCounter = timerCounter - 1
        timer.text = String("Timer: \(timerCounter)")
        
        //If timer runs out stop the timer
        if timerCounter == 0{
            stopTimer()
        }
    }
    
    func stopTimer(){
        //Stops and resets timer ot 60 seconds
        settings.roundsPlayed += 1
        timerCounter = 60
        shakeToComplete.text = "Tap events to learn more!"
        gameTimer.invalidate()
        setMoreInfoButtons(true)
        getCorrectAnswer()
        timer.hidden = true
        nextRound.hidden = false
    }
    
    func setMoreInfoButtons(value: Bool)
    {
        moreInforOne.enabled = value
        moreInfoTwo.enabled = value
        moreInfoThree.enabled = value
        moreInfoFour.enabled = value
    }
    
    func displayQuestion() {
        //Generates a random number to select an event that has not been used yet. If an event that has been
        //used is selected it will generate a new one until that is not the case
        for _ in 0..<settings.numOfOptions
        {
        indexOfSelectedEvent = generateRandomNumber(upperBound: eventSet.count)
        while usedEvents.contains(indexOfSelectedEvent){
            indexOfSelectedEvent = generateRandomNumber(upperBound: eventSet.count)
        }
        
        usedEvents.append(indexOfSelectedEvent)
        historicalEvent.append(eventSet[indexOfSelectedEvent])
        let event = eventSet[indexOfSelectedEvent]
            
        //choices[i].text = "\(event.event) \(event.date)"
        }
    }
    
    func getCorrectAnswer(){
        //Puts the events that were randomly displayed in order from most recent to the oldest
        let correctEventOrder = historicalEvent.sort{ $1.date < $0.date }
        var correctAnswer:Bool = false
        
        //Cycles through the order of events the user selected and checks them against the correct order
        for x in 0 ..< settings.numOfOptions{
            if equatable(correctEventOrder[x], rhs: historicalEvent[x]){
                correctAnswer = true
            }else{
                correctAnswer = false
            }
        }
        
        //Changes image and increments the correct number of rounds variable
        if correctAnswer{
            if let image = UIImage(named: "next_round_success.png") {
                nextRound.setImage(image, forState: .Normal)
                GameModel.correctRounds += 1
            }
        }else{
            if let image = UIImage(named: "next_round_fail.png") {
                nextRound.setImage(image, forState: .Normal)
            }
        }
    }
    
    //Checks to see if the order of events the user selected is the same as the correct order of events
    func equatable(lhs: HistoricalEventModel, rhs: HistoricalEventModel) -> Bool {
        return lhs.date == rhs.date && lhs.event == rhs.event
    }
    
    func loadNextRound() {
        if settings.roundsPlayed == settings.numOfRounds {
            // Game is over
            displayScore()
            timer.hidden = false
            timer.text = " "
        } else {
            // Continue game
            historicalEvent = []
            shakeToComplete.text = "Shake to Complete"
            setMoreInfoButtons(false)
            timer.hidden = false
            nextRound.hidden = true
            startTimer()
            displayQuestion()
        }
    }
    
    //Pushes the current view controller out of the way and brings up the game over view controller
    func displayScore(){
        let vc = self.storyboard!.instantiateViewControllerWithIdentifier("GameOver") as! SecondViewController
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    func generateRandomNumber(upperBound upperBound:Int)->Int{
        //Creates and returns a random number
        let randomNumber = GKRandomSource.sharedRandom().nextIntWithUpperBound(upperBound)
        return randomNumber
    }
    
    @IBAction func nextRound(sender: AnyObject) {
        loadNextRoundWithDelay(seconds: 2)
    }

    
    
    //HELPER METHODS
    func loadNextRoundWithDelay(seconds seconds: Int) {
        // Converts a delay in seconds to nanoseconds as signed 64 bit integer
        let delay = Int64(NSEC_PER_SEC * UInt64(seconds))
        // Calculates a time value to execute the method given current time and delay
        let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, delay)
        
        // Executes the nextRound method at the dispatch time on the main queue
        dispatch_after(dispatchTime, dispatch_get_main_queue()) {
            self.loadNextRound()
        }
    }
    
    func safariViewControllerDidFinish(controller: SFSafariViewController)
    {
        //Dismisses Safari View and brings back the game screen
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func loadPage(website: String){
        //Loads the appropriate website for more information based on the event selected
        let safariVC = SFSafariViewController(URL: NSURL(string: website)!)
        self.presentViewController(safariVC, animated: true, completion: nil)
        safariVC.delegate = self
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        //If user shakes their device stop the timer
        if motion == .MotionShake {
            stopTimer()
        }
    }
    
    
}


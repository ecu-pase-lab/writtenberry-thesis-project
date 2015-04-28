//
//  Press.swift
//
//  Subclass of Gesture that allows for detection
//  of a "press" gesture.
//


import Foundation
class Press:Gesture {
    
    var minimumPressDuration:CFTimeInterval = 0.5
    var allowableMovement: CGFloat = 10.0
    var startTime:CFTimeInterval = 0.0
    var passedTime:CFTimeInterval = 0.0
    var movedTooFar = false
    
    //initializes to values of a Gesture object
    //and sets its function as pressCall()
    override init(){
        super.init()
        function = pressCall()
    }
    //initializer that allows minimumPressDuration to be set
    init(minimumPressDuration:CFTimeInterval){
        super.init()
        self.minimumPressDuration = minimumPressDuration
        function = pressCall()
    }
    //initializer that allows allowableMovement to be set
    init(allowableMovement:CGFloat){
        super.init()
        self.allowableMovement = allowableMovement
        function = pressCall()
    }
    //initializer that allows minimumPressDuration and allowableMovement to be set
    init(minimumPressDuration:CFTimeInterval, allowableMovement:CGFloat){
        super.init()
        self.minimumPressDuration = minimumPressDuration
        self.allowableMovement = allowableMovement
        function = pressCall()
    }
    
    //returns the function that detects a press gesture
    //based off touch info.
    func pressCall() -> (CGPoint) -> () {
        func f (touch: CGPoint) {
            self.lastPoint = touch
            let moveAmt = distanceBetween(touch, andPointB: curTouch)
            if moveAmt > self.allowableMovement {
                self.movedTooFar = true
                return
            }
            self.passedTime = CACurrentMediaTime() - self.startTime
            if self.passedTime >= self.minimumPressDuration {
                self.done = true
            }
        }
        return f
    }
    
    //resets values back to their original values
    override func reset() {
        super.reset()
        self.movedTooFar = false
        var startTime:CFTimeInterval = 0
        var passedTime:CFTimeInterval = 0
    }
}
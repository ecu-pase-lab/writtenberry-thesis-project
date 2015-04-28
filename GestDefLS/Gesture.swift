//
//  Gesture.swift
//
//  The parent class to all types of gestures.
//

import Foundation

class Gesture {
    
    enum Direction:Int {
        case Any = 0
        case Left
        case Right
        case Up
        case Down
        case Opposite
    }
    
    var gestures: Array<Gesture>?
    var function:(CGPoint -> ())?
    var direction:Direction = Direction.Right
    var lastDirection:Direction = .Any
    var curTouch:CGPoint = CGPointZero
    var begin = false
    var done = false
    //used to keep track of which touch is
    //associated with the gesture when a
    //touch moves
    var lastPoint:CGPoint = CGPointZero
    
    init() {}
    
    //call the function, if it exists, associated with the 
    //Gesture object (or subclass)
    func fire(point:CGPoint) {
        //In case of multitouch, keep recording the most recent 
        //touch location if the current gesture has already completed
        if self.done == true {
            self.lastPoint = point
            return
        }
        self.function?(point)
    }
    
    //fulfilled by AtSameTime class
    func isDone() {}
    
    //transition all important info from self to
    //Gesture object gest
    func transitionTo(gest: Gesture) {
        if let gestArr = gest.gestures{
            //MANY to MANY
            if self.gestures != nil{
                var x = 0;
                for subGest in self.gestures! {
                    gestArr[x].curTouch = subGest.curTouch
                    gestArr[x].lastDirection = subGest.lastDirection
                    gestArr[x].lastPoint = subGest.lastPoint
                    x++
                }
                gest.gestures = gestArr
            //ONE to MANY
            } else {
                for(var x = 0; x < gestArr.count; x++) {
                    gestArr[x].lastDirection = self.lastDirection
                }
                gest.gestures = gestArr
            }
        //ONE TO ONE
        } else {
            if !(gest is Tap){
                gest.curTouch = self.curTouch
                gest.lastDirection = self.lastDirection
                gest.lastPoint = self.lastPoint
            }
        }
    }
    
    //reset all important values to original
    //values
    func reset() {
        self.curTouch = CGPointZero
        self.done = false
        self.lastDirection = .Any
        self.lastPoint = CGPointZero
        self.begin = false
    }
    
    //THIS FUNC CAME FROM XMCircleGestureRecognizer app
    //standard function to calculate distance between pointA
    //and pointB
    func distanceBetween(pointA:CGPoint, andPointB pointB:CGPoint) -> CGFloat {
        let dx = Float(pointA.x - pointB.x)
        let dy = Float(pointA.y - pointB.y)
        return CGFloat(sqrtf(dx*dx + dy*dy))
    }
}
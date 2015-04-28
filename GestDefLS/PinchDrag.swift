//
//  PinchDrag.swift
//
//  Gesture recognizer for a "pinch-then-drag" gesture
//

import UIKit

class PinchDrag:UIGestureRecognizer {
    
    var distanceForPinch:CGFloat = 5.0
    var distanceForDragDownGesture:CGFloat = 25.0
    
    enum Direction:Int {
        case DirectionUnknown = 0
        case DirectionLeft
        case DirectionRight
    }
    
    var touchOne1:CGPoint! = CGPointZero
    var touchOne2:CGPoint! = CGPointZero
    var nextTouch1:CGPoint! = CGPointZero
    var nextTouch2:CGPoint! = CGPointZero
    var lastDirection:Direction = .DirectionUnknown
    
    var gestCount = 0
    
    //The goal is to set this variable to true after all
    //the actions of the gesture have been completed
    var done = false
    
    override func touchesBegan(touches: NSSet!, withEvent event: UIEvent!)  {
        let touch = event.allTouches()?.allObjects
        if touch?.count == 2 {
            self.touchOne1 = touch?[0].locationInView(self.view)
            self.touchOne2 = touch?[1].locationInView(self.view)
        }
    }
    
    override func touchesMoved(touches: NSSet!, withEvent event: UIEvent!) {
        let touch = event.allTouches()?.allObjects
        if touch?.count == 2 {
            self.nextTouch1 = touch?[0].locationInView(self.view)
            self.nextTouch2 = touch?[1].locationInView(self.view)
        }
        
        
        let moveAmt = touchOne1.x - nextTouch1.x
        let moveAmt2 = touchOne2.x - nextTouch2.x
        
        var curDirection:Direction
        var curDirection2:Direction
        
        if moveAmt < 0 {
            curDirection = .DirectionLeft
        } else {
            curDirection = .DirectionRight
        }
        
        if moveAmt2 < 0 {
            curDirection2 = .DirectionLeft
        } else {
            curDirection2 = .DirectionRight
        }
        
        if (abs(moveAmt) > self.distanceForPinch && ((curDirection == .DirectionLeft && curDirection2 == .DirectionRight) || (curDirection == .DirectionRight && curDirection2 == .DirectionLeft))) {
            let moveYAmt = touchOne1.y - nextTouch1.y
            let moveYAmt2 = touchOne2.y - nextTouch2.y
            
            if abs(moveYAmt) < distanceForDragDownGesture || abs(moveYAmt2) < distanceForDragDownGesture {
                return
            }
            self.state = .Ended
        }
    }

    override func reset() {
        self.gestCount = 0
        var touchOne1:CGPoint! = CGPointZero
        var touchOne2:CGPoint! = CGPointZero
        var nextTouch1:CGPoint! = CGPointZero
        var nextTouch2:CGPoint! = CGPointZero
        self.lastDirection = .DirectionUnknown
        if self.state == .Possible {
            self.state = .Failed
        }
        self.done = false
    }
    
    override func touchesEnded(touches: NSSet!, withEvent event: UIEvent!) {
        self.reset()
    }
    
    override func touchesCancelled(touches: NSSet!, withEvent event: UIEvent!) {
        self.reset()
    }
}



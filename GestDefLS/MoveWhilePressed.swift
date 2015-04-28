//
//  MoveWhilePressed.swift
//
//  Gesture recognizer for a "move-while-pressed" gesture
//

import Foundation
import UIKit

class MoveWhilePressed:UIGestureRecognizer {
    
    let distanceForMove:CGFloat = 6.0
    let maxPressMovement:CGFloat = 5.0
    
    var press:CGPoint = CGPointZero
    var newTouch:CGPoint = CGPointZero
    var distanceTraveled:CGFloat = 0.0
    var minimumPressDuration: CFTimeInterval = 10.0
    var durationOfPress: CFTimeInterval = 0.0
    var startTimeAbsolute: CFTimeInterval = 0.0
    
    
    
    override func touchesBegan(touches: NSSet!, withEvent event: UIEvent!)  {
        let touch = touches.anyObject() as UITouch
        self.press = touch.locationInView(self.view)
        startTimeAbsolute = CACurrentMediaTime()
    }
    
    override func touchesMoved(touches: NSSet!, withEvent event: UIEvent!) {
        let touch = event.allTouches()?.allObjects
        let currentTime = CACurrentMediaTime()
        var prevPress = self.press
        var prevTouch = self.newTouch
        
        if touch!.count == 2 {
            if self.press == touch![0].locationInView(self.view) {
                self.press = touch![0].locationInView(self.view)
                self.newTouch = touch![1].locationInView(self.view)
            } else {
                self.press = touch![1].locationInView(self.view)
                self.newTouch = touch![0].locationInView(self.view)
            }
            if prevTouch != CGPointZero {
                self.distanceTraveled = self.distanceTraveled + distance(prevTouch, and: self.newTouch)
            }
        } else {
            self.press = touch![0].locationInView(self.view)
            self.distanceTraveled = 0.0
        }
        
        let moveAmt = press.x - prevPress.x
        durationOfPress = currentTime - startTimeAbsolute
        
        if abs(moveAmt) < maxPressMovement {
            if(self.distanceTraveled > self.distanceForMove && durationOfPress > minimumPressDuration) {
                self.state = .Ended
            } else {
                return
            }
        }
    }
    
    override func reset() {
        self.press = CGPointZero
        self.newTouch = CGPointZero
        self.distanceTraveled = 0.0
        self.minimumPressDuration = 10.0
        self.durationOfPress = 0.0
        var startTimeAbsolute: CFTimeInterval = 0.0
        if self.state == .Possible {
            self.state = .Failed
        }
    }
    
    override func touchesEnded(touches: NSSet!, withEvent event: UIEvent!) {
        self.reset()
    }
    
    override func touchesCancelled(touches: NSSet!, withEvent event: UIEvent!) {
        self.reset()
    }
    
    func distance(oldPoint:CGPoint, and newPoint:CGPoint) -> CGFloat {
        let x = Float(oldPoint.x - newPoint.x)
        let y = Float(oldPoint.y - newPoint.y)
        return CGFloat(sqrtf(x*x + y*y))
    }
}

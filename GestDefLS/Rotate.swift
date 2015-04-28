//
//  Rotate.swift
//
//  Subclass of Gesture that allows for detection
//  of a "rotate" gesture.
//

import Foundation
class Rotate:Gesture {
    var degrees:CGFloat
    var radians:CGFloat
    //relative rotation between two points
    var relRotation:CGFloat = 0.0
    //absolute (total) rotation
    var absRotation:CGFloat = 0.0
    //identifies the point around which to rotate
    var midPoint:CGPoint
    
    //initializer that allows midPoint and degrees to be set
    init(midPoint:CGPoint, degrees:CGFloat){
        self.degrees = degrees
        self.radians = degrees * CGFloat(M_PI) / 180
        self.midPoint = midPoint
        super.init()
        function = rotateCall()//self.radians)
    }
    
    //returns the function that detects a rotate gesture
    //based off touch info.
    func rotateCall() -> (CGPoint) -> () {
        func f (touch: CGPoint) {
            var rotation = angleBetween(touch, andPointB: self.curTouch)
            if (rotation > CGFloat(M_PI)) {
                rotation -= CGFloat(M_PI)*2
            } else if (rotation < -CGFloat(M_PI)) {
                rotation += CGFloat(M_PI)*2
            }
            self.relRotation = rotation
            self.absRotation += rotation
            if self.absRotation >= self.radians {
                self.done = true
            }
        }
        return f
    }
    
    //resets values back to their original values
    override func reset(){
        super.reset()
        self.absRotation = 0.0
        self.relRotation = 0.0
    }
    
    //This func came from XMCircleGestureRecognizer app
    //XMCircleGestureRecognizer.swift
    //https://github.com/MichMich/XMCircleGestureRecognizer
    //returns the angle a point is at in regards to the midpoint
    private func angleForPoint(point:CGPoint) -> CGFloat {
        var angle = -atan2(point.x - midPoint.x, point.y - midPoint.y) + CGFloat(M_PI)/2
        
        if (angle < 0) {
            angle += CGFloat(M_PI)*2;
        }
        
        return angle
    }
    
    //This func came from XMCircleGestureRecognizer app
    //XMCircleGestureRecognizer.swift
    //https://github.com/MichMich/XMCircleGestureRecognizer
    //returns the angle between pointA and pointB
    private func angleBetween(pointA:CGPoint, andPointB pointB:CGPoint) -> CGFloat {
        return angleForPoint(pointA) - angleForPoint(pointB)
    }
}
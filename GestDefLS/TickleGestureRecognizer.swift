//
//  TickleGestureRecognizer.swift
//
//  From MonkeyPinch app
//  Gesture recognizer for a "tickle" gesture
//

/*
Copyright (c) 2010, 2011 Ray Wenderlich
Permission is hereby granted, free of charge, to any person obtaining a copy of this software to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import UIKit

class TickleGestureRecognizer:UIGestureRecognizer {
  
  // 1
  let requiredTickles = 2
  let distanceForTickleGesture:CGFloat = 25.0
  
  // 2
  enum Direction:Int {
    case DirectionUnknown = 0
    case DirectionLeft
    case DirectionRight
  }
  
  // 3
  var tickleCount:Int = 0
  var curTickleStart:CGPoint = CGPointZero
  var lastDirection:Direction = .DirectionUnknown
  
  
  
  override func touchesBegan(touches: NSSet!, withEvent event: UIEvent!)  {
    let touch = touches.anyObject() as UITouch
    self.curTickleStart = touch.locationInView(self.view)
  }
  
  override func touchesMoved(touches: NSSet!, withEvent event: UIEvent!) {
    let touch = touches.anyObject() as UITouch
    let ticklePoint = touch.locationInView(self.view)
    
    let moveAmt = ticklePoint.x - curTickleStart.x
    var curDirection:Direction
    if moveAmt < 0 {
      curDirection = .DirectionLeft
    } else {
      curDirection = .DirectionRight
    }
    
    //moveAmt is a Float, so self.distanceForTickleGesture needs to be a Float also
    if abs(moveAmt) < self.distanceForTickleGesture {
      return
    }
    
    if self.lastDirection == .DirectionUnknown ||
      (self.lastDirection == .DirectionLeft && curDirection == .DirectionRight) ||
      (self.lastDirection == .DirectionRight && curDirection == .DirectionLeft) {
        self.tickleCount++
        self.curTickleStart = ticklePoint
        self.lastDirection = curDirection
        
        if self.state == .Possible && self.tickleCount > self.requiredTickles {
          self.state = .Ended
        }
    }
  }
  
  override func reset() {
    self.tickleCount = 0
    self.curTickleStart = CGPointZero
    self.lastDirection = .DirectionUnknown
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
}

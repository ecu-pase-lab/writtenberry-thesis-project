//
//  Pan.swift
//
//  Subclass of Gesture that allows for detection
//  of a "pan" gesture.
//

/*

Direction code has been transformed from Monkey Pinch app

Copyright (c) 2010, 2011 Ray Wenderlich
Permission is hereby granted, free of charge, to any person obtaining a copy of this software to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation

class Pan:Gesture {
    var minMoveDistance:CGFloat = 25.0
    
    //initializes to values of a Gesture object
    //and sets its function as panCall()
    override init(){
        super.init()
        function = panCall()
    }
    //initializer that allows direction to be set
    init(direction:Direction){
        super.init()
        self.direction = direction
        function = panCall()
    }
    //initializer that allows minMoveDistance to be set
    init(minMoveDistance:CGFloat){
        super.init()
        self.minMoveDistance = minMoveDistance
        function = panCall()
    }
    //initializer that allows direction and 
    //minMoveDistance to be set
    init(minMoveDistance:CGFloat,direction:Direction){
        super.init()
        self.minMoveDistance = minMoveDistance
        self.direction = direction
        function = panCall()
    }
    
    //returns the function that detects a pan gesture 
    //based off touch info.
    func panCall() -> (CGPoint) -> () {
        func f (touch: CGPoint) {
            let newTouch = touch
            self.lastPoint = newTouch
            var horizontalAmt = touch.x - self.curTouch.x
            var vertAmt = -(touch.y - self.curTouch.y)
            if distanceBetween(touch, andPointB: self.curTouch) < self.minMoveDistance {
                return
            }
            var curDirectionX:Direction
            var curDirectionY:Direction
            
            if horizontalAmt < 0 {
                curDirectionX = .Left
            } else {
                curDirectionX = .Right
            }
            if vertAmt < 0 {
                curDirectionY = .Up
            } else {
                curDirectionY = .Down
            }
            
            switch self.direction {
            case .Any:
                self.curTouch = newTouch
                self.lastDirection = curDirectionX
                self.done = true
            case .Opposite :
                if self.lastDirection == .Any || (self.lastDirection == .Left &&  curDirectionX == .Right) ||
                    (self.lastDirection == .Right && curDirectionX == .Left) {
                        self.curTouch = newTouch
                        self.lastDirection = curDirectionX
                        self.done = true
                } else if (self.lastDirection == .Up &&  curDirectionY == .Down) ||
                    (self.lastDirection == .Down && curDirectionY == .Up) {
                        self.curTouch = newTouch
                        self.lastDirection = curDirectionY
                        self.done = true
                }
            case .Up:
                if vertAmt > 0 {
                    self.curTouch = newTouch
                    self.lastDirection = .Up
                    self.done = true
                }
            case .Down:
                if vertAmt < 0 {
                    self.curTouch = newTouch
                    self.lastDirection = .Down
                    self.done = true
                }
            case .Left:
                if horizontalAmt < 0  {
                        self.curTouch = newTouch
                        self.lastDirection = .Left
                        self.done = true
                }
            case .Right:
                if horizontalAmt > 0  {
                    self.curTouch = newTouch
                    self.lastDirection = .Right
                    self.done = true
                }
            }
        }
        return f
    }
}
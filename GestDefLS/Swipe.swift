//
//  Swipe.swift
//
//  Subclass of Gesture that allows for detection
//  of a "swipe" gesture.
//
//  (Planning on attempting to consolidate the direction
//  detection code to one file because it is almost the 
//  exact same in Pan.swift)
//

/*

Direction code has been transformed from Monkey Pinch app

Copyright (c) 2010, 2011 Ray Wenderlich
Permission is hereby granted, free of charge, to any person obtaining a copy of this software to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
class Swipe:Gesture {
    
    //identifies whether a swipe should be attempted
    //to be read (detected)
    var readSwipe = false
    
    //initializes to values of a Gesture object
    //and sets its function as swipeCall()
    override init(){
        super.init()
        function = swipeCall()
    }
    //initializer that allows direction to be set
    init(direction:Direction){
        super.init()
        self.direction = direction
        function = swipeCall()
    }
    
    //returns the function that detects a swipe gesture
    //based off touch info.
    func swipeCall() -> (CGPoint) -> () {
        func f (touch: CGPoint) {
            var horizontalAmt = touch.x - self.curTouch.x
            var vertAmt = -(touch.y - self.curTouch.y)
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
            case .Right:
                if horizontalAmt > 0 {
                    self.lastDirection = .Right
                    self.done = true
                }
            case .Left:
                if horizontalAmt < 0 {
                    self.lastDirection = .Left
                    self.done = true
                }
                return
            case .Up:
                if vertAmt > 0 {
                    self.lastDirection = .Up
                    self.done = true
                }
            case .Down:
                if vertAmt < 0 {
                    self.lastDirection = .Down
                    self.done = true
                }
            case .Any:
                self.lastDirection = curDirectionX
                self.done = true
                return
            case .Opposite:
                if self.lastDirection == .Any || (self.lastDirection == .Left &&  curDirectionX == .Right) ||
                    (self.lastDirection == .Right && curDirectionX == .Left) {
                        self.lastDirection = curDirectionX
                        self.done = true
                } else if (self.lastDirection == .Up &&  curDirectionY == .Down) ||
                    (self.lastDirection == .Down && curDirectionY == .Up) {
                        self.lastDirection = curDirectionY
                        self.done = true
                }
            }
        }
        return f
    }
    
    //resets values back to their original values
    override func reset() {
        super.reset()
        readSwipe = false
    }
}
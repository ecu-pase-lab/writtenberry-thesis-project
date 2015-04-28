//
//  DSL.swift
//
//  The UIGestureRecognizer subclass that performs all of the
//  underlying handling of touches.
//

import Foundation
import UIKit

class DSL:UIGestureRecognizer {

    var gestArr = Array<Gesture>()
    var stateCount = 0
    
    //keeps tracks of relative rotation
    //in case developer wants to rotate a view
    var rotation:CGFloat = 0.0
    
    //This gets called when a touch is placed on the interface.
    override func touchesBegan(touches: NSSet!, withEvent event: UIEvent!)  {
        let touch = event.allTouches()?.allObjects
        var gest = self.gestArr[self.stateCount]
        var newTouch = touch![0].locationInView(self.view)
        
        //The gesture is an AtSameTime object
        if let simultaneous = gest.gestures {
            if touch?.count != simultaneous.count {
                self.reset()
                return
            }
            for var touchCount = 0; touchCount < touch?.count; touchCount++ {
                simultaneous[touchCount].curTouch = touch![touchCount].locationInView(self.view)
                simultaneous[touchCount].lastPoint = simultaneous[touchCount].curTouch
            }
            var x = 0
            for gesture in simultaneous {
                /**///This portion is not working as intended yet.  IN PROGRESS...
                /**/if let tap = gesture as? Tap {
                /**/    if touch![x].tapCount == tap.numberOfTapsRequired {
                /**/        gesture.fire(touch![x].locationInView(self.view))
                /**/    }
                /**/    x++
                /**/}
                /**///////////////////////////////////////////////////////////
                else {
                    var temp: Gesture = Gesture()
                    //Sorts through touches and organizes them from left to right
                    //in the interface.
                    //At most 5 to sort through so not too high cost
                    for var count = 0; count < simultaneous.count; count++ {
                        if simultaneous[count].curTouch.x > gesture.curTouch.x {
                            temp.curTouch = gesture.curTouch
                            temp.lastPoint = gesture.lastPoint
                            gesture.curTouch = simultaneous[count].curTouch
                            gesture.lastPoint = simultaneous[count].lastPoint
                            simultaneous[count].curTouch = temp.curTouch
                            simultaneous[count].lastPoint = temp.lastPoint
                        }
                    }
                }
                if let press = gesture as? Press {
                    if press.begin == false {
                        press.startTime = CACurrentMediaTime()
                        press.begin = true
                        gest = press
                    }
                }
            }
            gest.gestures = simultaneous
            gest.isDone()
            if gest.done == true {
                self.stateCount++
                if self.stateCount < self.gestArr.count{
                    gest.transitionTo(self.gestArr[self.stateCount])
                } else if self.stateCount == self.gestArr.count {
                    self.state = .Ended
                }
                gest.curTouch = touch![0].locationInView(self.view)
            }
        }
        //The gesture is a Gesture subclass for a specific simple gesture
        else {
            if let press = gest as? Press {
                press.startTime = CACurrentMediaTime()
                press.begin = true
                gest = press
            } else if gest is Swipe {
                gest.begin = true
            } else if let tap = gest as? Tap {
                if touch![0].tapCount == tap.numberOfTapsRequired {
                    gest.fire(newTouch)
                    self.stateCount++
                    if self.stateCount < self.gestArr.count{
                        gest.transitionTo(self.gestArr[self.stateCount])
                    }
                    if (self.stateCount == self.gestArr.count) {
                        self.state = .Ended
                    }
                }
            }
            gest.curTouch = newTouch
        }
    }
    
    //Mostly handling continuous gestures.  This gets called everytime a touch
    //moves on the interface.
    override func touchesMoved(touches: NSSet!, withEvent event: UIEvent!) {
        let touch = event.allTouches()?.allObjects
        let newTouch = touch![0].locationInView(self.view)
        var gest = self.gestArr[self.stateCount]
        //curTouch only gets a value during touchesBegan, so if
        //curTouch != 0 and it's a tap then it moved, so failed tap
        if gest is Tap && gest.curTouch != CGPointZero {
            self.reset()
            return
        }
        if gest.done != true {
            //The gesture is an AtSameTime object
            if let simultaneous = gest.gestures {
                if touch?.count != simultaneous.count {
                    self.reset()
                    return
                }
                for subGest in simultaneous {
                    for var x = 0; x < touch?.count; x++ {
                        var prevGestPoint = touch![x].previousLocationInView(self.view)
                        var curGestPoint = touch![x].locationInView(self.view)
                        if subGest.lastPoint == prevGestPoint || subGest.lastPoint == curGestPoint {
                            subGest.fire(touch![x].locationInView(self.view))
                            if let press = subGest as? Press {
                                if press.movedTooFar == true {
                                    self.reset()
                                    return
                                }
                            }
                        }
                    }
                }
                gest.gestures = simultaneous
                gest.isDone()
            //The gesture is a Gesture subclass for a specific simple gesture
            } else {
                if gest is Swipe {
                    if gest.begin == true {
                        gest.fire(newTouch)
                    } else {
                        return
                    }
                } else {
                    if !(gest is Tap) {
                        gest.fire(newTouch)
                    }
                    if let press = gest as? Press {
                        if press.movedTooFar == true {
                            self.reset()
                            return
                        }
                    }
                    if let rotGest = gest as? Rotate {
                        self.rotation = rotGest.relRotation
                        state = .Changed
                    }
                }
            }
        }
        //can't use else because it won't be picked up if changed
        //in the above processing
        if (gest.done == true) {
            if !(gest is Swipe) {
                if gest is Rotate {
                    self.rotation = 0
                }
                self.stateCount++
                if self.stateCount < self.gestArr.count{
                    gest.transitionTo(self.gestArr[self.stateCount])
                }
                if (self.stateCount == self.gestArr.count) {
                    self.state = .Ended
                    return
                }
            }
        }
    }
    
    //Clear everything out so the gesture can be properly
    //detected next time.
    override func reset() {
        self.stateCount = 0
        self.rotation = 0
        for gest in self.gestArr {
            gest.reset()
        }
        if self.state == .Possible {
            self.state = .Failed
        }
    }
    
    //Mostly handling discrete gestures.  This gets called when a touch is lifted
    //from the interface
    override func touchesEnded(touches: NSSet!, withEvent event: UIEvent!) {
        let touch = event.allTouches()?.allObjects
        var gest = self.gestArr[self.stateCount]
        if gest is Swipe {
            if gest.done == true {
                self.stateCount++
                if self.stateCount < self.gestArr.count{
                    gest.transitionTo(self.gestArr[self.stateCount])
                }
                if (self.stateCount == self.gestArr.count) {
                    self.state = .Ended
                    return
                }
            } else if gest.begin == true {
                self.reset()
                return
            }
        } else if gest is Tap {
            return
        } else if let press = gest as? Press {
            press.fire(touch![0].locationInView(self.view))
            if press.done == false {
                self.reset()
                return
            } else {
                self.stateCount++
            }
            if (self.stateCount == self.gestArr.count) {
                self.state = .Ended
                return
            }
        } else if let simultaneous = gest.gestures {
            return
        //If finger is lifted from Rotate or Pan, the gesture fails
        }else {
            self.reset()
        }
    }
    
    //In case something weird happens to a touch, this gets called and 
    //resets everything
    override func touchesCancelled(touches: NSSet!, withEvent event: UIEvent!) {
        self.reset()
    }
    
    //Takes a variable amount Gesture objects as parameters and stores them
    //into self.gestArr to be used by the DSL object that is returned
    func doGesture(gestures: Gesture...) -> DSL {
        for gesture in gestures {
            self.gestArr.append(gesture)
        }
        return self
    }
}

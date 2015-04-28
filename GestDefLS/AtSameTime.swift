//
//  AtSameTime.swift
//
//  Subclass of Gesture that stores multitouch gestures.
//

import Foundation

class AtSameTime: Gesture {
    
    //takes variable amount of Gesture objects
    //and stores them into its array of gestures
    init (gestures: Gesture...) {
        super.init()
        self.gestures = gestures
    }
    
    //check for completion status of
    //Gesture objects
    override func isDone(){
        var tempDone = true
        for substate in self.gestures! {
            if substate.done == false {
                tempDone = false
            }
        }
        self.done = tempDone
    }
    
    //reset gestures back to their original
    //values
    override func reset() {
        self.done = false
        for gest in self.gestures! {
            gest.reset()
        }
    }
}
//
//  Tap.swift
//
//  Subclass of Gesture that allows for detection
//  of a "tap" gesture.
//

import Foundation
class Tap:Gesture {
    
    var numberOfTapsRequired = 1
    
    //initializes to values of a Gesture object
    //and sets its function as tapCall()
    override init(){
        super.init()
        function = tapCall()
    }
    //initializer that allows numberOfTapsRequired to be set
    init(numberOfTapsRequired:Int){
        super.init()
        self.numberOfTapsRequired = numberOfTapsRequired
        function = tapCall()
    }
    
    //returns the function that detects a pan gesture.
    //no touch movement so func f just sets done to true
    //when a tap gesture is being detected
    func tapCall() -> (CGPoint) -> () {
        func f (touch: CGPoint) {
            self.done = true
        }
        return f
    }
}
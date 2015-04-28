//
//  ViewController.swift
//  GestDefLS
//

/*
Copyright (c) 2010, 2011 Ray Wenderlich
Permission is hereby granted, free of charge, to any person obtaining a copy of this software to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import UIKit
import AVFoundation

class ViewController: UIViewController, UIGestureRecognizerDelegate {
  @IBOutlet var monkeyPan: UIPanGestureRecognizer!
  @IBOutlet var bananaPan: UIPanGestureRecognizer!
  var chompPlayer:AVAudioPlayer? = nil
  var hehePlayer:AVAudioPlayer? = nil
    var count = 0
    
  func loadSound(filename:NSString) -> AVAudioPlayer {
    let url = NSBundle.mainBundle().URLForResource(filename, withExtension: "caf")
    var error:NSError? = nil
    let player = AVAudioPlayer(contentsOfURL: url, error: &error)
    if error != nil {
      println("Error loading \(url): \(error?.localizedDescription)")
    } else {
      player.prepareToPlay()
    }
    return player
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    //1
    let filteredSubviews = self.view.subviews.filter({
      $0.isKindOfClass(UIImageView) })
    
    // 2
    for view in filteredSubviews  {
      // 3
      let recognizer = UITapGestureRecognizer(target: self, action:Selector("handleTap:"))
      // 4
      recognizer.delegate = self
      view.addGestureRecognizer(recognizer)

        let recognizer2 = DSL(target: self, action: Selector("rotation:"))
            .doGesture(
                Swipe(direction: .Left),
                Swipe(direction: .Right),
                Swipe(direction: .Left)
            )
        recognizer2.delegate = self
        view.addGestureRecognizer(recognizer2)
        
        let recognizer3 = DSL(target: self, action: Selector("rotation:"))
            .doGesture(
                Tap(numberOfTapsRequired: 3),
                Rotate(midPoint: view.convertPoint(view.center, fromCoordinateSpace: self.view), degrees: 90)
            )
        recognizer3.delegate = self
        view.addGestureRecognizer(recognizer3)
        
        let recognizer4 = DSL(target: self, action: Selector("rotation:"))
            .doGesture(
                AtSameTime(gestures:
                    Press(),
                    Pan(direction: .Right)
                )
            )
        recognizer4.delegate = self
        view.addGestureRecognizer(recognizer4)
        recognizer.requireGestureRecognizerToFail(recognizer3)
        
    }
    self.chompPlayer = self.loadSound("chomp")
    self.hehePlayer = self.loadSound("hehehe1")
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  
  @IBAction func handlePan(recognizer:UIPanGestureRecognizer) {
    //comment for panning
    //uncomment for tickling
    return;
    
    let translation = recognizer.translationInView(self.view)
    recognizer.view!.center = CGPoint(x:recognizer.view!.center.x + translation.x,
      y:recognizer.view!.center.y + translation.y)
    recognizer.setTranslation(CGPointZero, inView: self.view)
    
    if recognizer.state == UIGestureRecognizerState.Ended {
      // 1
      let velocity = recognizer.velocityInView(self.view)
      let magnitude = sqrt((velocity.x * velocity.x) + (velocity.y * velocity.y))
      let slideMultiplier = magnitude / 200
      println("magnitude: \(magnitude), slideMultiplier: \(slideMultiplier)")
      
      // 2
      let slideFactor = 0.1 * slideMultiplier     //Increase for more of a slide
      // 3
      var finalPoint = CGPoint(x:recognizer.view!.center.x + (velocity.x * slideFactor),
        y:recognizer.view!.center.y + (velocity.y * slideFactor))
      // 4
      finalPoint.x = min(max(finalPoint.x, 0), self.view.bounds.size.width)
      finalPoint.y = min(max(finalPoint.y, 0), self.view.bounds.size.height)
      
      // 5
      UIView.animateWithDuration(Double(slideFactor * 2),
        delay: 0,
        // 6
        options: UIViewAnimationOptions.CurveEaseOut,
        animations: {recognizer.view!.center = finalPoint },
        completion: nil)
    }
  }
  
  @IBAction func handlePinch(recognizer : UIPinchGestureRecognizer) {
    /*recognizer.view!.transform = CGAffineTransformScale(recognizer.view!.transform,
      recognizer.scale, recognizer.scale)
    recognizer.scale = 1*/
  }
  
  @IBAction func handleRotate(recognizer : UIRotationGestureRecognizer) {
    recognizer.view!.transform = CGAffineTransformRotate(recognizer.view!.transform, recognizer.rotation)
    recognizer.rotation = 0
  }
  
  
  
  func gestureRecognizer(UIGestureRecognizer,
    shouldRecognizeSimultaneouslyWithGestureRecognizer:UIGestureRecognizer) -> Bool {
      return true
  }
  
  func handleTap(recognizer: UITapGestureRecognizer) {
    //self.chompPlayer?.play()
  }
  
  func handleTickle(recognizer:UISwipeGestureRecognizer) {
    self.hehePlayer?.play()
  }
    
    

  func rotation(recognizer: DSL) {
    var monkeyTransform:CGAffineTransform = recognizer.view!.transform
    var newMonkeyTransform:CGAffineTransform = CGAffineTransformRotate(monkeyTransform, recognizer.rotation)
    recognizer.view!.transform = newMonkeyTransform
    if recognizer.state == .Ended {
        self.hehePlayer?.play()
        recognizer.rotation = 0
    }
    if recognizer.rotation == 0 {
        recognizer.view!.transform = CGAffineTransformIdentity
    }
  }
}


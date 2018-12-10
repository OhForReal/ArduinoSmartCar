//
//  ViewController.swift
//  ArduinoSmartCar
//
//  Created by Jian Guo on 11/14/18.
//  Copyright © 2018 SMU. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {
    
    let motionManager = CMMotionManager()

    @IBOutlet weak var directionLabel: UILabel!
    var timer: Timer!
    
    var preRoll = 0.0
    var prePitch = 0.0
    var preYaw = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if motionManager.isDeviceMotionAvailable {
//            motionManager.startDeviceMotionUpdates()
//            //var data = motionManager.deviceMotion
//
//            motionManager.startDeviceMotionUpdates(
//                to: OperationQueue.current!, withHandler: {
//                    (deviceMotion, error) -> Void in
//
//                    if(error == nil) {
//                        self.handleDeviceMotionUpdate(deviceMotion: deviceMotion!)
//                    } else {
//                        //handle the error
//                    }
//            })
//        }
        
       
    }
    
    func degrees(radians:Double) -> Double {
        return 180 / .pi * radians
    }
    
    func handleDeviceMotionUpdate(deviceMotion:CMDeviceMotion) {
        let attitude = deviceMotion.attitude
        let roll = degrees(radians: attitude.roll)
        if (roll > preRoll + 10 || roll < preRoll - 10) {
            if (roll > preRoll) {
                self.directionLabel.text = "forward"
            } else {
                self.directionLabel.text = "back"
            }
            preRoll = roll
        }
        let pitch = degrees(radians: attitude.pitch)
        if (pitch > prePitch + 10 || pitch < prePitch - 10) {
            if (pitch > prePitch) {
                self.directionLabel.text = "left"
            } else {
                self.directionLabel.text = "right"
            }
            prePitch = pitch
            //print("pitch " + String(pitch))
        }
        let yaw = degrees(radians: attitude.yaw)
        if (yaw > preYaw + 10 || yaw < preYaw - 10) {
            preYaw = yaw
            print("yaw " + String(yaw))
        }
    }

    
    
    
    @objc func update() {
        if let accelerometerData = motionManager.accelerometerData {
            print(accelerometerData)
        }
        if let gyroData = motionManager.gyroData {
            print(gyroData)
        }
        if let magnetometerData = motionManager.magnetometerData {
            print(magnetometerData)
        }
        if let deviceMotion = motionManager.deviceMotion {
            print(deviceMotion)
        }
    }
    
    func radiansToDegrees(_ radians: Double) -> Double {
        return radians * (180.0 / Double.pi)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppUtility.lockOrientation(.landscape)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AppUtility.lockOrientation(.all)
    }
    
}


struct AppUtility {
    
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.orientationLock = orientation
        }
    }
    
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation:UIInterfaceOrientation) {
        self.lockOrientation(orientation)
        UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
    }
    
}

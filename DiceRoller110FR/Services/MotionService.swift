//
//  MotionService.swift
//  DiceRoller110FR
//
//  Created by Jonathan Heinzman on 7/31/26.
//

import Foundation
import CoreMotion

class MotionService {
    
    private let motionManager = CMMotionManager()
    private let queue = OperationQueue()
    
    // Pass acceleration to the ViewModel
    var onAcceleration: ((Double) -> Void)?
    
    func startUpdates() {
        
        guard motionManager.isDeviceMotionAvailable else {
            return
        }
        
        motionManager.deviceMotionUpdateInterval = 0.1
        
        motionManager.startDeviceMotionUpdates(to: queue) { [weak self] motion, error in
            
            guard let motion else {
                return
            }
            
            let x = motion.userAcceleration.x
            let y = motion.userAcceleration.y
            let z = motion.userAcceleration.z
            
            // Total acceleration
            let movement = sqrt(x * x + y * y + z * z) // sqrt is square root to determine the total amount of phone movement
            
            DispatchQueue.main.async {
                self?.onAcceleration?(movement)
            }
        }
    }
    
    func stopUpdates() {
        motionManager.stopDeviceMotionUpdates()
    }
}

//
//  DiceViewModel.swift
//  DiceRoller110FR
//
//  Created by Jonathan Heinzman on 7/31/26.
//

import Foundation
import Combine

class DiceViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var dice = 0
    @Published var acceleration = 0.0
    @Published var isRunning = false
    @Published var status = "Press Start to begin"
    @Published var errorMessage: String?
    
    // MARK: - Properties
    
    private let motionService = MotionService()
    private let threshold = 1.8
    private let cooldown = 1.0
    
    private var lastShake = Date.distantPast
    
    init() {
        
        motionService.onAcceleration = { value in
            
            self.acceleration = value
            
            guard self.isRunning else {
                return
            }
            
            let secondsSinceShake = Date().timeIntervalSince(self.lastShake)
            
            if value >= self.threshold &&
                secondsSinceShake >= self.cooldown {
                
                self.rollDice()
                self.lastShake = Date()
            }
        }
    }
    
    // MARK: - Buttons
    
    func start() {
        
        guard !isRunning else {
            return
        }
        
        errorMessage = nil
        isRunning = true
        status = "Shake your phone to roll"
        
        motionService.startUpdates()
    }
    
    func stop() {
        isRunning = false
        acceleration = 0
        status = "Sensor stopped"
        
        motionService.stopUpdates()
    }
    
    func simulateShake() {
        
        guard isRunning else {
            errorMessage = "Press Start before simulating a shake."
            return
        }
        
        errorMessage = nil
        rollDice()
        lastShake = Date()
    }
    
    // MARK: - Dice
    
    private func rollDice() {
        dice = Int.random(in: 1...6)
        status = "You rolled a \(dice)!"
    }
}

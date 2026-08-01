//
//  DiceView.swift
//  DiceRoller110FR
//
//  Created by Jonathan Heinzman on 7/31/26.
//

import SwiftUI

struct DiceView: View {
    
    @StateObject private var viewModel = DiceViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                
                // MARK: - How to roll
                
                VStack(spacing: 6) {
                    HStack(spacing: 10){
                        Image(systemName: "dice.fill")
                            .font(.title)
                        
                        Text("Shake to Roll")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                    }
                    
                    
                    Text("Press Start, then shake your phone.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                
                // MARK: - Sensor Status
                
                HStack(spacing: 8) {
                    Circle()
                        .fill(
                            viewModel.isRunning
                            ? Color.green
                            : Color.red
                        )
                        .frame(width: 10, height: 10)
                    
                    Text(
                        viewModel.isRunning
                        ? "Sensor Running"
                        : "Sensor Stopped"
                    )
                    .font(.subheadline)
                    .fontWeight(.medium)
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(
                    Color.secondary.opacity(0.12),
                    in: Capsule()
                )
                
                // MARK: - Dice Card
                
                VStack(spacing: 14) {
                    Text(diceSymbol())
                        .font(.system(size: 120))
                        .scaleEffect(
                            viewModel.dice == 0
                            ? 0.9
                            : 1
                        )
                        .animation(
                            .spring(
                                response: 0.3,
                                dampingFraction: 0.6
                            ),
                            value: viewModel.dice
                        )
                    
                    if viewModel.dice == 0 {
                        Text("No roll yet")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Text("Start the sensor and shake your phone.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    } else {
                        Text("You rolled a \(viewModel.dice)!")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("Shake again to roll another number.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 30)
                .padding(.horizontal)
                .background(
                    Color.secondary.opacity(0.10),
                    in: RoundedRectangle(cornerRadius: 22)
                )
                
                // MARK: - Start and Stop
                
                HStack(spacing: 14) {
                    Button {
                        viewModel.start()
                    } label: {
                        Label("Start", systemImage: "play.fill")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(viewModel.isRunning)
                    
                    Button {
                        viewModel.stop()
                    } label: {
                        Label("Stop", systemImage: "stop.fill")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .disabled(!viewModel.isRunning)
                }
                
                // MARK: - So you can roll the dice on the simulator
                
                Button {
                    viewModel.simulateShake()
                } label: {
                    Label(
                        "Simulate Shake",
                        systemImage: "iphone.radiowaves.left.and.right"
                    )
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .disabled(!viewModel.isRunning)
                
                // MARK: - Acceleration
                
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Live Acceleration")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        
                        Text(
                            String(
                                format: "%.2f",
                                viewModel.acceleration
                            )
                        )
                        .font(.headline)
                        .monospacedDigit()
                    }
                    
                    Spacer()
                    
                    Image(systemName: "gyroscope")
                        .font(.title2)
                        .foregroundStyle(.secondary)
                }
                .padding()
                .background(
                    Color.secondary.opacity(0.08),
                    in: RoundedRectangle(cornerRadius: 16)
                )
                
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .font(.subheadline)
                        .foregroundStyle(.red)
                        .multilineTextAlignment(.center)
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Dice Roller")
            .navigationBarTitleDisplayMode(.inline)
            .onDisappear {
                viewModel.stop()
            }
        }
    }
    
    private func diceSymbol() -> String {
        switch viewModel.dice {
        case 1:
            return "⚀"
        case 2:
            return "⚁"
        case 3:
            return "⚂"
        case 4:
            return "⚃"
        case 5:
            return "⚄"
        case 6:
            return "⚅"
        default:
            return "🎲"
        }
    }
}

#Preview {
    DiceView()
}

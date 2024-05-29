//
//  PieSlice.swift
//  Game Timer
//
//  Created by Jeff Holt on 5/28/24.
//

import SwiftUI
import AVFoundation

struct TimerPieChartView: View {
    @State private var timeRemaining: Double = 10.0
    @State private var totalTime: Double = 10.0
    @State private var isActive = false
    @State private var endAngle: Angle = .degrees(0)
    @State private var timerLengthInput: String = "10"
    @State private var audioPlayer: AVAudioPlayer?
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        VStack {
            PieSlice(startAngle: .degrees(-90), endAngle: endAngle)
                .fill(Color.blue)
                .frame(width: 400, height: 400)
                .onAppear {
                    resetTimer()
                }
            
            HStack {
                TextField("Enter timer length (seconds)", text: $timerLengthInput)
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button(action: {
                    if let time = Double(timerLengthInput) {
                        totalTime = time
                        resetTimer()
                        hideKeyboard()
                    }
                }) {
                    Text("Set Timer")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
                }
                .padding()
            }
            
            Button(action: {
                startTimer()
            }) {
                Text("Start Timer")
                .foregroundColor(.white)
                .padding()
                .background(Color.green)
                .cornerRadius(8)
            }
            .padding()
        }
    }
    
    func resetTimer() {
        timeRemaining = totalTime
        endAngle = .degrees(-90)
        isActive = false
    }
    
    func startTimer() {
        resetTimer()
        isActive = true
        let timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            if self.timeRemaining > 0 {
                self.timeRemaining -= 0.1
                withAnimation(.linear(duration: 0.1)) {
                    self.endAngle = .degrees(Double((totalTime - timeRemaining) / totalTime) * 360.0 - 90)
                }
            } else {
                timer.invalidate()
                self.isActive = false
                self.playSound()
            }
        }
        timer.fire()
    }
    
    func playSound() {
        guard let soundURL = Bundle.main.url(forResource: "alarm", withExtension: "wav") else { return }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.play()
        } catch {
            print("Unable to play sound: \(error.localizedDescription)")
        }
    }
    
    func hideKeyboard() {
        isTextFieldFocused = false
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct ContentView: View {
    var body: some View {
        TimerPieChartView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


//
//  PieSlice.swift
//  Game Timer
//
//  Created by Jeff Holt on 5/28/24.
//

import AVFoundation
import SwiftUI

struct TimerPieChartView: View {
  @State private var timeRemaining: Double = 10.0
  @State private var totalTime: Double = 10.0
  @State private var isActive = false
  @State private var endAngle: Angle = .degrees(0)
  @State private var timerLengthInput: String = "10"
  @State private var audioPlayer: AVAudioPlayer?
  @State private var tickPlayer: AVAudioPlayer?
  @State private var showSettings = false
    
    var sliceColor: Color {
            return timeRemaining < 5 ? .red : .blue
        }

  var body: some View {
    VStack {
      PieSlice(startAngle: .degrees(-90), endAngle: endAngle)
            .fill(sliceColor)
        .frame(width: 400, height: 400)
        .onAppear {
          resetTimer()
        }

      Button(action: {
        showSettings = true
      }) {
        Text("Set Timer")
          .foregroundColor(.white)
          .padding()
          .background(Color.blue)
          .cornerRadius(8)
      }
      .padding()
      .sheet(isPresented: $showSettings) {
        TimerSettingsView(timerLength: $totalTime)
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
      let timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
      if self.timeRemaining > 0 {
          self.timeRemaining -= 1.0
          withAnimation(.linear(duration: 1.0)) {
          self.endAngle = .degrees(Double((totalTime - timeRemaining) / totalTime) * 360.0 - 90)
        }
          self.playTickSound()
      } else {
        timer.invalidate()
        self.isActive = false
        self.playSound()
      }
    }
    timer.fire()
  }

  func playSound() {
    guard let soundURL = Bundle.main.url(forResource: "gong", withExtension: "mp3") else { return }
    do {
      audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
      audioPlayer?.play()
    } catch {
      print("Unable to play sound: \(error.localizedDescription)")
    }
  }
  func playTickSound() {
    guard let tickURL = Bundle.main.url(forResource: "tick", withExtension: "mp3") else { return }
    do {
      tickPlayer = try AVAudioPlayer(contentsOf: tickURL)
      tickPlayer?.play()
    } catch {
      print("Unable to play tick sound: \(error.localizedDescription)")
    }
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

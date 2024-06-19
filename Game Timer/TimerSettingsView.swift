//
//  TimerSettingsView.swift
//  Game Timer
//
//  Created by Jeff Holt on 6/18/24.
//

import SwiftUI

struct TimerSettingsView: View {
    @Binding var timerLength: Double
    @Environment(\.dismiss) private var dismiss
    @State private var timerLengthInput: String = ""
    
    var body: some View {
        VStack {
            TextField("Enter timer length (seconds)", text: $timerLengthInput)
                .keyboardType(.numberPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button(action: {
                if let time = Double(timerLengthInput) {
                    timerLength = time
                    dismiss()
                    
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
        .onAppear {
            timerLengthInput = "\(Int(timerLength))"
        }
    }
    
    
}

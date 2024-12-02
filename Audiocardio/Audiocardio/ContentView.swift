//
//  ContentView.swift
//  Audiocardio
//
//  Created by GoldenBeast on 11/29/24.
//

import SwiftUI
import Audiocardiosdk
import AVFoundation

struct ContentView: View {
    @State private var selectedDuration = 10
    @State private var selectedFrequency = "High"
    @State private var isTimerRunning = false
    @State private var audioPlayer: OpaquePointer?
    @State private var remainingTime = 600 // 10 minutes in seconds
    let durations = [5, 10, 15, 20] // Available durations in minutes
    let frequencies = ["Low", "Medium", "High"]
    
    var body: some View {
        VStack {
            Text("Sound Therapy")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.top, 80)
            
            Image(systemName: "waveform.path.ecg")
                .font(.system(size: 50))
                .foregroundColor(.red)
                .padding(.vertical, 20)
            
            VStack(alignment: .center, spacing: 15) {
                Text("Select Duration")
                    .foregroundColor(.white)
                    .padding()
                
                Picker("Duration", selection: $selectedDuration) {
                    ForEach(durations, id: \.self) {
                        Text("\($0) min")
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .cornerRadius(8)
                .padding(.horizontal)
                
                Text("Select Frequency")
                    .foregroundColor(.white)
                    
                
                Picker("Frequency", selection: $selectedFrequency) {
                    ForEach(frequencies, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .cornerRadius(8)
                .padding(.horizontal)
            }
            .padding(.vertical, 20)
            
            Spacer()
            
            Circle()
                .stroke(lineWidth: 4)
                .foregroundColor(.red)
                .frame(width: 200, height: 200)
                .overlay(
                    Text(timerDisplay(remainingTime))
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.white)
                )
            
            Spacer()
            
//            Button(action: {
//                startTimer()
//            }) {
//                Text(isTimerRunning ? "STOP" : "START")
//                    .font(.headline)
//                    .frame(maxWidth: .infinity)
//                    .padding()
//                    .background(Color.red)
//                    .foregroundColor(.white)
//                    .cornerRadius(8)
//            }
//            .padding(.horizontal, 50)
//            .padding(.bottom, 50)
            
            VStack {
                Button(action: {
                    let config = sound_config_new(1000, 0, 84, true)
                    audio_player_audio_play(audioPlayer, config) //
                    
                    sound_config_free(config) // Free the config memory after use
                }) {
                    Text(isTimerRunning ? "STOP" : "START")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.horizontal, 50)
                .padding(.bottom, 50)
            }
            .onAppear {
                setupAudioSession()
                audioPlayer = audio_player_new(1.0) // Initialize Rust audio player
            }
            .onDisappear {
                if let player = audioPlayer {
                    audio_player_free(player) // Free Rust audio player
                }
            }
        }
        .background(Color.purple)
        .ignoresSafeArea()
        .onReceive(timer) { _ in
            if isTimerRunning && remainingTime > 0 {
                remainingTime -= 1
            }
        }
    }
    func setupAudioSession() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playback, mode: .default)
            try audioSession.setActive(true)
        } catch {
            print("Audio Session error: \(error)")
        }

    }
    
    // Timer logic
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    func startTimer() {
        if isTimerRunning {
            isTimerRunning = false
            remainingTime = selectedDuration * 60
        } else {
            isTimerRunning = true
            remainingTime = selectedDuration * 60
        }
    }
    
    func timerDisplay(_ time: Int) -> String {
        let minutes = time / 60
        let seconds = time % 60
        return String(format: "%02d:%02d:%02d", 0, minutes, seconds)
    }
}

#Preview {
    ContentView()
}

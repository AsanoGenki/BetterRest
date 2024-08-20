//
//  ContentView.swift
//  BetterRest
//
//  Created by Genki on 8/20/24.
//

import CoreML
import SwiftUI

struct ContentView: View {
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? .now
    }
    var body: some View {
        NavigationStack {
            Form {
                DatePicker("何時に起きたいですか?", selection: $wakeUp, displayedComponents: .hourAndMinute)
                    .font(.headline)
                    .onAppear {
                        UIDatePicker.appearance().minuteInterval = 10
                    }
                VStack(alignment: .leading, spacing: 0) {
                    Text("睡眠時間")
                        .font(.headline)
                    Stepper("\(sleepAmount.formatted()) 時間", value: $sleepAmount, in: 4...12, step: 0.25)
                }
                VStack(alignment: .leading, spacing: 0) {
                    Text("コーヒーの摂取数")
                        .font(.headline)
                    
                    Stepper("\(coffeeAmount) カップ", value: $coffeeAmount, in: 1...20)
                }
            }
            .navigationTitle("BetterRest")
            .toolbar {
                Button("計算する", action: calculateBedtime)
            }
            .alert(alertTitle, isPresented: $showingAlert) {
                Button("OK") { }
            } message: {
                Text(alertMessage)
            }
        }
    }
    func calculateBedtime() {
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            let sleepTime = wakeUp - prediction.actualSleep
            alertTitle = "理想の就寝時刻は..."
            alertMessage = sleepTime.formatted(date: .omitted, time: .shortened)
        } catch {
            alertTitle = "エラー"
            alertMessage = "申し訳ありません、就寝時刻の計算に問題が発生しました。"
        }
        showingAlert = true
    }
}

#Preview {
    ContentView()
}

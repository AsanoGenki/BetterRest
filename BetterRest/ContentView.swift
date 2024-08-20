//
//  ContentView.swift
//  BetterRest
//
//  Created by Genki on 8/20/24.
//

import SwiftUI

struct ContentView: View {
    @State private var wakeUp = Date.now
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    var body: some View {
        NavigationStack {
            VStack {
                Text("何時に起きたいですか?")
                    .font(.headline)
                DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                    .labelsHidden()
                Text("睡眠時間")
                    .font(.headline)
                Stepper("\(sleepAmount.formatted()) 時間", value: $sleepAmount, in: 4...12, step: 0.25)
                Text("コーヒーの摂取数")
                    .font(.headline)

                Stepper("\(coffeeAmount) カップ", value: $coffeeAmount, in: 1...20)
            }
            .padding()
            .navigationTitle("BetterRest")
            .toolbar {
                Button("計算する", action: calculateBedtime)
            }
        }
    }
    func calculateBedtime() {
    }
}

#Preview {
    ContentView()
}

//
//  ContentView.swift
//  UI3-BetterRest
//
//  Created by Sothesom on 14/09/1403.
//

import CoreML
import SwiftUI

struct ContentView: View {
    @State private var wakeUp = timeWakeUp
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    
    @State private var alertTitle = ""
    @State private var alerteMesseg = ""
    @State private var showingAlert = false
    
    static var timeWakeUp : Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? .now
    }
    
    var body: some View {
        NavigationStack{
            Form{
                VStack (alignment: .leading, spacing: 0) {
                    Text("کی میخوای بخوابی؟")
                        .font(.headline)
                    DatePicker("لطفا تایم خواب خود را مشخص کنید", selection: $wakeUp, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                }
                
                VStack (alignment: .leading, spacing: 0) {
                    Text("چقدر میخوای بخوابی؟")
                        .font(.headline)
                    Stepper("\(sleepAmount.formatted()) ساعت", value: $sleepAmount, in: 2...12 , step: 0.25)
                }
                
                VStack (alignment: .leading, spacing: 0) {
                    Text("چند شات قهوه زدی؟")
                        .font(.headline)
                    Stepper(coffeeAmount == 1 ? "1 cup" : " \(coffeeAmount.formatted()) cups", value: $coffeeAmount, in: 1...12 , step: 1)
                }
            }
            .navigationTitle("Better Rest")
            .toolbar(){
                Button("حساب کن", action: calculateBedtime)
            }
            .alert(alertTitle ,isPresented: $showingAlert) {
                Button("OK") { }
            } message: {
                Text(alerteMesseg )
            }
        }
    }
    func calculateBedtime() {
        do{
            let cofig = MLModelConfiguration()
            let model = try SleepCalculator(configuration: cofig)
             
            let components = Calendar.current.dateComponents([.hour , .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            let sleepTime = wakeUp - prediction.actualSleep
            
            alertTitle = "بهترین زمان برای خوابیدن"
            alerteMesseg = sleepTime.formatted(date: .omitted, time: .shortened)
        } catch {
            alertTitle = "Error"
            alerteMesseg = "Sorry, there was a problem calculating your bedtime."
        }
        showingAlert = true
    }
}
#Preview {
    ContentView()
}

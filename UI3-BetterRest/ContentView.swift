//
//  ContentView.swift
//  UI3-BetterRest
//
//  Created by Sothesom on 14/09/1403.
//

import SwiftUI
struct ContentView: View {
    @State private var SleepTime = 8.0
    @State private var DateTime = Date.now
    
    var body: some View {
        Stepper("\(SleepTime.formatted()) ساعت", value: $SleepTime, in: 4...12, step: 0.25)
        
        DatePicker("تاریخ", selection: $DateTime, displayedComponents: .hourAndMinute)
            .labelsHidden()
        
        DatePicker("تاریخ", selection: $DateTime)
            .labelsHidden()
        
        DatePicker("تاریخ", selection: $DateTime, in: Date.now...)
            
        Text(Date.now , format: .dateTime.day().month().year())
        Text(Date.now.formatted(date: .long, time: .shortened))
    }
    
    func exampledate(){
        let complate = Calendar.current.dateComponents([.hour, .minute], from: .now)
        let hour = complate.hour ?? 0
        let minute = complate.minute ?? 0
    }
}
#Preview {
    ContentView()
}

//
//  ContentView.swift
//  Multiplication
//
//  Created by slava bily on 13/3/20.
//  Copyright © 2020 slava bily. All rights reserved.
//

import SwiftUI

struct Question {
    
}

struct ContentView: View {
    
    var questionsQuantity = ["5", "10", "20", "All"]
    
    @State private var selectedQuestQuantity = 0
    @State private var table = 1
    @State private var question = ""
    @State private var answer = ""
    @State private var isGameRunning = false
    
    var body: some View {
        
        Group {
            Text("Please, select quantity of multiplication tables")
            
            if self.table < 2 {
                Stepper("Up to ... \(table) table selected", value: $table, in: 1 ... 9)
            } else {
                Stepper("Up to ... \(table) tables selected", value: $table, in: 1 ... 9)
            }
            
            Spacer(minLength: 50)
            
            Text("Please, select how many questions you want to be asked")
            
            Picker(selection: $selectedQuestQuantity, label: Text("\(questionsQuantity[selectedQuestQuantity]) question selected")) {
                ForEach(0 ..< questionsQuantity.count) {
                    Text(self.questionsQuantity[$0])
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            
            Spacer()
            
            Button("Go") {
                self.start()
            }
            .font(.largeTitle)
            
            Form {
                Text("Question: \(question)")
                TextField("Answer:", text: $answer)
            }
        }
    }
    
    func start() {
        self.isGameRunning.toggle()
    }
    
 }

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

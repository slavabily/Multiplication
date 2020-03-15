//
//  ContentView.swift
//  Multiplication
//
//  Created by slava bily on 13/3/20.
//  Copyright © 2020 slava bily. All rights reserved.
//

import SwiftUI

struct Question {
    
    var tableNumber: Int
    var multiplier: Int
    
    var question: String {
        return "What is \(tableNumber) x \(multiplier) ?"
    }
    
    var answer: Int {
        return tableNumber * multiplier
    }
}

struct ContentView: View {
    
    @State var questions = [String]()
    @State var answers = [Int]()
    
    var howManyQuestions = ["5", "10", "20", "All"]
    @State private var selectedQuestQuantity = 0
    
    var selectedQuestionsLimit: Int {
        let selected = howManyQuestions[selectedQuestQuantity]
        return Int(selected) ?? 0
    }
    
    @State private var remainingQuestionsQuantity = 0
    
    @State private var currentQuestionNumber = 1
    
    @State private var table = 1
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
            
            Picker(selection: $selectedQuestQuantity, label: Text("\(howManyQuestions[selectedQuestQuantity]) question selected")) {
                ForEach(0 ..< howManyQuestions.count) {
                    Text(self.howManyQuestions[$0])
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            
            Spacer()
            
            Button("Go") {
                self.start()
            }
            .font(.largeTitle)
            
            Form {
                if isGameRunning == true {
                    Text("Question: \(questions[currentQuestionNumber])")
                } else {
                    Text("Question: ")
                }
                if isGameRunning == true {
                    TextField("Answer:", text: $answer) {
                        self.acceptAnswer(self.answer)
                        self.answer = ""
                    }
                }
            }
        }
    }
    
    func start() {
        
        for i in 1 ... 10 {
            let question = Question(tableNumber: table, multiplier: i)
            questions.append(question.question)
            answers.append(question.answer)
        }
        print("Array of questions: \(questions)")
        print("Answers array: \(answers)")
        
        self.isGameRunning = true
        
        remainingQuestionsQuantity = selectedQuestionsLimit
        
       asking(questions: remainingQuestionsQuantity)
    }
    
    func asking(questions quantity: Int) {
        
        if quantity > 0 {
            currentQuestionNumber = Int.random(in: 0 ... (selectedQuestionsLimit - 1))
            print("Current question number: \(currentQuestionNumber)")
        } else {
            self.isGameRunning = false
            print("Game End")
        }
        remainingQuestionsQuantity -= 1
    }
    
    func acceptAnswer(_ answer: String) {
        
        print("Answer: \(answer)")
        
        if answer != "" {
            if let answerNumber = answers.firstIndex(of: Int(answer)!) {
                if answerNumber == currentQuestionNumber {
                    print("Correct!")
                } else {
                    print("Wrong!")
                }
            } else {
                print("Something wrong with tables of data")
                return
            }
            asking(questions: remainingQuestionsQuantity)
        } else {
            print("Could not find an answer!")
        }
    }
 }

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

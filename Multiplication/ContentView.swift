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
    var answer: String {
        return String(tableNumber * multiplier)
    }
}

struct ContentView: View {
    
    @State var questions = [String]()
    @State var answers = [String]()
    
    var howManyQuestions = ["5", "10", "20", "All"]
    @State private var selectedQuestQuantity = 0
    
    var selectedQuestionsLimit: Int {
        let selected = howManyQuestions[selectedQuestQuantity]
        return Int(selected) ?? 30
    }
    
    @State private var remainingQuestionsQuantity = 0
    @State private var currentQuestionNumber = 1
    
    @State private var table = 1
    @State private var answer = ""
    @State private var correctAnswers = 0
    
    @State private var isGameRunning = false
    @State private var isWaitingForNextQuest = false
    @State private var isFinalAlertShowing = false
    @State private var isAnswerAlertShowing = false
    @State private var answerTitle = ""
    @State private var answerMessage = ""
    
    var body: some View {
        NavigationView {
            Form {
                if isGameRunning == false {
                    Group {
                        Text("Please, select quantity of multiplication tables")
                        
                        if self.table < 2 {
                            Stepper("Up to ... \(table) table selected", value: $table, in: 1 ... 9)
                        } else {
                            Stepper("Up to ... \(table) tables selected", value: $table, in: 1 ... 9)
                        }
                        
                        Spacer(minLength: 30)
                        
                        Text("Please, select how many questions you want to be asked")
                        
                        Picker(selection: $selectedQuestQuantity, label: Text("\(howManyQuestions[selectedQuestQuantity]) question selected")) {
                            ForEach(0 ..< howManyQuestions.count) {
                                Text(self.howManyQuestions[$0])
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        
                        Button("Play") {
                            self.start()
                        }
                        .font(.largeTitle)
                    }
                } else {
                    Group {
                        if isWaitingForNextQuest == false {
                            Text("Question \(selectedQuestionsLimit - remainingQuestionsQuantity): \(questions[currentQuestionNumber])")
                            
                            HStack {
                                TextField("Answer:", text: $answer) {
                                    self.acceptAnswer(self.answer)
                                    self.answer = ""
                                }
                                .keyboardType(.numberPad)
                                
                                Button("Submit") {
                                    self.isWaitingForNextQuest = true
                                    self.acceptAnswer(self.answer)
                                    self.answer = ""
                                }
                                .font(.headline)
                            }
                        }
                    }
                }
            }
            .navigationBarTitle("Multiplication Quest")
            .alert(isPresented: $isAnswerAlertShowing) {
                Alert(title: Text(answerTitle), message: Text(answerMessage), dismissButton: .default(Text("Continue"), action: {
                    self.asking(questions: self.remainingQuestionsQuantity)
                    self.isWaitingForNextQuest = false
                }))
            }
        }
        .alert(isPresented: $isFinalAlertShowing) {
            Alert(title: Text("You've got correct \(correctAnswers) questions"), message: Text("Would you like to play again?"), dismissButton: .default(Text("Ok")))
        }
    }
    
    func start() {
        questions.removeAll()
        answers.removeAll()
        
        for j in 1 ... table {
            for i in 1 ... 10 {
                let question = Question(tableNumber: j, multiplier: i)
                questions.append(question.question)
                answers.append(question.answer)
            }
        }
        print("Array of questions: \(questions)")
        print("Answers array: \(answers)")
        
        remainingQuestionsQuantity = selectedQuestionsLimit
        
       asking(questions: remainingQuestionsQuantity)
    }
    
    func asking(questions quantity: Int) {
        
        self.isGameRunning = true
        
        if quantity > 0 {
            currentQuestionNumber = Int.random(in: 0 ... (table * 10 - 1))
            print("Current question number: \(currentQuestionNumber)")
        } else {
            self.isGameRunning = false
            self.isFinalAlertShowing = true
            print("Game End")
        }
        remainingQuestionsQuantity -= 1
    }
    
    func acceptAnswer(_ answer: String) {
        
        print("Answer: \(answer)")
        
        let answerValue = answers[currentQuestionNumber]
        if answer == answerValue {
            correctAnswers += 1
            print("Correct!")
            answerTitle = "Correct!"
            answerMessage = ""
        } else {
            print("Wrong!")
            answerTitle = "Wrong!"
           answerMessage = "Correct answer is: \(answerValue)"
        }
         isAnswerAlertShowing = true
     }
 }

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

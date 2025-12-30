//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Instant System iOS Team on 27/12/2025.
//

import SwiftUI

struct ContentView: View {
  @State var countries = Country.all().shuffled()
  
  @State var correctAnswer = Int.random(in: 0...2)
  
  @State var shouldShowAlertAnswer: Bool = false
  @State var answerAlertTitle: String = ""
  @State var answerAlertMessage: String = ""
  
  @State var userScore: Int = 0
  @State var numberOfQuestionsAnswered: Int = 0
  @State var skippedQuestions: Int = 0
  
  let gameMaximumQuestion = 8
  @State var gameFinishedAlertTitle: String = ""
  @State var gameFinishedAlertMessage: String = ""
  @State var shouldShowAlertGameFinished: Bool = false
  
  var numberOfRemainingQuestions: Int {
    gameMaximumQuestion - (numberOfQuestionsAnswered + skippedQuestions)
  }

  
  @ViewBuilder
  var conditionalNumberOfQuestionsSkippedView: some View {
    if skippedQuestions == 0 {
      EmptyView()
    } else {
      Spacer()
      Text("Skipped questions: \(skippedQuestions)")
    }
    
  }
  
  @ViewBuilder
  var conditionalNumberOfRemainingQuestionsView: some View {
    if numberOfRemainingQuestions == 0 {
      EmptyView()
    } else {
      Text("\(gameMaximumQuestion - (numberOfQuestionsAnswered + skippedQuestions)) Remaining questions")
    }
    
  }
  
  var body: some View {
    ZStack {
      //      Color.gray
      //        .opacity(0.25)
      //        .ignoresSafeArea()
      
      LinearGradient(colors: [.gray, .clear], startPoint: .top, endPoint: .bottom)
        .ignoresSafeArea()
            
      VStack {
        
        Spacer()

        VStack {
          Text("Tap the flag of")
            .font(.subheadline.weight(.heavy))
          
          Text(countries[correctAnswer])
            .font(.largeTitle.weight(.bold))
        }
        
        Spacer()
        
        VStack(spacing: 10) {
          ForEach(0..<3, id: \.self) { number in
            Button {
              flagTapped(number)
            }
            label: {
              Image(countries[number])
                .shadow(color: .red, radius: 5)
              //                .clipShape(.capsule)
            }
            .alert(answerAlertTitle, isPresented: $shouldShowAlertAnswer) {
              Button("Close", role: .cancel) {
                askQuestion()
              }
            } message: {
              Text(answerAlertMessage)
            }
            .alert(gameFinishedAlertTitle, isPresented: $shouldShowAlertGameFinished) {
              Button("Close", role: .cancel) {}
            } message: {
              Text(gameFinishedAlertMessage)
            }
          }
          .padding()
        }
        .background(.regularMaterial)
        .cornerRadius(20)
        
        Spacer()
        VStack(spacing: 10) {
          
          HStack {
            Text("Your score: \(userScore) / \(numberOfQuestionsAnswered)")
            conditionalNumberOfQuestionsSkippedView
          }
          
          conditionalNumberOfRemainingQuestionsView
        }
        .padding()
        
        Spacer()
        
        Button("Ask another question") {
          skippedQuestions = min(1 + skippedQuestions, gameMaximumQuestion - numberOfQuestionsAnswered)

          guard handleGameSessionFinishedIfNeeded() == false else { return }
          
          askQuestion()
        }
        
        Button("Reset counter", role: .destructive) {
          resetGameCounter()
        }
        .padding()
        
        Spacer()
        
      }
      
    }
  }
  
  
  func flagTapped(_ number: Int) {
    
    numberOfQuestionsAnswered = min(1 + numberOfQuestionsAnswered, gameMaximumQuestion - skippedQuestions)
    
    let gameSessionIsAlive = !handleGameSessionFinishedIfNeeded()
    
    if number == correctAnswer && gameSessionIsAlive {
      userScore += 1
      answerAlertTitle = "✅"
      answerAlertMessage = "Congrats! You got it right!"
    } else {
      answerAlertTitle = "❌"
      answerAlertMessage = "Better luck next time!"
    }
    
    guard gameSessionIsAlive == true else { return }

    shouldShowAlertAnswer = true
  }
  
  func askQuestion() {
    countries = countries.shuffled()
    correctAnswer = Int.random(in: 0...2)
  }
  
  func resetGameCounter() {
    countries = countries.shuffled()
    correctAnswer = Int.random(in: 0...2)
    userScore = 0
    numberOfQuestionsAnswered = 0
    skippedQuestions = 0
  }
  
  func handleGameSessionFinishedIfNeeded() -> Bool {
    
    if numberOfQuestionsAnswered + skippedQuestions >= gameMaximumQuestion {
      gameFinishedAlertTitle = "This session is over. You got \(userScore)/ \(gameMaximumQuestion)"
      gameFinishedAlertMessage = "💪 You can reset the counter if you want to play again."
      shouldShowAlertGameFinished = true
      return true
    }
    return false
  }
  
}





#Preview {
  ContentView()
}

//
//  TutorialView.swift
//  GuessTheFlag
//
//  Created by Instant System iOS Team on 29/12/2025.
//

import SwiftUI

struct TutorialView: View {
  @State private var shouldShowAlert: Bool = false
  @Environment(\.dismiss) var dismiss
  
  var grid3x3view: some View {
    VStack {
      Spacer()
      Spacer()
      Spacer()
      Spacer()
      Spacer()
      
      HStack {
        ZStack {
          Rectangle()
            .fill(Color.blue)
          Text("1")
        }
        
        ZStack {
          Rectangle()
          Text("2")
        }
        ZStack {
          Rectangle()
            .fill(.red)
          Text("3")
        }
      }
      HStack {
        ZStack {
          Rectangle()
          Text("1")
        }
        ZStack {
          Rectangle()
            .fill(Color.blue)
          Text("2")
        }
        ZStack {
          Rectangle()
          Text("3")
        }
      }
      HStack {
        ZStack {
          Rectangle()
            .fill(.red)
          
          Text("1")
        }
        ZStack {
          Rectangle()
          Text("2")
        }
        ZStack {
          Rectangle()
            .fill(Color.blue)
          Text("3")
        }
      }
      Spacer()
      Spacer()
      Spacer()
      Spacer()
      Spacer()
    }
    .padding()
  }
  
  var zStackAndPaddingsView: some View {
    Group {
      ZStack(alignment: .leading) {
        Text("Text 1111111111111111111")
          .foregroundStyle(.red)
          .padding()
          .background(.ultraThinMaterial)
        
        Text("Text 111111111111")
          .foregroundStyle(Color.blue)
        Text("Text 1111111")
          .foregroundStyle(.green)
      }
      .padding()
      
      ZStack(alignment: .top) {
        Circle()
          .border(.red, width: 2)
        
        
        Circle()
          .frame(width: 100, height: 100)
          .border(.yellow, width: 2)
          .foregroundStyle(Color.blue)
        
        Text("Second Zstack")
          .foregroundStyle(.green)
          .frame(width: .infinity, height: .infinity)
      }
      .padding()
      
      ZStack {
        //      Color.green
        Text("Hello, World!")
      }
      .frame(width: 250, height: 250)
      .background(.cyan)
      .border(.red, width: 5)
      .padding()
      .background(.mint)
      .border(.red, width: 5)
      .frame(width: 290, height: 290)
      .background(.black)
      .border(.green, width: 2)
    }
    
  }
  
  var linearGradientsView: some View {
    VStack() {
      LinearGradient(colors: [.blue, .red, .green, .black], startPoint: .bottomTrailing, endPoint: .topLeading)
      LinearGradient(colors: [.blue, .red, .green, .black], startPoint: .topLeading, endPoint: .bottomTrailing)
      LinearGradient(stops: [
        .init(color: .black, location: 0.1),
        .init(color: .gray, location: 0.2)
      ], startPoint: .bottom, endPoint: .top)
      LinearGradient(gradient: .init(colors: [.yellow, .black]), startPoint: .leading, endPoint: .trailing)
    }
  }
  
  var radialGradientsView: some View {
    VStack() {
      RadialGradient(gradient: .init(colors: [.blue, .red, .green, .black, .purple]), center: .center, startRadius: 0, endRadius: 100)
      RadialGradient(gradient: Gradient(colors: [.blue, .red, .green, .black]), center: .center, startRadius: 50, endRadius: 100)
      RadialGradient(colors: [.red, .brown], center: .center, startRadius: 0, endRadius: 100)
      RadialGradient(stops: [
        .init(color: .green, location: 0.2),
        .init(color: .orange, location: 0.5),
        .init(color: .mint, location: 0.8)
      ], center: .center, startRadius: 10, endRadius: 90)
    }
  }
  
  var angularGradientsView: some View {
    VStack() {
      AngularGradient(gradient: .init(colors: [.blue, .red, .green, .black, .purple]), center: .center, startAngle: .degrees(0), endAngle: .degrees(360))
      AngularGradient(gradient: Gradient(colors: [.blue, .red, .green, .black]), center: .center, startAngle: .degrees(10), endAngle: .degrees(45))
    }
  }
  
  var simpleColorGradient: some View {
    Text("Hello world")
      .frame(width: 500, height: 500)
      .background(.yellow.gradient)
      .foregroundStyle(.primary)
  }
  
  var body: some View {
    Button(role: .destructive, action: {
      print("tapped!")
      shouldShowAlert = true
    }, label: {
      Label("Tap me", systemImage: "pencil.circle.fill")
    })
//    .border(.black, width: 2)
//    .background(.yellow)
    .buttonStyle(.bordered)
    .tint(Color.red)
    .alert("Got your click", isPresented: $shouldShowAlert) {
      Button("Close", role: .cancel) {}
      Button("OK", role: .destructive) {}
    } message: {
      Text("Are you kidding me")
    }
//    .padding()
//    .background(.blue)
//    .cornerRadius(30)
//    .colorInvert()
  }
  
  
}


#Preview {
  TutorialView()
}

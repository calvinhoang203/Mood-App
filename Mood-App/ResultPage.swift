//
//  CowLoadingPage.swift
//  CowLoadingPage
//
//  Created by Manushri Rane on 4/22/25.
//

import SwiftUI

struct ResultPage: View {
    var body: some View {
        ZStack {
            // set up gradient in background
            ZStack {
                LinearGradient(
                    stops: [
                        .init(color: Color(red: 0.98, green: 0.67, blue: 0.27).opacity(0), location: 0.00),
                        .init(color: Color(red: 0.98, green: 0.67, blue: 0.27), location: 0.48),
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                LinearGradient(
                    stops: [
                        .init(color: Color(red: 0.9, green: 0.88, blue: 0.96).opacity(0), location: 0.00),
                        .init(color: Color(red: 0.9, green: 0.88, blue: 0.96), location: 0.78),
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            }
            .ignoresSafeArea()
            
            // add cow image
            VStack(spacing: 16) {
                Image("Result Cow")
                
                // add text under
                (
                    Text("Thanks for checking in!\nYou’ve earned ")
                        .font(Font.custom("Alexandria", size: 20))
                    +
                    Text("30")
                        .font(Font.custom("Alexandria", size: 20).weight(.bold))
                    +
                    Text(" points.")
                        .font(Font.custom("Alexandria", size: 20).weight(.bold))
                )
                .multilineTextAlignment(.center)
                .foregroundColor(.black)
                .padding(.horizontal, 30)
            }
            // button that should transport user home
                        Button(action: {
                            print("Button tapped!")
                        }) {
                            Text("Return Home")
                                .font(.headline)
                                .padding(.horizontal, 28)
                                .padding(.vertical, 5)
                                .foregroundColor(.white)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                                    .fill(Color(red: 0.56, green: 0.51, blue: 0.86))
                                                    
                                )
                                
                                .cornerRadius(10)
                        }
            .padding(.top, 320)
        }
    }
}

#Preview {
    ContentView()
}


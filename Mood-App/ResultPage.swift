//
//  CowLoadingPage.swift
//  CowLoadingPage
//
//  Created by Manushri Rane on 4/22/25.
//

import SwiftUI

struct ResultPage: View {
    @EnvironmentObject var storeData: StoreData
    @Environment(\.dismiss) private var dismiss
    @State private var showHomeView = false
    
    var pointsEarned: Int
    
    var body: some View {
        NavigationStack {
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
                        Text("Thanks for checking in!\nYou've earned ")
                        .font(Font.custom("Alexandria-Regular", size: 20))
                    +
                        Text("\(pointsEarned)")
                        .font(Font.custom("Alexandria-Regular", size: 20).weight(.bold))
                    +
                    Text(" points.")
                        .font(Font.custom("Alexandria-Regular", size: 20).weight(.bold))
                )
                .multilineTextAlignment(.center)
                .foregroundColor(.black)
                .padding(.horizontal, 30)
                    
                    Spacer()
                    
            // button that should transport user home
                        Button(action: {
                        showHomeView = true
                        }) {
                            Text("Return Home")
                                .font(.headline)
                                .padding(.horizontal, 28)
                            .padding(.vertical, 8)
                                .foregroundColor(.white)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                                    .fill(Color(red: 0.56, green: 0.51, blue: 0.86))
                                )
                                .cornerRadius(10)
                        }
                    .padding(.bottom, 50)
                }
                .padding(.top, 50)
            }
            .navigationDestination(isPresented: $showHomeView) {
                HomeView()
                    .environmentObject(storeData)
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    ResultPage(pointsEarned: 50)
        .environmentObject(StoreData.demo)
}


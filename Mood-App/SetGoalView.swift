//
//  SetGoalView.swift
//  Mood-App
//
//  Created by Hieu Hoang on 4/22/25.
//

import SwiftUI
import UIKit

struct SetGoalView: View {
    // ── Navigation State ─────────────────────────────────────────────
    @State private var showGoalFlow     = false
    @State private var showCheckInFlow  = false
    @State private var showHomeNav      = false
    @State private var showResource     = false
    @State private var showSetGoal      = false
    @State private var showAnalyticsNav = false
    @State private var showSettingNav   = false

    // ── Layout Constants ─────────────────────────────────────────────
    private let navBarHeight: CGFloat = 64
    private let topPadding: CGFloat   = 80
    private let iconSize: CGFloat     = 60
    private let buttonHeight: CGFloat = 44
    private let columnSpacing: CGFloat = 40
    private let rowSpacing: CGFloat    = 16
    private let descriptionWidth: CGFloat = 120

    var body: some View {
        NavigationStack {
        ZStack {
            Color("lavenderColor")
                .ignoresSafeArea()

            // ── Content ────────────────────────────────────
            VStack(spacing: 32) {
                // push everything down a bit
                Spacer().frame(height: topPadding)

                // Greeting
                Text("Hey! How's it going?")
                    .font(.custom("Alexandria-Regular", size: 24).weight(.semibold))

                // Cow illustration
                Image("QuestionIcon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)

                // Prompt
                Text("What would you like to do?")
                    .font(.custom("Alexandria-Regular", size: 20).weight(.medium))

                // Two columns: Set Goal / Check In
                HStack(spacing: columnSpacing) {
                    // ── Set Goal Column ────────────────────
                    VStack(spacing: rowSpacing) {
                        Image("Set Goal Icon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: iconSize, height: iconSize)
                            .padding(.top, 18)
                            .padding(.bottom, 16)

                        Button {
                            showGoalFlow = true
                        } label: {
                            Image("Set Goal Button 1")
                                .resizable()
                                .scaledToFit()
                                .frame(height: buttonHeight)
                        }
                        .padding(.top, -19)

                        Text("Keep track of your progress by earning wellness points.")
                            .font(.custom("Alexandria-Regular", size: 13))
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                            .frame(width: descriptionWidth)
                            .padding(.top, 0)
                    }

                    // ── Check In Column ────────────────────
                    VStack(spacing: rowSpacing) {
                        Image("Check In Icon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: iconSize, height: iconSize)

                        Button {
                            showCheckInFlow = true
                        } label: {
                            Image("Check In Button")
                                .resizable()
                                .scaledToFit()
                                .frame(height: buttonHeight)
                        }

                        Text("Check in with how you're currently feeling.")
                            .font(.custom("Alexandria-Regular", size: 13))
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                            .frame(width: descriptionWidth)
                    }
                }

                Spacer() // push content up out of tab-bar
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, navBarHeight)
                
                VStack(spacing: 0) {
                    Spacer()
                    bottomTabBar
                }
        }
        .navigationDestination(isPresented: $showGoalFlow)    { GoalView() }
        .navigationDestination(isPresented: $showCheckInFlow) { CheckInView() }
            .navigationDestination(isPresented: $showHomeNav)     { HomeView() }
            .navigationDestination(isPresented: $showResource)    { ResourcesView() }
            .navigationDestination(isPresented: $showSetGoal)     { SetGoalView() }
            .navigationDestination(isPresented: $showAnalyticsNav){ AnalyticsPageView() }
            .navigationDestination(isPresented: $showSettingNav)  { SettingView() }
        .navigationBarBackButtonHidden(true)
        }
    }
    
    private var bottomTabBar: some View {
        HStack {
            Spacer()
            Button { withAnimation(.none) { showHomeNav = true } } label: {
                Image("Home Button")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 36, height: 36)
            }
            Spacer()
            Button { withAnimation(.none) { showResource = true } } label: {
                Image("Resource Button")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 36, height: 36)
            }
            Spacer()
            Button { withAnimation(.none) { showSetGoal = true } } label: {
                Image("Set Goal Button")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 36, height: 36)
            }
            Spacer()
            Button { withAnimation(.none) { showAnalyticsNav = true } } label: {
                Image("Analytics Button")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 36, height: 36)
            }
            Spacer()
            Button { withAnimation(.none) { showSettingNav = true } } label: {
                Image("Setting Button")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 36, height: 36)
            }
            Spacer()
        }
        .frame(height: navBarHeight)
        .padding(.top, 8)
        .background(
            Color.white
                .cornerRadius(30, corners: [.topLeft, .topRight])
                .edgesIgnoringSafeArea(.bottom)
                .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: -2)
        )
    }
}

struct SetGoalView_Previews: PreviewProvider {
    static var previews: some View {
        SetGoalView()
    }
}

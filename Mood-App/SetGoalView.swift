//
//  SetGoalView.swift
//  Mood-App
//
//  Created by Hieu Hoang on 4/22/25.
//

import SwiftUI

struct SetGoalView: View {
    // ── Navigation State ─────────────────────────────────────────────
    @State private var showGoalFlow     = false
    @State private var showCheckInFlow  = false

    // ── Layout Constants ─────────────────────────────────────────────
    private let navBarHeight: CGFloat = 50
    private let topPadding: CGFloat   = 80
    private let iconSize: CGFloat     = 60
    private let buttonHeight: CGFloat = 44
    private let columnSpacing: CGFloat = 40
    private let rowSpacing: CGFloat    = 16
    private let descriptionWidth: CGFloat = 120

    var body: some View {
        ZStack {
            Color("lavenderColor")
                .ignoresSafeArea()

            // ── Content ────────────────────────────────────
            VStack(spacing: 32) {
                // push everything down a bit
                Spacer().frame(height: topPadding)

                // Greeting
                Text("Hey! How's it going?")
                    .font(.system(size: 24, weight: .semibold))

                // Cow illustration
                Image("QuestionIcon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)

                // Prompt
                Text("What would you like to do?")
                    .font(.system(size: 20, weight: .medium))

                // Two columns: Set Goal / Check In
                HStack(spacing: columnSpacing) {
                    // ── Set Goal Column ────────────────────
                    VStack(spacing: rowSpacing) {
                        Image("Set Goal Icon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: iconSize, height: iconSize)

                        Button {
                            showGoalFlow = true
                        } label: {
                            Image("Set Goal Button 1")
                                .resizable()
                                .scaledToFit()
                                .frame(height: buttonHeight)
                        }

                        Text("Keep track of your progress by earning wellness points.")
                            .font(.caption)
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                            .frame(width: descriptionWidth)
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
                            .font(.caption)
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                            .frame(width: descriptionWidth)
                    }
                }

                Spacer() // push content up out of tab-bar
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, navBarHeight)
        }
        .navigationDestination(isPresented: $showGoalFlow)    { GoalView() }
        .navigationDestination(isPresented: $showCheckInFlow) { CheckInView() }
        .navigationBarBackButtonHidden(true)
    }
}

struct SetGoalView_Previews: PreviewProvider {
    static var previews: some View {
        SetGoalView()
    }
}

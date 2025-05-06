//
//  CheckInView.swift
//  Mood-App
//
//  Created by Hieu Hoang on 5/6/25.
//

import SwiftUI

struct CheckInView: View {
    // MARK: – Shared Data
    @EnvironmentObject var storeData: StoreData

    // MARK: – Navigation State
    @State private var showSurveyFlow    = false
    @State private var showJournalFlow   = false
    @State private var showHomeNav       = false
    @State private var showResourceNav   = false
    @State private var showSetGoalNav    = false
    @State private var showAnalyticsNav  = false
    @State private var showSettingNav    = false

    // MARK: – Layout Constants
    private let navBarHeight: CGFloat    = 50
    private let topPadding: CGFloat      = 80
    private let iconSize: CGFloat        = 60
    private let buttonHeight: CGFloat    = 44
    private let columnSpacing: CGFloat   = 40
    private let rowSpacing: CGFloat      = 16
    private let descriptionWidth: CGFloat = 120

    var body: some View {
        NavigationStack {
            ZStack {
                Color("lavenderColor")
                    .ignoresSafeArea()

                // ── Main Content ─────────────────────────────
                VStack(spacing: 32) {
                    Spacer().frame(height: topPadding)

                    // Title
                    Text("Let’s check your moo’d.")
                        .font(.system(size: 24, weight: .semibold))

                    // Cow Illustration
                    Image("QuestionIcon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)

                    // Prompt
                    Text("How do you want to check in?")
                        .font(.system(size: 20, weight: .medium))

                    // Two Options
                    HStack(spacing: columnSpacing) {
                        // ── Survey Column ─────────────────
                        VStack(spacing: rowSpacing) {
                            Image("Survey Icon")
                                .resizable()
                                .scaledToFit()
                                .frame(width: iconSize, height: iconSize)

                            Button {
                                showSurveyFlow = true
                            } label: {
                                Image("Survey Button")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: buttonHeight)
                            }

                            Text("Answer a couple questions about your current mood.")
                                .font(.caption)
                                .foregroundColor(.black)
                                .multilineTextAlignment(.center)
                                .frame(width: descriptionWidth)

                            Text("About 2–5 minutes")
                                .font(.footnote)
                                .fontWeight(.semibold)
                        }

                        // ── Journal Column ─────────────────
                        VStack(spacing: rowSpacing) {
                            Image("Journal Icon")
                                .resizable()
                                .scaledToFit()
                                .frame(width: iconSize, height: iconSize)

                            Button {
                                showJournalFlow = true
                            } label: {
                                Image("Journal Button")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: buttonHeight)
                            }

                            Text("Write about how you’re currently feeling in a journal.")
                                .font(.caption)
                                .foregroundColor(.black)
                                .multilineTextAlignment(.center)
                                .frame(width: descriptionWidth)

                            Text("About 5–10 minutes")
                                .font(.footnote)
                                .fontWeight(.semibold)
                        }
                    }

                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .padding(.bottom, navBarHeight)

                // ── Bottom Tab Bar ───────────────────────────────
                VStack {
                    Spacer()
                    bottomTabBar
                }
            }
            // ── Destinations ──────────────────────────────────
            .navigationDestination(isPresented: $showSurveyFlow) {
                SurveyQuestionaireView()
                    .environmentObject(storeData)
            }
            .navigationDestination(isPresented: $showJournalFlow) {
                JournalView()
                    .environmentObject(storeData)
            }
            .navigationDestination(isPresented: $showHomeNav)      { HomeView() }
            .navigationDestination(isPresented: $showResourceNav)  { ResourcesView() }
            .navigationDestination(isPresented: $showSetGoalNav)   { SetGoalView() }
            .navigationDestination(isPresented: $showAnalyticsNav) { AnalyticsPageView() }
            .navigationDestination(isPresented: $showSettingNav)   { SettingView() }
            .navigationBarBackButtonHidden(true)
        }
    }

    // MARK: – Bottom Tab Bar
    private var bottomTabBar: some View {
        HStack {
            Spacer()
            Button { showHomeNav = true } label: {
                Image("Home Button")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 36, height: 36)
            }
            Spacer()
            Button { showResourceNav = true } label: {
                Image("Resource Button")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 36, height: 36)
            }
            Spacer()
            Button { showSetGoalNav = true } label: {
                Image("Set Goal Button")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 36, height: 36)
            }
            Spacer()
            Button { showAnalyticsNav = true } label: {
                Image("Analytics Button")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 36, height: 36)
            }
            Spacer()
            Button { showSettingNav = true } label: {
                Image("Setting Button")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 36, height: 36)
            }
            Spacer()
        }
        .frame(height: navBarHeight)
        .background(Color.white.opacity(0.9))
    }
}

struct CheckInView_Previews: PreviewProvider {
    static var previews: some View {
        CheckInView()
            .environmentObject(StoreData())
    }
}

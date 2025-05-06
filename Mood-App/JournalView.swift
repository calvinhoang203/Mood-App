//
//  JournalView.swift
//  Landmarks - Manushri
//

import SwiftUI
import UIKit

struct JournalView: View {
    // MARK: – Shared Data
    @EnvironmentObject var storeData: StoreData

    // MARK: – Journal State
    @State private var journalEntry    = "Enter your thoughts here..."
    @State private var entries: [String] = []
    @State private var userEdited      = false

    // MARK: – Camera State
    @State private var isShowingCamera = false
    @State private var capturedImage: UIImage?

    // MARK: – Navigation State
    @State private var showCheckInFlow   = false
    @State private var showHomeNav       = false
    @State private var showResourceNav   = false
    @State private var showSetGoalNav    = false
    @State private var showAnalyticsNav  = false
    @State private var showSettingNav    = false

    // MARK: – Layout Constants
    private let navBarHeight: CGFloat  = 64
    private let topPadding: CGFloat    = 80
    private let textEditorHeight: CGFloat = 300

    var body: some View {
        NavigationStack {
            ZStack {
                Color("lavenderColor")
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 24) {
                        Spacer().frame(height: topPadding)

                        // — Title —
                        Text("Write what you’re feeling. Include as much or as little detail as you’d like.")
                            .font(.system(size: 20, weight: .semibold))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 16)

                        // — Cow —
                        Image("QuestionIcon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 150)

                        // — Photo Prompt & Button —
                        HStack(alignment: .center) {
                            Text("Want to check in with a photo")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Image(systemName: "camera.fill")
                                .foregroundColor(.gray)
                            Text("?")
                                .font(.subheadline)
                                .foregroundColor(.gray)

                            Spacer()

                            Button {
                                isShowingCamera = true
                            } label: {
                                Text("Take Photo")
                                    .font(.subheadline)
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 16)
                                    .background(Color("d3cpurple"))
                                    .foregroundColor(.white)
                                    .cornerRadius(20)
                            }
                        }
                        .padding(.horizontal, 16)

                        // — Show Captured Image (if any) —
                        if let image = capturedImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 200, height: 200)
                                .cornerRadius(10)
                        }

                        // — Journal TextEditor —
                        TextEditor(text: $journalEntry)
                            .padding(8)
                            .font(.body)
                            .foregroundColor(userEdited ? .primary : .gray)
                            .background(Color.white)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                            .frame(height: textEditorHeight)
                            .padding(.horizontal, 16)
                            .onTapGesture {
                                if !userEdited {
                                    journalEntry = ""
                                    userEdited = true
                                }
                            }

                        // — Submit Button —
                        Button {
                            saveEntry()
                            showCheckInFlow = true
                        } label: {
                            Image("Submit Button")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 44)
                                .padding(.horizontal, 40)
                        }
                        .padding(.top, 16)

                        Spacer(minLength: navBarHeight + 16)
                    }
                }
                .sheet(isPresented: $isShowingCamera) {
                    ImagePicker(image: $capturedImage, sourceType: .camera)
                }

                // — Bottom Tab Bar —
                VStack {
                    Spacer()
                    bottomTabBar
                }
            }
            // MARK: – Navigation Destinations
            .navigationDestination(isPresented: $showCheckInFlow) {
                CheckInView()
                    .environmentObject(storeData)
            }
            .navigationDestination(isPresented: $showHomeNav)      { HomeView() }
            .navigationDestination(isPresented: $showResourceNav)  { ResourcesView() }
            .navigationDestination(isPresented: $showSetGoalNav)   { SetGoalView() }
            .navigationDestination(isPresented: $showAnalyticsNav){ AnalyticsPageView() }
            .navigationDestination(isPresented: $showSettingNav)  { SettingView() }
            .navigationBarBackButtonHidden(true)
        }
    }

    // MARK: – Save Logic
    private func saveEntry() {
        let trimmed = journalEntry.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty, userEdited else { return }
        entries.append(trimmed)
        journalEntry = ""
        userEdited    = false
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

// MARK: – ImagePicker for Camera
extension JournalView {
    struct ImagePicker: UIViewControllerRepresentable {
        @Binding var image: UIImage?
        var sourceType: UIImagePickerController.SourceType

        func makeCoordinator() -> Coordinator { Coordinator(self) }
        func makeUIViewController(context: Context) -> UIImagePickerController {
            let picker = UIImagePickerController()
            picker.sourceType = sourceType
            picker.delegate   = context.coordinator
            return picker
        }
        func updateUIViewController(_: UIImagePickerController, context _: Context) {}

        class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
            let parent: ImagePicker
            init(_ parent: ImagePicker) { self.parent = parent }
            func imagePickerController(_ picker: UIImagePickerController,
                                       didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
                if let uiImage = info[.originalImage] as? UIImage {
                    parent.image = uiImage
                }
                picker.dismiss(animated: true)
            }
        }
    }
}

struct JournalView_Previews: PreviewProvider {
    static var previews: some View {
        JournalView()
            .environmentObject(StoreData.demo)
    }
}

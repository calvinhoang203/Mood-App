//
//  GetProfileView.swift
//  Mental Health
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct GetProfileView: View {
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var phoneNumber: String = ""
    @State private var showAlert = false
    @State private var goToQuestion1 = false

    @EnvironmentObject var storeData: StoreData

    var body: some View {
        NavigationStack {
            ZStack {
                Color("lavenderColor")
                    .ignoresSafeArea()

                VStack(spacing: 20) {
                    Spacer()

                    Image("loginIcon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)

                    Text("Complete Your Profile")
                        .font(.custom("Alexandria", size: 24))
                        .foregroundColor(.black)

                    customTextField(title: "First Name *", text: $firstName)
                    customTextField(title: "Last Name *", text: $lastName)
                    customTextField(title: "Phone Number *", text: $phoneNumber)

                    // 🔘 Save and trigger navigation
                    Button(action: {
                        saveProfile()
                    }) {
                        Image("SaveButton")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 40)
                            .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 4)
                    }
                    .padding(.top, 10)

                    Button(action: {
                        goToQuestion1 = false
                    }) {
                        Text("Go Back to Sign Up")
                            .font(.custom("Alexandria", size: 16))
                            .foregroundColor(.blue)
                            .padding(.top, 10)
                    }

                    Spacer()
                }
                .padding(.horizontal, 20)
            }

            // ✅ Forward navigation to QuestionaireView with environment
            .navigationDestination(isPresented: $goToQuestion1) {
                QuestionaireView().environmentObject(storeData)
            }

            // ✅ Al ert
            .alert("All fields are required.", isPresented: $showAlert) {
                Button("OK", role: .cancel) { }
            }
        }
        .navigationBarBackButtonHidden(true)
    }

    func saveProfile() {
        if firstName.isEmpty || lastName.isEmpty || phoneNumber.isEmpty {
            showAlert = true
        } else {
            storeData.firstName = firstName
            storeData.lastName = lastName
            storeData.phoneNumber = phoneNumber
            goToQuestion1 = true
        }
    }
}

struct GetProfileView_Previews: PreviewProvider {
    static var previews: some View {
        GetProfileView().environmentObject(StoreData())
    }
}


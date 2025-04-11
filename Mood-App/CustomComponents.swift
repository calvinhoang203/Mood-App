//
//  CustomComponents.swift
//  Mental Health



import SwiftUI

struct customTextField: View {
    var title: String
    @Binding var text: String

    var body: some View {
        TextField(title, text: $text)
            .padding()
            .frame(height: 50)
            .background(Color.white)
            .cornerRadius(10)
            .foregroundColor(.black)
            .accentColor(.black) // Caret color
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(white: 0.4), lineWidth: 1) // Darker border
            )
            .foregroundColor(.black)
    }
}

struct customSecureField: View {
    var title: String
    @Binding var text: String
    @State private var isPasswordVisible: Bool = false

    var body: some View {
        ZStack(alignment: .trailing) {
            Group {
                if isPasswordVisible {
                    TextField(title, text: $text)
                        .textContentType(.password)
                } else {
                    SecureField(title, text: $text)
                        .textContentType(.password)
                }
            }
            .padding()
            .frame(height: 50)
            .background(Color.white)
            .cornerRadius(10)
            .foregroundColor(.black)
            .accentColor(.black) // Caret color
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(white: 0.4), lineWidth: 1) // Darker border
            )

            Button(action: {
                isPasswordVisible.toggle()
            }) {
                Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                    .foregroundColor(Color(white: 0.4)) // Darker gray eye icon
                    .padding(.trailing, 12)
            }
        }
    }
}

struct customButton: View {
    var title: String
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.custom("Alexandrida", size: 18))
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.black)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
        .padding(.horizontal, 40)
    }
}

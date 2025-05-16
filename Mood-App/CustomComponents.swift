//
//  CustomComponents.swift
//  Mental Health



import SwiftUI

struct customTextField: View {
    var title: String
    @Binding var text: String

    var body: some View {
        TextField("", text: $text)
          .placeholder(when: text.isEmpty) {
            Text(title).foregroundColor(.gray)
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
            .foregroundColor(.black)
    }
}

struct customSecureField: View {
  var title: String
  @Binding var text: String
  @State private var isPasswordVisible = false

  var body: some View {
    ZStack(alignment: .trailing) {
      Group {
        if isPasswordVisible {
          TextField("", text: $text)
            .textContentType(.password)
        } else {
          SecureField("", text: $text)
            .textContentType(.password)
        }
      }
      .placeholder(when: text.isEmpty) {
        Text(title)
          .foregroundColor(.gray)        // or .black.opacity(0.6)
      }
      .padding()
      .frame(height: 50)
      .background(Color.white)
      .cornerRadius(10)
      .accentColor(.black)
      .overlay(
          RoundedRectangle(cornerRadius: 10)
              .stroke(Color(white: 0.4), lineWidth: 1) // Darker border
      )
      Button {
        isPasswordVisible.toggle()
      } label: {
        Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
          .foregroundColor(.gray)       // darker eye icon
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

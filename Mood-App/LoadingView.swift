//
//  LoadingView.swift
//  Mental Health
//
//
//

import SwiftUI

struct LoadingView: View {
    @State private var progress: CGFloat = 0.0
    @State private var navigate = false

    var body: some View {
        NavigationStack {
            ZStack {
                // Figma gradient background
                LinearGradient(
                    gradient: Gradient(stops: [
                        .init(color: Color.white, location: 0.0),                      // very top
                        .init(color: Color(hex: "#FAAA44").opacity(0.4), location: 0.3),           // peach/orange in upper mid
                        .init(color: Color(hex: "#FAAA44").opacity(0.4), location: 0.5),           // maintain orange warmth
                        .init(color: Color(hex: "#E5E1F4"), location: 0.75),          // soft lavender lower down
                        .init(color: Color(hex: "#E5E1F4"), location: 1.0)            // bottom
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()



                VStack(spacing: 20) {
                    Spacer()

                    Image("LoadingIcon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 180, height: 180)

                    
                    ZStack(alignment: .leading) {
                        Capsule()
                            .frame(width: 270, height: 14)
                            .foregroundColor(Color(hex: "#C3B9D1"))

                        Capsule()
                            .frame(width: 270 * progress, height: 14)
                            .foregroundColor(Color(hex: "#8F81DC"))
                    }
                    .cornerRadius(20)
                    .padding(.top, -10) // Pull progress bar up

                    Text("We’re on the moove . . .")
                        .font(.custom("Alexandria", size: 18))
                        .foregroundColor(.black)

                    Spacer()
                }
            }
            .onAppear {
                Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { timer in
                    if self.progress < 1.0 {
                        self.progress += 0.02
                    } else {
                        timer.invalidate()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            navigate = true
                        }
                    }
                }
            }

        }
    }
}



#Preview {
    LoadingView()
}

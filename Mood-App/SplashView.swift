//
//  SplashView.swift
//  Mental Health
//
//  Created by Hieu Hoang on 3/7/25.
//
import SwiftUI

struct SplashView: View {
    var body: some View {
        ZStack {


            // Display the "welcome view" image from Assets
            Image("welcomeBackground")
                .resizable()
                .scaledToFit()
                .frame(width: 500)
                .ignoresSafeArea()
        }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}


import SwiftUI

struct Pet: View {
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image("lightgreencow")
                    .resizable()
                    .frame(height: 600)
                    .position(x: geometry.size.width / 1.55, y: geometry.size.height / 4) // Dynamically position at the top 1/3
                
                Image("OUTLINE")
                    .resizable()
                    .frame(height: 600)
                    .position(x: geometry.size.width / 1.55, y: geometry.size.height / 4) // Dynamically position at the top 1/3

                Image("videogame")
                    .resizable()
                    .frame(height: 600)
                    .position(x: geometry.size.width / 1.55, y: geometry.size.height / 4) // Dynamically position at the top 1/3
            }
        }
    }
}

#Preview {
    Pet()
}

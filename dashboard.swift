import SwiftUI

struct Dashboard: View {
    //@State private var currency = 265
    //@EnvironmentObject var sharedData: SharedData
    @EnvironmentObject var petCustomization: PetCustomization // Access shared data


    var body: some View {
        NavigationStack {
            ZStack {
                //Background image handling
                if UIImage(named: "homepageback") != nil {
                    Image("homepageback")
                        .resizable()
                        .frame(width: UIScreen.main.bounds.width)
                        .aspectRatio(contentMode: .fit)
                        .ignoresSafeArea()
                } else {
                    Color.gray
                        .ignoresSafeArea()
                    Text("Image not found: mentalhealthapp")
                        .foregroundColor(.white)
                        .font(.headline)
                }
// Layering the Custom Cow onto the Dashboard
                GeometryReader { geometry in
                    ZStack {
                        let imageWidth = geometry.size.width * 1.0
                        let imageHeight = geometry.size.height * 1.0
                        let position_x = geometry.size.width / 1.2
                        let position_y = geometry.size.height * 0.125

                        petCustomization.defaultcow
                            .resizable()
                            .scaledToFit()
                            .frame(width: imageWidth, height: imageHeight)
                            .position(x: position_x, y: position_y)

                        petCustomization.colorcow
                            .resizable()
                            .scaledToFit()
                            .frame(width: imageWidth, height: imageHeight)
                            .position(x: position_x, y: position_y)

                        petCustomization.topImage
                            .resizable()
                            .scaledToFit()
                            .frame(width: imageWidth, height: imageHeight)
                            .position(x: position_x, y: position_y)

                        petCustomization.extraImage
                            .resizable()
                            .scaledToFit()
                            .frame(width: imageWidth, height: imageHeight)
                            .position(x: position_x, y: position_y)

                        EditButtonView()
                            .position(x: position_x / 0.94, y: position_y / 0.55)
                    }
                }

                VStack {
                    GeometryReader { geometry in
                        VStack {
                            Text("Welcome User!")
                                .font(.custom("Alexandria-Regular", size: 18))
                                .foregroundColor(.black)
                                .frame(width: geometry.size.width * 0.8, alignment: .leading)
                                .padding(.top, 175)
                        }
                        .frame(maxWidth: .infinity)

                            VStack {
                                // Quote Box
                                VStack {
                                    Text("""
                                    ”Worrying does not take away tomorrow's troubles. It takes away today's peace.”
                                    """)
                                    .foregroundColor(.black)
                                    .font(.custom("Alexandria-Regular", size: 13))
                                    .frame(width: 275)
                                    .multilineTextAlignment(.center)
                                    .padding(.top, 25)
                                    //.padding(.bottom, 10)
                                    Text(" ~ Randy Armstrong")
                                        .foregroundColor(.black)
                                        .font(.custom("Alexandria-Regular", size: 11))
                                        .multilineTextAlignment(.center)
                                        .padding(.top, 5)
                                        .padding(.bottom, 15)

                                }
                                .frame(width: UIScreen.main.bounds.width * 0.85)
                                
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(radius: 10)

                                // Check-In Button
                                Button(action: {}) {
                                    Text("Begin Check In")
                                        .font(.custom("Alexandria-Regular", size: 13))
                                        .frame(width: 150, height: 30)
                                        .foregroundColor(Color.white)
                                        .background(Color("d3cpurple"))
                                        .cornerRadius(10)
                                        .padding(10)
                                }

                                // Points
                                VStack {
                                    Text("Dashboard")
                                        .font(.custom("Alexandria-Regular", size: 18))
                                        .foregroundColor(.black)
                                        .frame(width: geometry.size.width * 0.8, alignment: .leading)
                                }
                                .frame(maxWidth: .infinity)

                                // Progress Bar
                                ProgressBar(bar: Color("d3cpurple"), textColor: .black)
                                    .frame(width: UIScreen.main.bounds.width * 0.85)
                                    .frame(height: 175)
                                    .background(Color.white)
                                    .cornerRadius(10)
                                    .shadow(radius: 10)
                                    .padding()
                                Button(action: {}) {
                                    Text("Set a New Goal")
                                        .font(.custom("Alexandria-Regular", size: 13))
                                        .frame(width: 150, height: 30)
                                        .foregroundColor(Color.white)
                                        .background(Color("d3cpurple"))
                                        .cornerRadius(10)
                                        .padding(5)
                                }

                            }
                            .frame(minHeight: UIScreen.main.bounds.height * 0.6)
        
                        .padding(.top, 190)
                    }
                }
                VStack{
                    homebar()
                        .frame(maxWidth: .infinity)
                        .background(Color("lightd3cpurple"))
                }
                .frame(maxHeight: .infinity, alignment: .bottom) // Forces it to stick at bottom

                

                    
            } //zstack ends here
            .statusBar(hidden: true)
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
            
        }
    }
}

struct ProgressBar: View {

    
    var bar: Color
    var textColor: Color

    var body: some View {
        HStack {
            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.3), lineWidth: 15)
                    .frame(width: 120, height: 120)

                Circle()
                    .trim(from: 0.0, to: CGFloat(33) / 50)
                    .stroke(bar, style: StrokeStyle(lineWidth: 15, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .frame(width: 120, height: 120)

                VStack {
                    Text("33") //random value --> get from backend
                        .font(.custom("Alexandria-Bold", size: 22))
                        .foregroundColor(.black)
                    Text("points")
                        .font(.custom("Alexandria-Regular", size: 11))
                        .foregroundColor(.black)
                }
            }
            .padding(.trailing, 25)

            VStack(alignment: .leading, spacing: 5) {
                Text("You are \(50 - 33) points away from next reward")
                    .font(.custom("Alexandria-Regular", size: 14))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
            }
            .frame(width: UIScreen.main.bounds.width * 0.25, alignment: .leading)
        }
        .frame(height: 120)
        .padding()
    }
}

struct EditButtonView: View {
    
    var body: some View {
        NavigationLink(destination: PetView()) {
            ZStack {
                Circle()
                    .fill(Color.white)
                    .frame(width: 30, height: 30)
                    .shadow(radius: 2)
                
                Image(systemName: "pencil")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 14, height: 14)
                    .foregroundColor(.gray)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

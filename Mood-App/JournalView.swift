//
//  JournalView.swift
//  Landmarks - Manushri
//

import SwiftUI
import UIKit

struct JournalView: View {
    @State private var journalEntry = "Enter your thoughts here..."
    @State private var entries: [String] = [] // save journal entries
    @State private var userEdited = false // checks if the user has written anything in the journal entry
    @State private var placeholder: String = "Enter your thoughts here..."
    @State private var isShowingCamera = false // controls when to show camera
    @State private var capturedImage: UIImage? // stores the captured photo
    @State private var keyboardHeight: CGFloat = 0
    
    struct Constants {
        static let Background: Color = Color(red: 0.96, green: 0.96, blue: 0.96)
        static let Grey: Color = Color(red: 0.23, green: 0.23, blue: 0.23)
        static let NewBG: Color = Color(red: 0.9, green: 0.88, blue: 0.96)
        
    }
    
    func saveEntry() {
        if (journalEntry.isEmpty == false && journalEntry != "Enter your thoughts here...") { // checks if the journal entry has content to save
            entries.append(journalEntry)
            journalEntry = "" // return to clean slate after save button is pressed
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                // title
                VStack {
                    HStack { // new HStack to add button on left
                        Text("Want to check in with a photo?")
                            .padding(.top, 200)
                            .padding(.leading, -65)
                            .font(Font.custom("Alexandria", size: 16))
                            .foregroundColor(Constants.Grey)
                            .frame(width: 300, alignment: .top)
                        
                        // button to open camera
                        Button(action: {
                            isShowingCamera = true
                        }) {
                            HStack {
                                Image(systemName: "camera") // camera icon
                                Text("Take Photo") // button label
                            }
                            .font(.system(size: 10))
                            .controlSize(.large)
                            .padding(7)
                            .background(Color(red: 0.56, green: 0.51, blue: 0.86))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                        .padding(.top, 198) // Move it further down
                        .padding(.leading, -75)
                        .sheet(isPresented: $isShowingCamera) {
                            ImagePicker(image: $capturedImage, sourceType: .camera)
                        }
                    }
                    
                    // display captured image
                    if let image = capturedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                            .cornerRadius(10)
                            .padding(.top, 10)
                    }
                }
                
                Spacer().frame(height: 50) // adjusted height to move the editor down
                
                ScrollView {
                    journalTextEditor // extracted TextEditor
                }
                .frame(maxHeight: .infinity, alignment: .top) // ensures that the whole frame will be taken up
                
                Spacer() // pushes everything else down and separates the text box from the button
                
                // save journal entry
                Button(action: saveEntry) {
                    Text("Submit")
                        .font(Font.custom("Alexandria", size: 20))
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color.white)
                }
                .frame(width: 135, height: 35)
                .background(Color(red: 0.56, green: 0.51, blue: 0.86))
                .cornerRadius(10)
                .padding(.top, 20)
                .padding(.bottom, 80)
            }
            .frame(maxHeight: .infinity, alignment: .top) // ensures VStack uses all available space
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .background(Constants.NewBG)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Write what you’re feeling. Include as much or as little detail as you’d like.")
                        .multilineTextAlignment(.center)
                        .font(.headline) // adjust font size
                        .offset(y: 150) // move the title down
                }
            }
        }
    }
    
    // extracted TextEditor to simplify main body
    private var journalTextEditor: some View {
        VStack {
            TextEditor(text: $journalEntry)
                .padding(5)
                .font(Font.custom("Alexandria", size: 15))
                .frame(width: 300, height: 260)
                .background(Constants.Background)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.black, lineWidth: 0.2)
                )
                .foregroundColor(journalEntry == placeholder ? .gray : .primary)
                .onTapGesture {
                    if journalEntry == placeholder {
                        journalEntry = ""
                        userEdited = true
                    }
                }
        }
        .frame(maxWidth: .infinity)

    }
    
    
    // ImagePicker to handle camera
    struct ImagePicker: UIViewControllerRepresentable {
        @Binding var image: UIImage?
        var sourceType: UIImagePickerController.SourceType
        
        func makeCoordinator() -> Coordinator {
            Coordinator(self)
        }
        
        func makeUIViewController(context: Context) -> UIImagePickerController {
            let picker = UIImagePickerController()
            picker.sourceType = sourceType
            picker.delegate = context.coordinator
            return picker
        }
        
        func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
        
        class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
            let parent: ImagePicker
            
            init(_ parent: ImagePicker) {
                self.parent = parent
            }
            
            func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
                if let selectedImage = info[.originalImage] as? UIImage {
                    parent.image = selectedImage
                }
                picker.dismiss(animated: true)
            }
        }
    }
}



struct JournalView_Previews: PreviewProvider {
    static var previews: some View {
        JournalView()
    }
}

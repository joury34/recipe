import SwiftUI
import PhotosUI


struct AddRecipe: View {
    // start as nil value
    @State private var selectedPhoto: PhotosPickerItem? = nil // Holds the selected photo, starts as nil
    @State private var selectedPhotoData: Data? = nil // Holds the image data, starts as nil
    @State private var textInput=""
    @State private var description=""
    @State private var showIngredientPopup = false
    
    var body: some View {
        NavigationView {
            VStack {
                
                // PhotosPicker for uploading/changing photo
                PhotosPicker(
                    selection: $selectedPhoto,
                    matching: .images,
                    photoLibrary: .shared()
                ) {
                    ZStack {
                        
                        // Rectangle as the background for the upload area
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 410, height: 181)
                            .cornerRadius(10)
                            .padding(.top, 100)
                        
                        // If a photo is selected, show the image; otherwise, show the icon and text
                        if let selectedPhotoData,
                           let uiImage = UIImage(data: selectedPhotoData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                                .scaledToFill() // Ensures the image fills the entire rectangle
                                .frame(width: 430, height: 181)
                                .cornerRadius(4)
                                .padding(.top,100)
                        }
                        else {
                            // Default icon and text if no image is selected
                            VStack {
                                Image(systemName: "photo.badge.plus")
                                    .font(.system(size: 60)) // Adjust the size of the icon
                                    .padding(.top, 100)
                                
                                Text("Upload Photo")
                                    .foregroundColor(.black)
                                    .font(.headline)
                                
                            }
                            
                        }
                    }
                }
                
                
                
                // Title text field Section
                VStack(alignment: .leading, spacing: 10) {
                    Text("Title")
                        .font(.system(size: 24))
                        .fontWeight(.bold)
                    
                    TextField("Title", text: $textInput)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .frame(width: 380, height: 44)
                        .cornerRadius(8)
                }
                
                .padding()
                // Description text field Section
                VStack(alignment: .leading, spacing: 10) {
                    Text("Description")
                        .font(.system(size: 24))
                        .fontWeight(.bold)
                    
                    ZStack(alignment: .topLeading) {
                        
                        
                                   
                        // Placeholder text that appears when the TextEditor is empty
                        if description.isEmpty {
                            Text("Description")
                                .foregroundColor(.black)
                                .padding(.leading, 12)
                                .padding(.top, 8)
                        }
                        Rectangle()
                            .background(Color.gray) // Ensure the background is clear
                            .frame(width: 380, height: 150)

                        // TextEditor for the description input
                        TextEditor(text: $description)
//                                        .padding(.leading, 10)
//                                        .padding(.top, 8)
                            .frame(width: 380, height: 150) // Set the size for the TextEditor
                            .background(Color.clear)
                            .foregroundColor(.black) // Set the text color for input
                        
                        
                            
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray, lineWidth: 1) // Set the border color and thickness
                    )
                    .cornerRadius(8)
                }
                        .padding()
                ZStack {
                    VStack {
                        HStack {
                            // The "Add Ingredient" text that is not tappable
                            Text("Add Ingredient")
                                .font(.system(size: 24))
                                .font(.headline)
                                .fontWeight(.bold)
                            
                            Spacer()
                            
                            // The button with the "plus" icon that triggers the popup
                            Button(action: {
                                showIngredientPopup = true // Show the ingredient sheet
                            }) {
                                Image(systemName: "plus")
                                    .frame(width: 1.0)
                                    .font(.system(size: 24))
                                    .fontWeight(.bold)
                            }
                        }
                    }
                  
                    }
                
                
                                // Spacer to push content upwards
                Spacer().frame(height:150)
                
             
                
                
                
            }
            .padding()
            .task(id: selectedPhoto) {
                // Check if there's a selected photo
                if let selectedPhoto {
                    // Try to get the image data from the selected photo
                    if let data = try? await selectedPhoto.loadTransferable(type: Data.self) {
                        // Save the image data to display later
                        selectedPhotoData = data
                    }
                }
            }
            .navigationTitle("New Recipe")
            .toolbarBackground(Color.gray.opacity(0.1), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .navigationBarItems(trailing:
                NavigationLink(destination: FoodRecipes()) {
                    Text("Save")
                }
            )
           
        }
    }
}

#Preview {
    AddRecipe()
}


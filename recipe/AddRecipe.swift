import SwiftUI
import PhotosUI

struct AddRecipe: View {
    // State variables
    @State private var selectedPhoto: PhotosPickerItem? = nil
    @State private var selectedPhotoData: Data? = nil
    @State private var title = ""
    @State private var description = ""
    @State private var showIngredientPopup = false
   
    @StateObject private var viewModel = IngredientViewModel()
   

    var body: some View {
        ZStack {
            NavigationView {
                ScrollView {
                    VStack {
                        // PhotosPicker for uploading/changing photo
                        PhotosPicker(
                            selection: $selectedPhoto,
                            matching: .images,
                            photoLibrary: .shared()
                        ) {
                            ZStack {
                                Rectangle()
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(width: 410, height: 181)
                                    .cornerRadius(10)
                                    .padding()
                                    .overlay(
                                        Rectangle()
                                            .strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [7, 5]))
                                            .foregroundColor(Color("AccentColor"))
                                            .padding()
                                    )
                                
                                if let selectedPhotoData,
                                   let uiImage = UIImage(data: selectedPhotoData) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 430, height: 181)
                                        .cornerRadius(4)
                                } else {
                                    VStack {
                                        Image(systemName: "photo.badge.plus")
                                            .font(.system(size: 60))
                                        Text("Upload Photo")
                                            .foregroundColor(.black)
                                            .font(.headline)
                                    }
                                }
                            }
                        }
                        .padding(.top)
                        
                        // Title text field
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Title")
                                .font(.system(size: 24))
                                .fontWeight(.bold)
                            ZStack(alignment: .leading) {
                                if title.isEmpty {
                                    Text("Title")
                                        
                                        .padding(.leading, 8)
                                }
                                TextField("", text: $title)
                                    .padding()
                                    .foregroundColor(.black)
                                    .background(Color.gray.opacity(0.2))
                                    .frame(width: 380, height: 44)
                                    .cornerRadius(8)
                                    .textFieldStyle(PlainTextFieldStyle())
                            }
                        }
                        .padding()

                        // Description text field
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Description")
                                .font(.system(size: 24))
                                .fontWeight(.bold)
                            
                            ZStack(alignment: .topLeading) {
                                if description.isEmpty {
                                    Text("Description")
                                        
                                        .padding(.leading, 12)
                                        .padding(.top, 8)
                                }

                                TextEditor(text: $description)
                                    .frame(width: 380, height: 150)
                                    .scrollContentBackground(.hidden)
                                    .background(Color.gray.opacity(0.2))
                                    .foregroundColor(.black)
                            }
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray, lineWidth: 1)
                            )
                            .cornerRadius(8)
                        }
                        .padding()

                        // Add ingredient button and list
                        VStack(alignment: .leading) {
                            HStack {
                                Text("Add Ingredient")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    
                                Spacer()
                              
                                Button(action: {
                                    showIngredientPopup = true
                                }) {
                                    Image(systemName: "plus")
                                        .font(.system(size: 24))
                                }
                            }
                            .padding(.horizontal, 30)
                            
                            
    // View to display the ingredient information
    VStack(alignment: .center, spacing: 10) {
        ForEach(viewModel.ingredients) { ingredient in
        HStack {
        Spacer() // Push everything to the center
        RoundedRectangle(cornerRadius: 8)
        .fill(Color.gray.opacity(0.2))
        .frame(width: 380, height: 50) // Adjust width and height as needed
        .overlay(
            HStack(spacing: 10) {
            // Display the quantity
            Text("\(ingredient.quantity)")
            .font(.subheadline)
            .foregroundColor(.accentColor)
            
           // Display the ingredient name
            Text(ingredient.name)
            .font(.headline)
            .foregroundColor(.accentColor)
            .lineLimit(1)
            .padding(.leading, 5) // Add some space between quantity and name
                                   
             Spacer() // Push the measurement to the right
                
          // Display the measurement
            Text(ingredient.measurement.rawValue)
            .frame(width: 100, height: 30)
            .background(Color.accentColor.opacity(0.70))
            .font(.subheadline)
            .foregroundColor(.white)
            .cornerRadius(8)
                                                }
            .padding(.horizontal, 10) // Padding inside the HStack for better alignment
                                            )
             .cornerRadius(8)
             Spacer() // Push the rectangle everything to the center
                                    }
                                }
                            }


                            
                            
                            
                        }
                    }
                    .padding()
                }
                .navigationTitle("New Recipe")
                .navigationBarTitleDisplayMode(.large)
                .toolbarBackground(Color.gray.opacity(0.1), for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
                .navigationBarItems(trailing:
                    NavigationLink(destination: FoodRecipes()) {
                        Text("Save")
                    }
                )
            }
           

            // Full-screen popup overlay
            if showIngredientPopup {
                ZStack {
                    Color.black.opacity(0.9)
                        .ignoresSafeArea()
                        .onTapGesture {
                           showIngredientPopup = false
                     
                        }
                       
                    IngredientPopupView(
                        showPopup: $showIngredientPopup,
                        ingredientName: $viewModel.newIngredientName,
                        quantity: $viewModel.servingSize,
                        addIngredientAction: {
                            viewModel.addIngredient()
                        },
                        viewModel: viewModel
                    )
                    //.zIndex(20)
                    
                }
                //.transition(.scale)
                //.animation(.easeInOut, value: showIngredientPopup)
            }
        }
        .task(id: selectedPhoto) {
            if let selectedPhoto {
                if let data = try? await selectedPhoto.loadTransferable(type: Data.self) {
                    selectedPhotoData = data
                }
            }
        }
    }

}



#Preview {
    AddRecipe()
}


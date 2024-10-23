import SwiftUI
import PhotosUI

struct AddRecipe: View {
    // State variables
    @State private var selectedPhoto: PhotosPickerItem? = nil
    @State private var selectedPhotoData: Data? = nil
    @State private var title = ""
    @State private var description = ""
    @State private var showIngredientPopup = false
    @State private var ingredients: [Ingredient] = []

    // New ingredient fields
    @State private var newIngredientName = ""
    @State private var newMeasurement = "Spoon"
    @State private var newServingQuantity = 1

    var body: some View {
        NavigationView {
            ZStack {
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
                             //   .padding(.top, 30)
                                .overlay(
                                        Rectangle() // The shape for the dashed border
                                        .strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [7, 5])) // Create dashed stroke
                                        .foregroundColor(Color("AccentColor")) // Color for the dashed border
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

                    VStack(alignment: .leading, spacing: 10) {
                        Text("Title")
                            .font(.system(size: 24))
                            .fontWeight(.bold)
                        ZStack(alignment: .leading){
                            if title.isEmpty {
                                    // Placeholder text
                                    Text("Title")
                                    .foregroundColor(.black)
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

                    VStack(alignment: .leading, spacing: 10) {
                        Text("Description")
                            .font(.system(size: 24))
                            .fontWeight(.bold)
                        
                        ZStack(alignment: .topLeading) {
                            if description.isEmpty {
                                Text("Description")
                                    .foregroundColor(.black)
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
                        .padding()

                        List(ingredients) { ingredient in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(ingredient.name)
                                        .font(.headline)
                                    Text("\(ingredient.quantity) \(ingredient.measurement)")
                                        .font(.subheadline)
                                }
                            }
                        }
                    }
                }
                .padding()

                // Popup overlay
                if showIngredientPopup {
                    Color.black.opacity(0.4)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            // Dismiss popup when the overlay is tapped
                            showIngredientPopup = false
                        }

                    IngredientPopupView(
                        showPopup: $showIngredientPopup,
                        ingredientName: $newIngredientName,
                        measurement: $newMeasurement,
                        quantity: $newServingQuantity,
                        addIngredientAction: addIngredient
                    )
                    .transition(.scale)
                    .animation(.easeInOut, value: showIngredientPopup)
                }
            }
            .task(id: selectedPhoto) {
                if let selectedPhoto {
                    if let data = try? await selectedPhoto.loadTransferable(type: Data.self) {
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

    // Function to add the ingredient
    private func addIngredient() {
        let newIngredient = Ingredient(name: newIngredientName, measurement: newMeasurement, quantity: newServingQuantity)
        ingredients.append(newIngredient)
        // Reset the form
        newIngredientName = ""
        newMeasurement = "Spoon"
        newServingQuantity = 1
    }
}

// Ingredient model to store ingredient details
struct Ingredient: Identifiable {
    let id = UUID()
    var name: String
    var measurement: String
    var quantity: Int
}
#Preview {
    AddRecipe()
}


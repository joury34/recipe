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
                                    .overlay(
                                        Rectangle()
                                            .strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [7, 5]))
                                            .foregroundColor(Color("AccentColor"))
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

                        VStack(alignment: .leading, spacing: 10) {
                            Text("Title")
                                .font(.system(size: 24))
                                .fontWeight(.bold)
                            ZStack(alignment: .leading) {
                                if title.isEmpty {
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
                                    .onTapGesture {
                                        
                                    }
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

                            ForEach(ingredients) { ingredient in
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
                }
                .navigationTitle("New Recipe")
                .navigationBarTitleDisplayMode(.large) // Makes it large initially
                .toolbarBackground(Color.gray.opacity(0.1), for: .navigationBar)
                
                .toolbarBackground(.visible, for: .navigationBar)
                .navigationBarItems(trailing:
                    NavigationLink(destination: FoodRecipes()) {
                        Text("Save")
                    }
                )
            }
            .zIndex(0) // Ensures the navigation and content are behind the popup

            // Full-screen popup overlay
            if showIngredientPopup {
                ZStack {
                    // Full-screen black background overlay
                    Color.black.opacity(0.9)
                        .ignoresSafeArea()
                        .onTapGesture {
                            showIngredientPopup = false
                        }

                    IngredientPopupView(
                        showPopup: $showIngredientPopup,
                        ingredientName: $newIngredientName,
                        measurement: $newMeasurement,
                        quantity: $newServingQuantity,
                        addIngredientAction: addIngredient
                    )
                   
                }
               
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


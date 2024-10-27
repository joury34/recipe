import SwiftUI
import PhotosUI

struct AddRecipe: View {
    @Environment(\.presentationMode) var presentationMode  // For back navigation
    @State private var selectedPhoto: PhotosPickerItem? = nil
    @State private var selectedPhotoData: Data? = nil
    @State private var showIngredientPopup = false
    @ObservedObject var viewModel: RecipeIngredientViewModel  // Pass viewModel from FoodRecipes
    

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
                                        .frame(width: 410, height: 181)
                                        .cornerRadius(10)
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
                        .task(id: selectedPhoto) {
                            if let selectedPhoto {
                                Task {
                                    if let data = try? await selectedPhoto.loadTransferable(type: Data.self) {
                                        await MainActor.run {
                                            selectedPhotoData = data
                                            viewModel.newRecipeImage = data  // Pass image data to viewModel
                                        }
                                    }
                                }
                            }
                        }

                        // Title text field
                        VStack(alignment: .leading, spacing: 10) {
                        Text("Title")
                        .font(.system(size: 24))
                        .fontWeight(.bold)
                        ZStack(alignment: .leading) {
                            if viewModel.newRecipeTitle.isEmpty {
                        Text("Title")
                                                               
                        .padding(.leading, 8)
                        }
                            TextField("", text: $viewModel.newRecipeTitle)
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
                            if viewModel.newRecipeDescription.isEmpty {
                        Text("Description")
                                                               
                        .padding(.leading, 12)
                        .padding(.top, 8)
                                }

                        TextEditor(text: $viewModel.newRecipeDescription)
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
                                               




                        // Add Ingredient Button and Ingredient List Display
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

                            // Display Ingredients List
                            VStack(alignment: .center, spacing: 10) {
                                ForEach(viewModel.ingredients) { ingredient in
                                    HStack {
                                        Spacer()
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(Color.gray.opacity(0.2))
                                            .frame(width: 380, height: 50)
                                            .overlay(
                                                HStack(spacing: 10) {
                                                    Text("\(ingredient.quantity)")
                                                        .font(.subheadline)
                                                        .foregroundColor(.accentColor)
                                                    
                                                    
                                                    Text(ingredient.Ingredientname)
                                                        .font(.headline)
                                                        .foregroundColor(.accentColor)
                                                        .lineLimit(1)
                                                        .padding(.leading, 5)
                                                    Spacer()
                                                    
                                                    Text(ingredient.measurement.rawValue)
                                                        .padding(5)
                                                        .background(Color.accentColor.opacity(0.7))
                                                        .foregroundColor(.white)
                                                        .cornerRadius(8)
                                                }
                                                .padding(.horizontal, 10)
                                            )
                                        Spacer()
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                    .scrollDismissesKeyboard(.immediately)
                }
                .navigationTitle("New Recipe")
                .navigationBarTitleDisplayMode(.large)
                .toolbarBackground(Color.gray.opacity(0.1), for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Back") {
                            presentationMode.wrappedValue.dismiss()
                        }
                        .foregroundColor(.accentColor)
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Save") {
                            viewModel.addRecipe()  // Save recipe data to the viewModel
                            presentationMode.wrappedValue.dismiss()
                        }
                        .foregroundColor(.accentColor)
                    }
                }
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
                }
            }
        }
    }
}

// Add Preview
struct AddRecipe_Previews: PreviewProvider {
    static var previews: some View {
        AddRecipe(viewModel: RecipeIngredientViewModel())
    }
}


import SwiftUI
import PhotosUI

struct AddRecipe: View {
    @Environment(\.presentationMode) var presentationMode  // For back navigation
    @State private var selectedPhoto: PhotosPickerItem? = nil
    @State private var selectedPhotoData: Data? = nil
    @State private var showIngredientPopup = false
    @ObservedObject var viewModel: RecipeIngredientViewModel
    var recipeToEdit: Recipe? // Optional recipe for edit mode

    init(viewModel: RecipeIngredientViewModel, recipeToEdit: Recipe? = nil) {
        self.viewModel = viewModel
        self.recipeToEdit = recipeToEdit
    }

    var body: some View {
        ZStack {
            NavigationView {
                ScrollView {
                    VStack {
                        
                    //MARK:  PhotosPicker for uploading/changing photo
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
                                //MARK: if condtion to check if the user selcet a photo or not
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
                                            .foregroundColor(.uploadphoto)
                                            .font(.headline)
                                    }
                                }
                            }
                        }
                        .padding(.top)
                        //MARK: converting the photo into data to dispaly it to the user in the view
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

                        //MARK:  Title text field
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Title")
                                .font(.system(size: 24))
                                .fontWeight(.bold)
                            TextField("Title", text: $viewModel.newRecipeTitle)
                                .padding()
                              //  .foregroundColor(.black)
                                .background(Color.gray.opacity(0.2))
                                .frame(width: 380, height: 44)
                                .cornerRadius(8)
                                .textFieldStyle(PlainTextFieldStyle())
                        }
                        .padding()
                        

                        //MARK: Description TextEditor
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Description")
                                .font(.system(size: 24))
                                .bold()
                            ZStack(alignment: .topLeading) {
                                TextEditor(text: $viewModel.newRecipeDescription)
                                    .padding(.all, 10)
                                    .scrollContentBackground(.hidden)
                                    .background(Color.gray.opacity(0.2))
                                    .frame(width: 380, height: 130)
                                    .cornerRadius(10)
                                    .font(.system(size: 16))
                                    .onAppear {
                                        UITextView.appearance().backgroundColor = .clear
                                    }
                                if viewModel.newRecipeDescription.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                    Text("Description")
                                        .foregroundColor(Color.gray)
                                        .font(.system(size: 15))
                                        .padding(.horizontal, 14)
                                        .padding(.top, 16)
                                }
                            }
                        }
                        .padding()
                        

                        // MARK: Add Ingredient Button and Ingredient List Display
                        VStack(alignment: .leading) {
                            HStack {
                                Text("Add Ingredient")
                                    .padding()
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
                            
                            
                           //MARK: view the ingredient
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
                    ///to dismiss the keyboard
                    .scrollDismissesKeyboard(.immediately)
                }
                
                
                .navigationTitle(recipeToEdit != nil ? "New Recipe" : "New Recipe")
                .navigationBarTitleDisplayMode(.large)
                .toolbarBackground(Color.gray.opacity(0.1), for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
                
                
                //MARK: back buttton This will dismiss the view 
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            HStack {
                                Image(systemName: "chevron.left")
                                Text("Back")
                            }
                        }
                        .foregroundColor(.accentColor)
                    }
                    
                    
                    //MARK: This will ensure that the "Save" button is only enabled when all inputs are filled
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Save") {
                            if recipeToEdit != nil {
                                viewModel.updateRecipe()
                            } else {
                                viewModel.addRecipe()
                            }
                            presentationMode.wrappedValue.dismiss()
                        }
                        .foregroundColor(.accentColor)
                        .disabled(viewModel.newRecipeTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
                                  viewModel.newRecipeDescription.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
                                  viewModel.ingredients.isEmpty ||
                                  selectedPhotoData == nil) // Disable if photo is required
                    }
                    
                } ///end of the toolbar
            }

            //MARK: Full-screen popup overlay
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
        .onAppear {
            if let recipe = recipeToEdit {
                viewModel.editRecipe(recipe)
                // Set selectedPhotoData to display the existing image during editing
                if let existingImageData = viewModel.newRecipeImage {
                    selectedPhotoData = existingImageData
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


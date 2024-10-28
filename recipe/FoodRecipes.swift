import SwiftUI

struct FoodRecipes: View {
    @State private var isAddRecipePresented = false
    @State private var showIngredients = false
    @State private var selectedRecipe: Recipe? = nil
    @StateObject private var viewModel = RecipeIngredientViewModel()
    @State private var searchText = ""
    @State private var isDeleteAlertPresented = false // New state variable for delete alert

    var body: some View {
        NavigationView {
            ScrollView {
                if viewModel.recipes.isEmpty {
                    //MARK: Empty state view
                    VStack {
                        Image("recipe")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 325, height: 327)
                            .padding(.top, 70)
                        Text("There's no recipe yet")
                            .font(.system(size: 36))
                            .fontWeight(.bold)
                            .padding()
                        Text("Please add your recipes")
                            .font(.system(size: 22))
                            .foregroundColor(.gray)
                    }
                } else {
                    // MARK: Display recipes list
                    VStack(alignment: .leading, spacing: 20) {
                        ForEach(viewModel.recipes) { recipe in
                            VStack(alignment: .leading) {
                                if showIngredients && selectedRecipe == recipe {
                                    
                                    // Display description above the smaller image
                                    VStack(alignment: .leading, spacing: 8) {
                                        if let imageData = recipe.Recipeimage, let uiImage = UIImage(data: imageData) {
                                            Image(uiImage: uiImage)
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 420, height: 200) // Adjusted image size
                                                .clipped()
                                        }
                                        
                                        Text(recipe.RecipeDescrption)
                                            .font(.body)
                                            .foregroundColor(.gray)
                                            .padding(.horizontal)
                                            .padding(.bottom, 8)
                                    }
                                }
                            else {
                            // MARK: Full-size image when not in ingredient view
                            ZStack(alignment: .bottomLeading) {
                                if let imageData = recipe.Recipeimage, let uiImage = UIImage(data: imageData) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 420, height: 250)
                                        .clipped()
                                        .padding()
                                       
                                            
                                        }

                                        //MARK:  Overlay for title, description, and "See All" button
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(recipe.RecipeTitle)
                                                .font(.title2)
                                                .fontWeight(.bold)
                                                .foregroundColor(.white)
                                                .padding(.horizontal)

                                            HStack {
                                                Text(recipe.RecipeDescrption)
                                                    .font(.body)
                                                    .foregroundColor(.white)
                                                    .lineLimit(2)
                                                    .padding(.horizontal)
                                                Spacer()
                                                
                                                Button("See All") {
                                                    withAnimation {
                                                        showIngredients = true
                                                        selectedRecipe = recipe
                                                    }
                                                }
                                                .font(.footnote)
                                                .foregroundColor(.accentColor)
                                                .padding(.trailing, 15)
                                            }//end of Hstack
                                        }
                                         .padding()
                                        .cornerRadius(10)
                                    }
                                }
                            }
                            
                            if showIngredients && selectedRecipe == recipe {
                                // Container to ensure VStack aligns to the left
                                HStack(alignment: .top) {
                                    VStack(alignment: .leading, spacing: 10) {
                                        Text("Ingredient")
                                            .font(.title)
                                            .fontWeight(.bold)
                                    }
                                    .padding(.leading)
                                    Spacer()
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)

                                //MARK:  Display Ingredients List
                                VStack(alignment: .center, spacing: 10) {
                                    ForEach(recipe.ingredients) { ingredient in
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

                            // MARK: Delete button with confirmation alert
                                Button(action: {
                                    isDeleteAlertPresented = true // Show alert when delete button is pressed
                                }) {
                                    Text("Delete Recipe")
                                        .font(.headline)
                                        .foregroundColor(.red)
                                        .padding()
                                        .frame(width: 370, height: 50)
                                        .background(Color.delete)
                                        .cornerRadius(10)
                                }
                                .alert(isPresented: $isDeleteAlertPresented) { // Display confirmation alert
                                    Alert(
                                        title: Text("Delete a Recipe"),
                                        message: Text("Are you sure you want to delete this recipe?"),
                                        primaryButton: .destructive(Text("Yes")) {
                                            if let recipe = selectedRecipe {
                                                viewModel.deleteRecipe(recipe: recipe)
                                                showIngredients = false
                                                selectedRecipe = nil
                                            }
                                        },
                                        secondaryButton: .cancel(Text("No"))
                                    )
                                }
                                .searchable(text: $searchText)
                                .padding(.horizontal)
                                .padding(.top, 270)
                            }
                        }
                    }
                }
            }
        }
            .navigationTitle(showIngredients && selectedRecipe != nil ? selectedRecipe?.RecipeTitle ?? "Food Recipes" : "Food Recipes")
            .toolbarBackground(Color.gray.opacity(0.1), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    // Back button to close ingredient view and return to recipe list
                    if showIngredients {
                        Button(action: {
                            withAnimation {
                                showIngredients = false
                                selectedRecipe = nil
                            }
                        }) {
                            HStack {
                                Image(systemName: "chevron.left")
                                Text("Back")
                            }
                        }
                        .foregroundColor(.accentColor)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        if showIngredients, let recipe = selectedRecipe {
                            editRecipe(recipe: recipe)
                        } else {
                            isAddRecipePresented = true
                            selectedRecipe = nil
                        }
                    }) {
                        if showIngredients {
                            Text("Edit")
                                .foregroundColor(.accentColor)
                        } else {
                            Image(systemName: "plus")
                                .foregroundColor(.accentColor)
                        }
                    }
                    .fullScreenCover(isPresented: $isAddRecipePresented) {
                        AddRecipe(viewModel: viewModel, recipeToEdit: selectedRecipe)
                    }
                }
            }
        }
    }

    private func editRecipe(recipe: Recipe) {
        selectedRecipe = recipe
        isAddRecipePresented = true
    }
}

// Add Preview
struct FoodRecipes_Previews: PreviewProvider {
    static var previews: some View {
        FoodRecipes()
    }
}


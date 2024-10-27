import SwiftUI

struct FoodRecipes: View {
    @State private var isAddRecipePresented = false
    @State private var showIngredients = false
    @State private var selectedRecipe: Recipe? = nil
    @StateObject private var viewModel = RecipeIngredientViewModel()
    @State private var searchText = ""

    var body: some View {
        NavigationView {
            ScrollView {
                if viewModel.recipes.isEmpty {
                    // Empty state view
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
                    // Display recipes list
                    VStack(alignment: .leading, spacing: 20) {
                        ForEach(viewModel.recipes) { recipe in
                            ZStack(alignment: .bottomLeading) {
                                if let imageData = recipe.Recipeimage, let uiImage = UIImage(data: imageData) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 400, height: 300)
                                        .cornerRadius(10)
                                        .clipped()
                                }

                                // Overlay for title, description, and "See All"
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(recipe.RecipeTitle)
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                    
                                    HStack {
                                        Text(recipe.RecipeDescrption)
                                            .font(.body)
                                            .foregroundColor(.white)
                                            .lineLimit(2)
                                        
                                        Spacer()
                                        
                                        Button("See All") {
                                            withAnimation {
                                                showIngredients.toggle()
                                                selectedRecipe = recipe
                                            }
                                        }
                                        .font(.footnote)
                                        .foregroundColor(.orange)
                                    }
                                }
                                .padding()
                                .background(
                                    LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0.6), Color.clear]),
                                                   startPoint: .top,
                                                   endPoint: .bottom)
                                )
                                .cornerRadius(10)
                            }
                            .padding(.horizontal)

                            if showIngredients && selectedRecipe == recipe {
                                VStack(alignment: .leading, spacing: 8) {
                                    ForEach(recipe.ingredients) { ingredient in
                                        HStack {
                                            Text("\(ingredient.quantity)")
                                                .font(.subheadline)
                                                .foregroundColor(.accentColor)
                                            
                                            Text(ingredient.Ingredientname)
                                                .font(.headline)
                                                .foregroundColor(.accentColor)
                                                .lineLimit(1)
                                            
                                            Spacer()
                                            
                                            Text(ingredient.measurement.rawValue)
                                                .padding(5)
                                                .background(Color.accentColor.opacity(0.8))
                                                .foregroundColor(.white)
                                                .cornerRadius(8)
                                                .font(.subheadline)
                                        }
                                        .padding(.horizontal)
                                    }

                                    Button(action: {
                                        deleteRecipe(recipe: recipe)
                                    }) {
                                        Text("Delete Recipe")
                                            .font(.headline)
                                            .foregroundColor(.red)
                                            .padding()
                                            .frame(maxWidth: .infinity)
                                            .background(Color.white)
                                            .cornerRadius(10)
                                            .shadow(radius: 2)
                                    }
                                    .padding(.horizontal)
                                    .padding(.top, 10)
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Food Recipes")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        if showIngredients {
                            if let recipe = selectedRecipe {
                                editRecipe(recipe: recipe)
                            }
                        } else {
                            isAddRecipePresented = true
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
                        AddRecipe(viewModel: viewModel)
                    }
                }
            }
        }
    }

    private func deleteRecipe(recipe: Recipe) {
        if let index = viewModel.recipes.firstIndex(where: { $0.id == recipe.id }) {
            viewModel.recipes.remove(at: index)
            showIngredients = false
            selectedRecipe = nil
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


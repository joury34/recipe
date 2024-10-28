//
//  IngredientViewModel.swift
//  recipe
//
//  Created by Joury on 20/04/1446 AH.
//

import SwiftUI

class RecipeIngredientViewModel: ObservableObject {
     
    // Recipe properties
    @Published var recipes: [Recipe] = []  // Updated to `recipes` to match usage in views
    @Published  var newRecipeImage: Data? = nil
    @Published  var newRecipeTitle: String = ""
    @Published  var newRecipeDescription: String = ""  // Updated `newRecipeDes` to `newRecipeDescription` for clarity
        
        // Ingredient properties
        @Published var ingredients: [Ingredient] = []  // This stores a list of ingredients
        @Published var showPopup: Bool = false          // Controls popup visibility
        @Published var measurement: MeasurementType = .spoon
        @Published var servingSize: Int = 1
       
        // Temporary data for new ingredient
    @Published var newIngredientName: String = ""
    
    // Currently editing recipe (if any)
    @Published var editingRecipe: Recipe?
    
    

    
    
        // Function to add the ingredient
        func addIngredient() {
            let newIngredient = Ingredient(
                Ingredientname: newIngredientName,
                measurement: measurement,
                quantity: servingSize
            )
            ingredients.append(newIngredient)
            resetIngredientForm()
            showPopup = false
        }
        
        // Function to add a recipe
        func addRecipe() {
            let newRecipe = Recipe(
                Recipeimage: newRecipeImage,
                RecipeTitle: newRecipeTitle,
                RecipeDescrption: newRecipeDescription,
                ingredients: ingredients
            )
            recipes.append(newRecipe)
            resetRecipeForm()
            resetIngredientForm()
            ingredients.removeAll()
        }
        
    // Function to initialize editing for an existing recipe
    func editRecipe(_ recipe: Recipe) {
            editingRecipe = recipe
            newRecipeImage = recipe.Recipeimage
            newRecipeTitle = recipe.RecipeTitle
            newRecipeDescription = recipe.RecipeDescrption
            ingredients = recipe.ingredients
        }
        
     
    // Add the updateRecipe function to update an existing recipe
    func updateRecipe() {
            guard let editingRecipe = editingRecipe else { return }
            
            if let index = recipes.firstIndex(where: { $0.id == editingRecipe.id }) {
                recipes[index].Recipeimage = newRecipeImage
                recipes[index].RecipeTitle = newRecipeTitle
                recipes[index].RecipeDescrption = newRecipeDescription
                recipes[index].ingredients = ingredients
            }
            resetIngredientForm()
            resetRecipeForm()
            self.editingRecipe = nil
        }
    
    
    
    func deleteRecipe(recipe: Recipe) {
            if let index = recipes.firstIndex(where: { $0.id == recipe.id }) {
                recipes.remove(at: index)
                ingredients.removeAll() // Clear ingredients after deleting a recipe
            }
        }
     
     // function takes a MeasurementType as an argument and sets measurement to the new value.
     func updateMeasurement(to newMeasurement: MeasurementType) {
             measurement = newMeasurement
         }
    
    
     
    //function that increment the serving
     func incrementServing() {
         if servingSize < 20 {
             servingSize += 1
         }
     }
     //function tha  decrement the serving
     func decrementServing() {
         if servingSize > 1 {
             servingSize -= 1
         }
     }
     
    //This method clears any values from the new ingredient form so that the form is reset for the next entry.
    func resetIngredientForm() {
        newIngredientName = ""
        measurement = .spoon
        servingSize = 1
    }
    
    //This method clears any values from the new recipe form so that the form is reset for the next entry.
    func resetRecipeForm() {
        newRecipeImage = nil
        newRecipeTitle = ""
        newRecipeDescription = ""
    }
   
}

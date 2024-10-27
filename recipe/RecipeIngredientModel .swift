//
//  IngredientModel .swift
//  recipe
//
//  Created by Joury on 20/04/1446 AH.
//

import Foundation

 //Ingredient model to store ingredient details
 
struct Ingredient: Identifiable, Equatable {
    let id = UUID()
    var Ingredientname: String
    var measurement: MeasurementType
    var quantity: Int
    
    // Swift will synthesize Equatable if all properties conform to Equatable
}


enum MeasurementType: String, CaseIterable {
    case spoon = "🥄 Spoon"
    case cup = "🥛 Cup"
}

//Recipe model to store ingredient details
struct Recipe: Identifiable, Equatable {
    let id = UUID()
    var Recipeimage: Data?
    var RecipeTitle: String
    var RecipeDescrption: String
    var ingredients: [Ingredient]
}

//
//  IngredientModel .swift
//  recipe
//
//  Created by Joury on 20/04/1446 AH.
//

import Foundation


// Swift will synthesize Equatable if all properties conform to Equatable

//MARK: Ingredient model to store ingredient details
struct Ingredient: Identifiable, Equatable {
    let id = UUID()
    var Ingredientname: String
    var measurement: MeasurementType
    var quantity: Int
    
    
}
enum MeasurementType: String, CaseIterable {
    case spoon = "🥄 Spoon"
    case cup = "🥛 Cup"
}


//MARK: Recipe model to store ingredient details
struct Recipe: Identifiable, Equatable {
    let id = UUID()
    var Recipeimage: Data?
    var RecipeTitle: String
    var RecipeDescrption: String
    var ingredients: [Ingredient]
}

//
//  IngredientModel .swift
//  recipe
//
//  Created by Joury on 20/04/1446 AH.
//

import Foundation

 //Ingredient model to store ingredient details
 
struct Ingredient: Identifiable {
    let id = UUID()
    var name: String
    var measurement: MeasurementType
    var quantity: Int
}

enum MeasurementType: String, CaseIterable {
    case spoon = "🥄 Spoon"
    case cup = "🥛 Cup"
}


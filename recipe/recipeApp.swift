//
//  recipeApp.swift
//  recipe
//
//  Created by Joury on 17/04/1446 AH.
//

import SwiftUI

@main
struct recipeApp: App {
    var body: some Scene {
        WindowGroup {
            FoodRecipes()
                .accentColor(Color("AccentColor"))
        }
    }
}

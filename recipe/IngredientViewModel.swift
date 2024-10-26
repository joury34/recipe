//
//  IngredientViewModel.swift
//  recipe
//
//  Created by Joury on 20/04/1446 AH.
//

import SwiftUI

 class IngredientViewModel: ObservableObject {
    @Published var ingredients: [Ingredient] = [] //This stores a list of ingredients. Whenever this list changes
    @Published var showPopup: Bool = false //this is a Boolean property that controls whether a popup alert
    @Published var measurement: MeasurementType = .spoon
    @Published var servingSize: Int = 1
// stored temporary data
    var newIngredientName: String = ""
    //var newServingQuantity: Int = 1
    
 // Function to add the ingredient
 func addIngredient() {
     let newIngredient = Ingredient(name: newIngredientName, measurement: measurement, quantity: servingSize)
     ingredients.append(newIngredient) //added to the newingridiant array
     resetForm()
     //false to close the popup sheet after the ingredient is added.
     showPopup = false
     
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
    func resetForm() {
        newIngredientName = ""
        measurement = .spoon
        servingSize = 1
    }
   
}
